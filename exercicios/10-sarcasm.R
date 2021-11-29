# Ajuste um modelo para prever se a manchete é sarcástica ou não.
# Use embeddings e global avg pooling.
# O banco de dados pode ser obtido com o código abaixo:

df <- readr::read_csv(
  pins::pin("https://storage.googleapis.com/deep-learning-com-r/headlines.csv")
  )

n_palavras <- stringr::str_count(df$headline, pattern = " +") + 1
quantile(n_palavras, c(0.5, 0.75, 0.85, 0.9, 0.95, 0.99, 1))


# Camada de vetorização


# Definição do modelo



# Ajuste do modelo
