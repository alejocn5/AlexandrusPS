# base layer
FROM ubuntu:20.04 AS base

# Environment
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=en_US.UTF-8

# build layer
FROM base AS build

# Update system and install packages
RUN apt-get update \
    && apt-get install -yq \
        build-essential \
        cpanminus \
	wget && \
	rm -rf /var/lib/apt/lists/*

# Install cpan modules
RUN cpanm Data::Dumper List::MoreUtils Array::Utils String::ShellQuote List::Util POSIX

# Install miniconda
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

# install R, dependencies, and proteinortho
COPY environment.yml .
RUN conda env create -f environment.yml

# install conda-pack, create standalone env as venv
RUN conda install -c conda-forge conda-pack && \
  conda clean -afy
RUN conda-pack -n alexandrusps -o /tmp/env.tar && \
  mkdir /venv && cd /venv && tar xf /tmp/env.tar && \
  rm /tmp/env.tar

RUN /venv/bin/conda-unpack

# get PRANK
FROM ariloytynoja/prank:latest AS prank

# install PAML


# run layer
FROM base AS runtime 

WORKDIR /app

# Copy build artifacts from build layer
COPY --from=build /usr/local ./usr/local
COPY --from=build /venv ./venv
#COPY --from=prank /data ./data

COPY AlexandrusPS_Positive_selection_pipeline .

SHELL ["/bin/bash", "-c"]
RUN echo source /app/venv/bin/activate > ~/.bashrc
