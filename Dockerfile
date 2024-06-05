FROM ubuntu:23.04

COPY src/ViReMa_0.25 .
COPY src/READS .
COPY src/bowtie-0.12.9 usr/local/bin/bowtie-0.12.9
COPY src/Trimmomatic-0.39 usr/local/bin/Trimmomatic-0.39
# Add bowtie to PATH
ENV PATH="/usr/local/bin/bowtie-0.12.9:$PATH"
ENV PATH="/usr/local/bin/Trimmomatic-0.39:$PATH"


# Install dependencies
RUN apt-get update && apt-get install -y \
  curl \
  unzip \
  vim \
  pip \
  python3-pip \
  samtools \
  bzip2 && \
  apt-get autoclean && rm -rf /var/lib/apt/lists/*

# Installs numpy

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update

RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

RUN conda --version
RUN conda install -y bioconda/label/cf201901::trimmomatic
RUN conda install -y numpy
RUN chmod 777 /usr/local/bin/bowtie-0.12.9/bowtie
RUN chmod 777 /usr/local/bin/bowtie-0.12.9/bowtie-inspect
RUN chmod 777 /usr/local/bin/bowtie-0.12.9/bowtie-build
RUN conda install -y bioconda::bwa-mem2
RUN conda install -y python=3.10.6
RUN conda config --add channels conda-forge
RUN conda update -y -n base --all
RUN conda install -y -n base mamba
RUN conda install -y -c bioconda bowtie2
RUN apt update && apt install less

# Install minimap2 binary; make /data
ARG MINIMAP2_VER="2.24"
RUN curl -L https://github.com/lh3/minimap2/releases/download/v${MINIMAP2_VER}/minimap2-${MINIMAP2_VER}_x64-linux.tar.bz2 | tar -jxvf - && \
 mkdir /data

ENV PATH="${PATH}:/minimap2-${MINIMAP2_VER}_x64-linux"
                                                       
