
FROM rocker/r-ver:4.2.3
LABEL maintainer="schavan@empresstx.com"

# Install system dependencies for R
RUN apt-get update && apt-get install -y --no-install-recommends libpq-dev zlib1g-dev && apt-get clean
RUN R -q -e 'install.packages(c("readxl", "dplyr", "RPostgreSQL", "RMySQL", "BiocManager", "writexl", "locfit"))'
RUN R -q -e 'BiocManager::install(); BiocManager::install(c("DESeq2", "BiocParallel", "EBImage"))'
