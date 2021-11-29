# Agora vamos usar bases de dados de verdade!
# Ajuste um MLP com quantas layers e unidades escondidas
# você preferir para prever se uma casa será vendida por
# mais de 25k.

base <- dataset_boston_housing()
x <- base$train$x
y <- base$train$y

x <- scale(x)
y <- as.numeric(y > 25)

# Model definition ---------------------------------------------

input <- layer_input(shape = ncol(x))
output <- input %>% 
  layer_dense(units = 32, activation = "relu") %>% 
  layer_dense(units = 64, activation = "relu") %>% 
  layer_dense(units = 512, activation = "relu") %>% 
  layer_dense(units = 1, activation = "sigmoid")

model <- keras_model(input, output)
model %>% compile(
  loss = loss_binary_crossentropy,
  optimizer = optimizer_adam(),
  metrics = list(metric_binary_accuracy)
)

# Model fitting ------------------------------------------------

model %>% 
  fit(x, y, batch_size = 32, epochs = 5, validation_split = 0.2)

preds <- predict(model, x)
table(preds > 0.5, y)
Metrics::auc(y, preds)
