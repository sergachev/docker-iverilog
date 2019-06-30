FROM debian:stretch as builder

ENV IVERILOG_VERSION=v10_2

# LABEL \
#       com.github.lerwys.docker.dockerfile="Dockerfile" \
#       com.github.lerwys.vcs-type="Git" \
#       com.github.lerwys.vcs-url="https://github.com/lerwys/docker-iverilog.git"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends\
        automake \
        autoconf \
        gperf \
        build-essential \
        flex \
        bison \
        git \
        ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /ivsrc
RUN git clone --branch=${IVERILOG_VERSION} https://github.com/steveicarus/iverilog.git
WORKDIR /ivsrc/iverilog
RUN sh autoconf.sh && \
    ./configure --prefix=/iverilog && \
    make && \
    make install


FROM debian:stretch
COPY --from=builder /iverilog /usr/local/
