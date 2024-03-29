# Packages ----------------------------------------------------------------

devtools::load_all()
library(torch)
library(torchvision)

# Utils -------------------------------------------------------------------

# plotting callback

plot_callback <- luz_callback(
  name = "plot",
  on_fit_begin = function() {
    latent_dim <- ctx$model$latent_dim
    self$noise <- torch_randn(1, latent_dim, device = self$ctx$accelerator$device)
  },
  on_epoch_end = function() {
    img <- ctx$model$G(self$noise)
    img <- img$cpu()
    img <- (img[1,1,,,newaxis] + 1)/2
    img <- torch_stack(list(img, img, img), dim = 3)[..,1]
    img <- as.raster(as_array(img))
    plot(img)
  }
)

# Datasets and loaders ----------------------------------------------------

dir <- "~/Downloads/mnist" #caching directory

train_ds <- mnist_dataset(
  dir,
  download = TRUE,
  transform = transform_to_tensor
)

test_ds <- mnist_dataset(
  dir,
  train = FALSE,
  transform = transform_to_tensor
)

train_dl <- dataloader(train_ds, batch_size = 128, shuffle = TRUE)
test_dl <- dataloader(test_ds, batch_size = 128)

# Define the network ------------------------------------------------------

init_weights <- function(m) {
  if (grepl("conv", m$.classes[[1]])) {
    nn_init_normal_(m$weight$data(), 0.0, 0.02)
  } else if (grepl("batch_norm", m$.classes[[1]])) {
    nn_init_normal_(m$weight$data(), 1.0, 0.02)
    nn_init_constant_(m$bias$data(), 0)
  }
}

generator <- nn_module(
  "generator",
  initialize = function(latent_dim, out_channels) {
    self$main <- nn_sequential(
      nn_conv_transpose2d(latent_dim, 512, kernel_size = 4,
                          stride = 1, padding = 0, bias = FALSE),
      nn_batch_norm2d(512),
      nn_relu(),
      nn_conv_transpose2d(512, 256, kernel_size = 4,
                          stride = 2, padding = 1, bias = FALSE),
      nn_batch_norm2d(256),
      nn_relu(),
      nn_conv_transpose2d(256, 128, kernel_size = 4,
                          stride = 2, padding = 1, bias = FALSE),
      nn_batch_norm2d(128),
      nn_relu(),
      nn_conv_transpose2d(128, out_channels, kernel_size = 4,
                          stride = 2, padding = 3, bias = FALSE),
      nn_tanh()
    )
    self$main$apply(init_weights) # custom weight initialization
  },
  forward = function(input) {
    input <- input$view(c(input$shape, 1, 1))
    self$main(input)
  }
)

discriminator <- nn_module(
  "discriminator",
  initialize = function(in_channels) {
    self$main <- nn_sequential(
      nn_conv2d(in_channels, 16, kernel_size = 4, stride = 2, padding = 1, bias = FALSE),
      nn_leaky_relu(0.2, inplace = TRUE),
      nn_conv2d(16, 32, kernel_size = 4, stride = 2, padding = 1, bias = FALSE),
      nn_batch_norm2d(32),
      nn_leaky_relu(0.2, inplace = TRUE),
      nn_conv2d(32, 64, kernel_size = 4, stride = 2, padding = 1, bias = FALSE),
      nn_batch_norm2d(64),
      nn_leaky_relu(0.2, inplace = TRUE),
      nn_conv2d(64, 128, kernel_size = 4, stride = 2, padding = 1, bias = FALSE),
      nn_leaky_relu(0.2, inplace = TRUE)
    )
    self$main$apply(init_weights) # custom weight initialization
    self$linear <- nn_linear(128, 1)
  },
  forward = function(input) {
    x <- self$main(input)
    x <- torch_flatten(x, start_dim = 2)
    x <- self$linear(x)
    x[,1]
  }
)

dcgan <- torch::nn_module(
  initialize = function(latent_dim = 100, channels = 1) {
    
    self$latent_dim <- latent_dim
    self$channels <- channels
    
    self$G <- generator(latent_dim = latent_dim, out_channels = channels)
    self$D <- discriminator(in_channels = 1)
    
    self$bce <- torch::nn_bce_with_logits_loss()
  },
  set_optimizers = function(lr = 2*1e-4, betas = c(0.5, 0.999)) {
    list(
      discriminator = optim_adam(self$D$parameters, lr = lr, betas = betas),
      generator = optim_adam(self$G$parameters, lr = lr, betas = betas)
    )
  },
  loss = function(input, ...) {
    # generate a fake image
    batch_size <- input$shape[1]
    device <- input$device
    
    noise <- torch_randn(batch_size, self$latent_dim, device = device)
    fake <- self$G(noise)
    
    # create response vectors
    y_real <- torch_ones(batch_size, device = device)
    y_fake <- torch_zeros(batch_size, device = device)
    
    # return different loss depending on the optimizer
    if (ctx$opt_name == "discriminator")
      self$bce(self$D(input), y_real) + self$bce(self$D(fake$detach()), y_fake)
    else if (ctx$opt_name == "generator")
      self$bce(self$D(fake), y_real)
  }
)

dcgan <- setup(dcgan)

res <- dcgan %>%
  set_hparams(latent_dim = 100, channels = 1) %>%
  fit(train_dl, epochs = 10, valid_data = test_dl, callbacks = list(plot_callback()))

# Generate picture -------------------------------------------------

noise <- torch_randn(1, 100, device = res$model$G$parameters[[1]]$device)
img <- res$model$G(noise)
img <- img$cpu()
img <- (img[1,1,,,newaxis] + 1)/2
img <- torch_stack(list(img, img, img), dim = 3)[..,1]
img <- as.raster(as_array(img))
plot(img)

# Serialization ----------------------------------------------------

luz_save(res, "mnist-dcgan.pt")