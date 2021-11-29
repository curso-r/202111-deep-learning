# Ajuste uma rede neural para prever as classes do CIFAR10.

library(keras)

base <- dataset_cifar10()
x <- base$train$x/256
y <- to_categorical(base$train$y)

dim(x)
dim(y)

# Model definition ---------------------------------------------

input <- layer_input(shape = c(32, 32, 3))
output <- input %>% 
  
  layer_conv_2d(filters = 32, kernel_size = c(3,3), padding = "same", activation = "relu") %>% 
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  
  layer_conv_2d(filters = 64, kernel_size = c(3,3), padding = "same", activation = "relu") %>% 
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  
  layer_conv_2d(filters = 128, kernel_size = c(3,3), padding = "same", activation = "relu") %>% 
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  
  layer_conv_2d(filters = 356, kernel_size = c(3,3), padding = "same", activation = "relu") %>% 
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  
  layer_conv_2d(filters = 512, kernel_size = c(3,3), padding = "same", activation = "relu") %>% 
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  
  layer_flatten() %>% 
  
  # MLP
  layer_dense(units = 128, activation = "relu") %>% 
  layer_dense(units = 256, activation = "relu") %>% 
  layer_dense(units = 10,  activation = "softmax")

model <- keras_model(input, output)
model

model %>% compile(
  loss = loss_categorical_crossentropy,
  optimizer = optimizer_adam(),
  metrics = list(metric_categorical_accuracy)
)

# Model fitting ------------------------------------------------

model %>% fit(x, y, batch_size = 32, epochs = 5, validation_split = 0.2)

preds <- predict(model, x)
