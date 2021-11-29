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


# Model fitting ------------------------------------------------




