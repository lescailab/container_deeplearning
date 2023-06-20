## this is to confirm everything works
library(reticulate)
use_python("/opt/python/3.10.0/bin/python")
library(tensorflow)
library(keras)

## che configured as it should
tf$config$list_physical_devices("GPU")

library(VariantAnnotation)
library(tidyverse)
library(tidymodels)