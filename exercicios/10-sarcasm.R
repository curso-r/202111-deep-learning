# Ajuste um modelo para prever se a manchete é sarcástica ou não.
# Use embeddings e global avg pooling.
# O banco de dados pode ser obtido com o código abaixo:

df <- readr::read_csv(
  pins::pin("https://storage.googleapis.com/deep-learning-com-r/headlines.csv")
  )

n_palavras <- stringr::str_count(df$headline, pattern = " +") + 1
quantile(n_palavras, c(0.5, 0.75, 0.85, 0.9, 0.95, 0.99, 1))


# Camada de vetorização

text_vec <- layer_text_vectorization(
  max_tokens = 20000, 
  output_mode = "int", 
  pad_to_max_tokens = 18
)

text_vec %>% adapt(df$headline)
vocab <- get_vocabulary(text_vec)

text_vec(df$headline[1:3])

# Definição do modelo

input <- layer_input(shape = 1, dtype = "string")
output <- input %>% 
  text_vec() %>% 
  layer_embedding(
    input_dim = length(vocab), 
    output_dim = 1
  ) %>% 
  layer_global_average_pooling_1d() %>% 
  #layer_dense(units = 16, activation = "relu") %>% 
  layer_activation("sigmoid")

model <- keras_model(input, output)
model

model %>% compile(
  loss = loss_binary_crossentropy,
  optimizer = optimizer_adam(),
  metrics = metric_binary_accuracy
)

# Ajuste do modelo

model %>% fit(
  x = df$headline,
  y = df$is_sarcastic,
  epochs = 20,
  batch_size = 64,
  validation_split = 0.2
)

w <- get_weights(model)
embeddings <- w[[3]]
rownames(embeddings) <- vocab

embeddings[order(-embeddings),,drop=FALSE][1:10,,drop=FALSE]
