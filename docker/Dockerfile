FROM rocker/ml-verse

ADD tensorflow_server_gpu.yml /scripts/tensorflow_server_gpu.yml

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.3.1-0-Linux-x86_64.sh
# -b -p /opt/miniconda3
# /opt/miniconda3/bin/conda
RUN mkdir -p /opt
RUN bash Miniconda3-py310_23.3.1-0-Linux-x86_64.sh -b -p /opt/miniconda3

ENV PATH=${PATH}:/opt/miniconda3/bin
RUN conda clean -a
RUN df -h .
RUN conda env create -f /scripts/tensorflow_server_gpu.yml && conda clean -a

RUN /rocker_scripts/install_tensorflow.sh

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

