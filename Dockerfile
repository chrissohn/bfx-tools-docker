FROM debian:buster-slim AS star

RUN apt-get update -qq \
  && apt-get install -y \
    wget \
    gcc \
    g++ \
    libz-dev \
    make

# https://github.com/alexdobin/STAR/releases/tag/2.6.1d
WORKDIR /
RUN wget -nv https://github.com/alexdobin/STAR/archive/2.6.1d.tar.gz \
  && tar xzf 2.6.1d.tar.gz && cd STAR-2.6.1d/source \
  && make STAR STARlong && make install
ENV PATH=/STAR-2.6.1d/bin:${PATH}

FROM biocontainers/biocontainers:latest
WORKDIR /
COPY --from=star /STAR-2.6.1d .
RUN conda install bedtools=2.25.0 && \
    conda install samtools=1.3.1
CMD STAR
