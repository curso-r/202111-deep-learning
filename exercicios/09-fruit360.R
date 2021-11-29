#download.file("https://storage.googleapis.com/deep-learning-com-r/fruit360.rds", "fruit360.rds")
base <- readRDS("fruit360.rds")

x <- base$x/256

classes <- unique(base$y)
y <- match(base$y, classes) - 1

library(keras)
library(tensorflow)
library(tfhub)

y <- to_categorical(y)

# Definir modelo -------------------------------

input <- layer_input(shape = c(96, 96, 3))

output <- input %>% 
  
  layer_hub(
    handle = "https://tfhub.dev/google/imagenet/mobilenet_v2_075_96/feature_vector/5",
    trainable = FALSE
  ) %>% 
  
  layer_dense(512, activation = "relu") %>% 
  layer_dense(131, activation = "softmax") 

model <- keras_model(input, output)

model %>% compile(
  loss = loss_categorical_crossentropy,
  optimizer = optimizer_adam(),
  metrics = metric_categorical_accuracy
)

# Ajustar modelo -------------------------------

model %>% fit(
  x = x, 
  y = y,
  epochs = 5,
  batch_size = 64,
  validation_split = 0.2
)

plot(as.raster(x[4,,,]))
pred <- predict(model, x[4,,,,drop = FALSE])
classes[which.max(pred)]

# Modelo do zero ----------------------------------------------------------

input <- layer_input(shape = c(96, 96, 3))

output <- input %>% 
  
  layer_conv_2d(kernel_size = c(3,3), filters = 32, 
                activation = "relu", padding = "same", use_bias = FALSE) %>%
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  
  layer_conv_2d(kernel_size = c(3,3), filters = 64, 
                activation = "relu", padding = "same", use_bias = FALSE) %>% 
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  
  layer_conv_2d(kernel_size = c(3,3), filters = 128, 
                activation = "relu", use_bias = FALSE) %>% 
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  
  layer_conv_2d(kernel_size = c(3,3), filters = 256, 
                activation = "relu", padding = "same", use_bias = FALSE) %>% 
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  
  layer_flatten() %>%  
  
  layer_dense(512, activation = "relu") %>% 
  layer_dense(131, activation = "softmax") 

model <- keras_model(input, output)

model %>% compile(
  loss = loss_categorical_crossentropy,
  optimizer = optimizer_adam(),
  metrics = metric_categorical_accuracy
)

model %>% fit(
  x = x, 
  y = y,
  epochs = 5,
  batch_size = 64,
  validation_split = 0.2
)