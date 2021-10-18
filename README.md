
<!-- README.md is generated from README.Rmd. Please edit that file -->

Repositório com material das aulas de deep learning com R.

## Ementa

-   **Introdução**
    -   O que é e quando utilizar Deep Learning
    -   O que são redes neurais profundas
-   **Ajuste**
    -   Ajustando modelos de deep learning no R
    -   O pacote `keras`
    -   Técnicas de regularização
-   **Arquiteturas**
    -   Redes neurais recorrentes (RNN)
    -   Redes neurais convolucionais (CNN)
    -   *Long short-term memory* (LSTM)

## Informações importantes

-   [Clique
    aqui](https://github.com/curso-r/main-deep-learning/raw/master/material_do_curso.zip)
    para baixar o material do curso.

-   Nosso blog: <https://curso-r.com/blog/>

-   Nossos livros: [Ciência de Dados em R](https://livro.curso-r.com/) e
    [Zen do R](https://curso-r.github.io/zen-do-r/)

## Instalação

Os seguintes programas serão instalados. Estamos prevendo algum tempo no
início do curso para instalar os pacotes mas se você já conseguir
instalar, melhor!

1.  Instale o R! De preferência a versão mais recente (>= 4.0).

No Windows você também precisa instalar o [Microsoft Visual C++
Redistributable for Visual Studio 2015, 2017 and
2019](https://support.microsoft.com/help/2977003/the-latest-supported-visual-c-downloads).
Baixar a versão x64.

2.  Execute as seguintes linhas de código em uma sessão limpa do R.
    (Certifique-se de fechar todas as outras sessões do R/RStudio que
    estiverem abertas no seu computador).

<!-- -->

    install.packages("reticulate")
    reticulate::install_miniconda()
    install.packages(c("keras", "tfhub"))
    keras::install_keras()
    tfhub::install_tfhub()

3.  Verifique a instalação com:

<!-- -->

    tensorflow::tf_version() # deve retornar 2.4 ou maior

Nesse vídeo você pode ver o passo a passo da instalação no Windows:
<https://www.youtube.com/watch?v=nSOyfBulXlQ&feature=youtu.be>

## Dúvidas

Fora do horário de aula ou monitoria:

-   perguntas gerais sobre o curso deverão ser feitas no Classroom.

-   perguntas sobre R, principalmente as que envolverem código, deverão
    ser enviadas no [nosso fórum](https://discourse.curso-r.com/).

## Slides

| slides                                                                                  |
|:----------------------------------------------------------------------------------------|
| [slides/img/mlp.html](https://curso-r.github.io/main-deep-learning/slides/img/mlp.html) |
| [slides/index.html](https://curso-r.github.io/main-deep-learning/slides/index.html)     |
| [slides/index.pdf](https://curso-r.github.io/main-deep-learning/slides/index.pdf)       |

## Scripts utilizados em aula

| script |
|:-------|

## Lição de casa

| exercicio                                                                                                                       |
|:--------------------------------------------------------------------------------------------------------------------------------|
| [exercicios/01-linear-regression.R](https://curso-r.github.io/main-deep-learning/exercicios/01-linear-regression.R)             |
| [exercicios/02-mini-batch-sgd.R](https://curso-r.github.io/main-deep-learning/exercicios/02-mini-batch-sgd.R)                   |
| [exercicios/03-keras-linear-regression.R](https://curso-r.github.io/main-deep-learning/exercicios/03-keras-linear-regression.R) |
| [exercicios/04-boston-housing.R](https://curso-r.github.io/main-deep-learning/exercicios/04-boston-housing.R)                   |
| [exercicios/05-boston-housing-logistic.R](https://curso-r.github.io/main-deep-learning/exercicios/05-boston-housing-logistic.R) |
| [exercicios/06-mlp-mnist.R](https://curso-r.github.io/main-deep-learning/exercicios/06-mlp-mnist.R)                             |
| [exercicios/07-cifar-conv.R](https://curso-r.github.io/main-deep-learning/exercicios/07-cifar-conv.R)                           |
| [exercicios/08-dropout-batch-norm.R](https://curso-r.github.io/main-deep-learning/exercicios/08-dropout-batch-norm.R)           |
| [exercicios/09-fruit360.R](https://curso-r.github.io/main-deep-learning/exercicios/09-fruit360.R)                               |
| [exercicios/10-sarcasm.R](https://curso-r.github.io/main-deep-learning/exercicios/10-sarcasm.R)                                 |
| [exercicios/11-lstm-sarcasm.R](https://curso-r.github.io/main-deep-learning/exercicios/11-lstm-sarcasm.R)                       |
| [exercicios/12-pre-trained-sarcasm.R](https://curso-r.github.io/main-deep-learning/exercicios/12-pre-trained-sarcasm.R)         |
| [exercicios/13-bidirecional-sarcasm.R](https://curso-r.github.io/main-deep-learning/exercicios/13-bidirecional-sarcasm.R)       |
| [exercicios/14-quora.R](https://curso-r.github.io/main-deep-learning/exercicios/14-quora.R)                                     |

## Trabalhos finais premiados

Em breve

## Material extra

Referências extras comentadas nas aulas, ou materiais que comentamos
quando tiramos dúvidas (não necessariamente são relacionadas com o
conteúdo da aula).

| Aula | Tema | Descrição |
|:-----|:-----|:----------|

## Redes sociais da Curso-R

Youtube: <https://www.youtube.com/c/CursoR6/featured>

Instagram: <https://www.instagram.com/cursoo_r/>

Twitter: <https://twitter.com/curso_r>

Linkedin: <https://www.linkedin.com/company/curso-r/>

Facebook: <https://www.facebook.com/cursodeR>
