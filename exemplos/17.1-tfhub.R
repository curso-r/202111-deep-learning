# Download the data:
# https://www.kaggle.com/c/jigsaw-toxic-comment-classification-challenge
# Download the word vectors:
# http://nlp.stanford.edu/data/glove.6B.zip


# Packages ----------------------------------------------------------------

library(tidyverse)
library(keras)

# Configuration -----------------------------------------------------------

FLAGS <- flags(
  flag_numeric("validation_split", 0.2),
  flag_integer("batch_size", 128),
  flag_integer("epochs", 10)
)

# Read dataset ------------------------------------------------------------

df <- readr::read_csv(
  pins::pin("https://storage.googleapis.com/deep-learning-com-r/toxic-comments.csv")
)

sentences <- df$comment_text
target <- df %>% 
  select(toxic, severe_toxic, obscene, threat, insult, identity_hate) %>% 
  as.matrix()

library(tidyverse)

text <- reticulate::import("tensorflow_text")

input <- layer_input(shape = shape(), dtype = "string")

encoded <- input %>% 
  tfhub::layer_hub("https://tfhub.dev/tensorflow/bert_multi_cased_preprocess/3") %>% 
  tfhub::layer_hub("https://tfhub.dev/tensorflow/bert_multi_cased_L-12_H-768_A-12/4", trainable = FALSE)

output <- encoded$sequence_output %>% 
  layer_lstm(units = 32, return_sequences = TRUE) %>% 
  layer_lstm(units = 32, return_sequences = TRUE) %>% 
  layer_global_max_pooling_1d() %>% 
  layer_dense(units = ncol(target), activation = "sigmoid")

model <- keras_model(input, output)

model %>% 
  compile(
    loss = "binary_crossentropy",
    optimizer = optimizer_adam(learning_rate = 0.01),
    metrics = keras::metric_auc()
  )

# Fitting -----------------------------------------------------------------

history <- model %>% 
  fit(
    x = sentences,
    y = target,
    batch_size = FLAGS$batch_size,
    epochs = FLAGS$epochs,
    validation_split = FLAGS$validation_split
  )

plot(history)