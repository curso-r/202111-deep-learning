# Agora vamos usar bases de dados de verdade!
# Ajuste um MLP com quantas layers e unidades escondidas
# você preferir.

library(keras)

base <- dataset_boston_housing()

x <- base$train$x
y <- base$train$y

x <- scale(x)
y <- scale(y)

# Model definition ---------------------------------------------

input <- layer_input(shape = ncol(x))
output <- input %>% 
  layer_dense(units = 32, activation = "relu") %>% 
  layer_dense(units = 64, activation = "relu") %>% 
  layer_dense(units = 512, activation = "relu") %>% 
  layer_dense(units = 1)

model <- keras_model(input, output)
model %>% compile(
  loss = loss_mean_squared_error,
  optimizer = optimizer_adam(),
  metrics = list(keras::metric_mean_squared_error)
)

# Model fitting ------------------------------------------------

model %>% 
  fit(x, y, batch_size = 32, epochs = 5, validation_split = 0.2)

preds <- predict(model, x)
plot(preds, y)


