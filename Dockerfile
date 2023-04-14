
# # FROM rocker/r-base:3.6.3
FROM rocker/r-ver:3.6.3
LABEL maintainer="schavan@empresstx.com"

# SHELL ["/bin/bash", "-c"] 

# Install system dependencies for R
RUN apt-get update && apt-get clean && apt-get install -y --no-install-recommends \
        curl \
        default-libmysqlclient-dev \
        gcc \
        libcurl4-openssl-dev \
        libfftw3-dev \
        libxml2-dev \
        procps \
        && apt-get clean 

# to use install2.r function
RUN R -e "install.packages('littler', dependencies=TRUE)"
RUN R -e "install.packages('Rcpp', dependencies = TRUE, INSTALL_opts = '--no-lock')"

# Install R packages
RUN install2.r --error --deps TRUE --skipinstalled \
    readxl \
    dplyr \
    parallel \
    RPostgreSQL \
    RMySQL \
    BiocManager \
    writexl \
    && rm -rf /tmp/downloaded_packages

# RUN  install.packages('RPostgreSQL', dependencies=TRUE, repos='http://cran.rstudio.com/')
RUN Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/locfit/locfit_1.5-9.4.tar.gz", repos=NULL, type="source")' \
&& Rscript -e 'requireNamespace("BiocManager"); BiocManager::install();' \
&& Rscript -e 'requireNamespace("BiocManager"); BiocManager::install("EBImage")' \
&& Rscript -e 'requireNamespace("BiocManager"); BiocManager::install("DESeq2")' \
&& Rscript -e 'requireNamespace("BiocManager"); BiocManager::install("BiocParallel")'

# #updating Java version
# RUN curl -s "https://get.sdkman.io" | bash
# RUN source "/root/.sdkman/bin/sdkman-init.sh"
# RUN sdk install java

# ENV JAVA_HOME=/opt/java/openjdk
# COPY --from=eclipse-temurin:17 $JAVA_HOME $JAVA_HOME
# ENV PATH="${JAVA_HOME}/bin:${PATH}"

