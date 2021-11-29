# Dataset

library(keras)

base <- dataset_cifar10()
x <- base$train$x/256
y <- to_categorical(base$train$y)

dim(x)
dim(y)

# Model definition ---------------------------------------------

library(tfhub)
library(tensorflow)

input <- layer_input(shape = c(32, 32, 3))


# handle = "https://tfhub.dev/google/imagenet/mobilenet_v2_075_96/feature_vector/4", 
# handle = "https://tfhub.dev/tensorflow/efficientnet/b4/feature-vector/1",
output <- input %>% 
  
  layer_lambda(function(x) tf$image$resize(x, c(299L, 299L))) %>% 
  layer_hub(
    handle = "https://tfhub.dev/google/imagenet/mobilenet_v2_075_96/feature_vector/5",
    trainable = FALSE
  ) %>% 
  
  layer_dense(512, activation = "relu") %>% 
  layer_dense(10, activation = "softmax") 


model <- keras_model(input, output)

model %>% 
  compile(
    loss = "categorical_crossentropy",
    optimizer = "adam",
    metrics = "accuracy"
  )

# Model fitting ------------------------------------------------

model %>% 
  fit(x, y, batch_size = 32, epochs = 5, validation_split = 0.2)  


save_model_tf(modelo_para_salvar, "modelo-pre-treinado/")


