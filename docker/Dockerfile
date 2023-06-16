FROM rocker/ml-verse

ADD tensorflow_server_gpu.yml /scripts/tensorflow_server_gpu.yml

RUN Rscript -e "reticulate::install_miniconda()"
# /root/.local/share/r-miniconda
# /root/.local/share/r-miniconda/bin/conda

ENV PATH=${PATH}:/root/.local/share/r-miniconda/bin
RUN conda env create -f /scripts/tensorflow_server_gpu.yml

RUN /rocker_scripts/install_tensorflow.sh

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

