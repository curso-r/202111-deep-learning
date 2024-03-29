# Packages ----------------------------------------------------------------
library(torch)
library(torchvision)
library(torchdatasets)
library(luz)

set.seed(1)
torch_manual_seed(1)

# Datasets and loaders ----------------------------------------------------

dir <- "~/Downloads/dogs-vs-cats" #caching directory

ds <- torchdatasets::dogs_vs_cats_dataset(
  dir,
  token = "~/Downloads/kaggle.json",
  transform = . %>%
    torchvision::transform_to_tensor() %>%
    torchvision::transform_resize(size = c(224, 224)) %>% 
    torchvision::transform_normalize(rep(0.5, 3), rep(0.5, 3)),
  target_transform = function(x) as.double(x) - 1
)

train_id <- sample.int(length(ds), size = 0.7*length(ds))
train_ds <- dataset_subset(ds, indices = train_id)
valid_ds <- dataset_subset(ds, indices = which(!seq_along(ds) %in% train_id))

train_dl <- dataloader(train_ds, batch_size = 64, shuffle = TRUE, num_workers = 4)
valid_dl <- dataloader(valid_ds, batch_size = 64, num_workers = 4)

# Buildifng the network ---------------------------------------------------

net <- torch::nn_module(
  initialize = function(num_classes) {
    self$model <- model_alexnet(pretrained = TRUE)
    
    for (par in self$parameters) {
      par$requires_grad_(FALSE)
    }
    
    self$model$classifier <- nn_sequential(
      nn_dropout(0.5),
      nn_linear(9216, 512),
      nn_relu(),
      nn_linear(512, 256),
      nn_relu(),
      nn_linear(256, num_classes)
    )
  },
  forward = function(x) {
    self$model(x)[,1]
  }
)

# Train -------------------------------------------------------------------

fitted <- net %>%
  setup(
    loss = nn_bce_with_logits_loss(),
    optimizer = madgrad::optim_madgrad,
    metrics = list(
      luz_metric_binary_accuracy_with_logits()
    )
  ) %>%
  set_hparams(num_classes = 1) %>%
  set_opt_hparams(lr = 0.01) %>%
  fit(train_dl, epochs = 5, valid_data = valid_dl, verbose = TRUE)

# Make predictions --------------------------------------------------------

preds <- torch_sigmoid(predict(fitted, valid_dl))

# Serialization -----------------------------------------------------------
luz_save(fitted, "model-dogs-and-cats.pt")