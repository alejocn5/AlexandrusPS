# multistage build for docker image for AlexandrusPS pipeline 
FROM ubuntu:20.04 AS base
#FROM debian:stable-slim AS base

# Environment
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=en_US.UTF-8

# run time apps
RUN apt-get update && \
  apt-get install -yq screen \
  proteinortho \
  cpanminus \
  perl \
  r-base && \
  rm -rf /var/lib/apt/lists/*

# build layer
FROM base AS build

# Update system and install packages, libcurl for rstatix
RUN apt-get update && \
    apt-get install -yq \
	build-essential \
  libcurl4-openssl-dev \ 
  cmake \
	wget && \
	rm -rf /var/lib/apt/lists/*

# install R packages
RUN R -q -e 'install.packages(c("caret", "rstatix", "reshape2", "dplyr", "stringr"))' && \
    rm -rf /tmp/downloaded_packages

# install PRANK
WORKDIR /programs
RUN  wget http://wasabiapp.org/download/prank/prank.linux64.170427.tgz && \
  tar zxf prank.linux64.170427.tgz

# install PAML
RUN wget http://abacus.gene.ucl.ac.uk/software/paml4.9j.tgz && \
  tar xzf paml4.9j.tgz && \
  rm -rf paml4.9j.tgz && \
  cd paml4.9j/src && \
  make

# run layer
FROM base AS runtime 

# Copy build artifacts from build layer
COPY --from=build /usr/local /usr/local

# Install cpan modules (somehow doesn't work in build layer)
RUN cpanm Data::Dumper List::MoreUtils Array::Utils String::ShellQuote List::Util POSIX

COPY --from=build /programs /programs

# add prank to commandline
RUN cp -R ./programs/prank/bin/* ./bin/

# add paml to commandline
RUN cp -R ./programs/paml4.9j/src/baseml ./bin/ &&\
  cp -R ./programs/paml4.9j/src/codeml ./bin/ &&\
  cp -R ./programs/paml4.9j/src/evolver ./bin/

WORKDIR /app
# copy AlexandrusPS
COPY AlexandrusPS_Positive_selection_pipeline ./AlexandrusPS_Positive_selection_pipeline

# mark shell scripts as executable
WORKDIR /app/AlexandrusPS_Positive_selection_pipeline
RUN chmod +x *.sh

SHELL ["/bin/bash", "-c"]