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

WORKDIR /app
# Copy build artifacts from build layer
COPY --from=build /usr/local ./usr/local
COPY --from=build /venv ./venv
COPY --from=build /programs ./programs

# add prank to commandline
RUN cp -R ./programs/prank/bin/* ../bin/

# add paml to commandline
RUN cp -R ./programs/paml4.9j/src/baseml ../bin/ &&\
  cp -R ./programs/paml4.9j/src/codeml ../bin/ &&\
  cp -R ./programs/paml4.9j/src/evolver ../bin/

# copy AlexandrusPS
COPY AlexandrusPS_Positive_selection_pipeline .

SHELL ["/bin/bash", "-c"]
RUN echo source /app/venv/bin/activate > ~/.bashrc

