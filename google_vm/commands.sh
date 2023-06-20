
### become sudo to speed up commands
sudo su

apt-get update

## install R dependencies

apt-get remove libcurl4

apt-get -y install --no-install-recommends \
    ca-certificates \
    less \
    libopenblas-base \
    locales \
    vim-tiny \
    wget \
    dirmngr \
    gpg \
    gpg-agent \
	libcurl4 \
	libcurl4-openssl-dev

## Configure default locale
LANG=${LANG:-"en_US.UTF-8"}
/usr/sbin/locale-gen --lang "${LANG}"
/usr/sbin/update-locale --reset LANG="${LANG}"

## use gdebi as recommended by Posit
## https://docs.posit.co/resources/install-r/

apt-get install -y gdebi-core

### install R
R_VERSION=4.3.1

curl -O https://cdn.rstudio.com/r/debian-10/pkgs/r-${R_VERSION}_1_amd64.deb
gdebi -n r-${R_VERSION}_1_amd64.deb


### prepare for RStudio

ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R
ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript

## check
/opt/R/${R_VERSION}/bin/R --version


## download and install Rstudio
wget https://download2.rstudio.org/server/focal/amd64/rstudio-server-2023.06.0-421-amd64.deb
gdebi -n rstudio-server-2023.06.0-421-amd64.deb


## install python
export PYTHON_VERSION="3.10.0"

wget https://cdn.rstudio.com/python/debian-10/pkgs/python-${PYTHON_VERSION}_1_amd64.deb
gdebi -n python-${PYTHON_VERSION}_1_amd64.deb

## check
/opt/python/"${PYTHON_VERSION}"/bin/python --version

## update python tools
/opt/python/"${PYTHON_VERSION}"/bin/pip install --upgrade \
    pip setuptools wheel

## modify /etc/profile.d/python.sh
## add 
export PATH=/opt/python/${PYTHON_VERSION}/bin:${PATH}
echo "PATH=/opt/python/${PYTHON_VERSION}/bin:\${PATH}" >>/etc/profile.d/python.sh

### make it available as jupyter kernel
/opt/python/${PYTHON_VERSION}/bin/pip install ipykernel
/opt/python/${PYTHON_VERSION}/bin/python -m ipykernel install --name py${PYTHON_VERSION} --display-name "Python ${PYTHON_VERSION}"

## adding rocker install2.r command
mkdir -p /opt/scripts
cd /opt/scripts
vim install2.r
export PATH=${PATH}:/opt/scripts
chmod a+x install2.r


### make sure GPUS libraries are installed
conda install -y -c conda-forge cudatoolkit=11.8.0
python3 -m pip install nvidia-cudnn-cu11==8.6.0.163 tensorflow==2.12.*
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:$CUDNN_PATH/lib' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
source $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh

# install python libraries

pip install \
	tensorrt \
	numpy \
	tensorboard \
	nvidia-cublas-cu11 \
	google-auth \
	google-auth-oauthlib \
	keras \
	markdown \
	pandas \
	biopython

pip install tensorflow-hub tensorflow-datasets scipy requests Pillow h5py pandas pydot

# Verify install:
python3 -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"


### create user for rstudio
useradd -m rstudio -s /bin/bash
## password set in secret

## install importat R packages
apt-get install -y \
    libxml2-dev \
	libssl-dev \
	libfontconfig1-dev \
	libgsl-dev \
	libharfbuzz-dev \
	libfribidi-dev \
	libfreetype6-dev \
	libpng-dev \
	libtiff5-dev \
	libjpeg-dev
Rscript -e "install.packages(c('reticulate', 'tensorflow', 'keras', 'BiocManager'), repo='https://cloud.r-project.org/')"
Rscript -e "BiocManager::install(c('googledrive', 'googlesheets4', 'httr', 'rvest', 'ragg', 'xml2', 'Rfast'))"
Rscript -e "BiocManager::install(c('tidyclust', 'VariantAnnotation', 'tidyverse', 'tidymodels'))"
Rscript -e "BiocManager::install(c('doParallel'))"


### rstudio doesn't see all the proper library paths
# :/opt/conda/lib/:/opt/conda/lib/python3.7/site-packages/nvidia/cudnn/lib:/opt/conda/lib/:/opt/python/3.10.0/lib/python3.10/site-packages/nvidia/cudnn/lib
# from inside RStudio it only sees:
# /opt/R/4.3.1/lib/R/lib:/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/java-11-openjdk-amd64/lib/server

vim /etc/rstudio/rserver.conf
## add
# rsession-ld-library-path=/opt/R/4.3.1/lib/R/lib:/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/java-11-openjdk-amd64/lib/server:/opt/conda/lib/:/opt/python/3.10.0/lib/python3.10/site-packages:/opt/conda/lib/:/opt/python/3.10.0/lib/python3.10/site-packages/nvidia/cudnn/lib

