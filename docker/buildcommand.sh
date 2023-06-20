
######## this can only work with amd64
######## ML-verse being based on nvidia/cuda
######## has no arm64 architecture

docker buildx build \
--label org.opencontainers.image.title=deeplearning_rstudio \
--label org.opencontainers.image.description='container running RStudio on multiplatform to be used with UniPV course' \
--label org.opencontainers.image.url=https://github.com/lescailab/deeplearning_rstudio \
--label org.opencontainers.image.source=https://github.com/lescailab/deeplearning_rstudio --label org.opencontainers.image.version=1.0.0 \
--label org.opencontainers.image.created=2023-06-17T10:00:00.000Z \
--label org.opencontainers.image.licenses=MIT \
--platform linux/amd64 \
--tag ghcr.io/lescailab/deeplearning_rstudio:1.1.0 \
--tag ghcr.io/lescailab/deeplearning_rstudio:latest \
--push .