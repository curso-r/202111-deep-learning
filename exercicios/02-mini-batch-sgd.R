# Com base no modelo implementado abaixo, escreva o `for` loop
# necessário p/ implementar o Mini-batch SGD. 
# O tamanho do batch deve ser especificado por meio de uma variável
# chamada batch_size.


# Data generation ----------------------------------------------

n <- 1000

x <- runif(n)
W <- 0.9
B <- 0.1

y <- W * x + B

# Model definition ---------------------------------------------

model <- function(w, b, x) {
  w * x + b
}

loss <- function(y, y_hat) {
  mean((y - y_hat)^2)
}

# Estimating via SGD --------------------------------------------

dl_dyhat <- function(y_hat) {
  2 * (y - y_hat) * (-1)
}

dyhat_dw <- function(w) {
  x
}

dyhat_db <- function(b) {
  1
}

# Ajustar usando mini-batches ---------------------------------------------

w <- runif(1)
b <- 0

lr <- 0.1
batch_size <- 10

for (epoch in 1:2) {
  for (i in 1:(length(x)/batch_size)) {
    indices <- sample(1:length(x), size = batch_size)
    y_hat <- model(w, b, x)
    w <- w - lr*mean((dl_dyhat(y_hat) * dyhat_dw(w))[indices])
    b <- b - lr*mean((dl_dyhat(y_hat) * dyhat_db(b))[indices])
  }
  print(loss(y, y_hat))
}

w
b


