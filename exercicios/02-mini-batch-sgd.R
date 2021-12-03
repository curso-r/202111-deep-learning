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

batch_size <- 15

lr <- 0.1

for(epoch in 1:5) {
  numero_grupos <- as.integer(length(x)/batch_size)
  grupos <- sample.int(numero_grupos, size = length(x), replace = TRUE)
  indices <- split(1:length(x), f = grupos)
  for (ind in indices) {
    
    y_hat <- model(w, b, x)
    
    w <- w - lr*mean(dl_dyhat(y_hat)[ind] * dyhat_dw(w)[ind])
    b <- b - lr*mean(dl_dyhat(y_hat)[ind])
    
    if (step %% 10 == 0) {
      print(loss(y, y_hat))
    }
    
  }
}

w
b

for(ind in indices) {
  print(ind)
}


