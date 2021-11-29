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



# Ajuste ----------------------------------------------------------

