## this is to confirm everything works
library(reticulate)
library(tensorflow)
library(keras)

## che configured as it should
tf$config$list_physical_devices("GPU")

library(VariantAnnotation)
library(tidyverse)
library(tidymodels)