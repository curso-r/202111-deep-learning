library(keras)

mnist <- dataset_mnist()
img <- mnist$train$x[1,,]/256

plot(as.raster(img))

# vamos criar um 'kernel' - w

w <- matrix(runif(9), nrow = 3, ncol = 3)
w <- cbind(c(0,0,0), c(1,1,1), c(0,0,0))

# vizinhança de tamanho 3x3
i <- 9
j <- 12

vizinhos <- img[i + (-1):1, j + (-1):1]
valor <- ativacao(sum(w*vizinhos + b))

new_img <- img
for (i in 2:(nrow(img) - 1)) {
  for (j in 2:(ncol(img) - 1)) {
    new_img[i, j] <- sum(img[i + (-1):1, j + (-1):1] * w)
  }
}
new_img <- new_img[-c(1, nrow(new_img)), -c(1, ncol(new_img))]

plot(as.raster(new_img/max(new_img)))


# ---------- como o Keras faz -----------------

w2 <- w
dim(w2) <- c(dim(w2), 1, 1)

conv <- layer_conv_2d(filters = 1, kernel_size = c(3,3), use_bias = FALSE,
                      weights = list(w2))

im <- img
dim(im) <- c(1, dim(img), 1)

dim(im)

new_im <- conv(im)
new_im <- as.array(new_im)[1,,,1]

all.equal(new_im, new_img)
