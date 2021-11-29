# Ajuste uma MLP para a base do MNIST com uantas layers você preferir.
# O mais importante é lembrar da loss e da ativação da última camada.

base <- dataset_mnist()
x <- array_reshape(base$train$x/256, dim = c(60000, 784))
y <- to_categorical(base$train$y)

dim(x)
dim(y)

# Model definition ---------------------------------------------

input <- layer_input(shape = 784)
output <- input %>% 
  layer_dense(units = 128, activation = "relu") %>% 
  layer_dense(units = 256, activation = "relu") %>% 
  layer_dense(units = 10,  activation = "softmax")

model <- keras_model(input, output)

model %>% compile(
  loss = loss_categorical_crossentropy,
  optimizer = optimizer_adam(),
  metrics = list(metric_categorical_accuracy)
)

# Model fitting ------------------------------------------------

model %>% fit(x, y, batch_size = 32, epochs = 5, validation_split = 0.2)

preds <- predict(model, x)
clas <- apply(preds, 1, which.max) -1

table(clas, base$train$y)
