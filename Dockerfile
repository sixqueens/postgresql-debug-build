# Amazon Linux 2023 base image for PostgreSQL compilation
FROM amazonlinux:2023

# Install development tools and dependencies
RUN dnf update -y && \
    dnf groupinstall -y "Development Tools" && \
    dnf install -y \
    gcc \
    gcc-c++ \
    make \
    cmake \
    readline-devel \
    zlib-devel \
    openssl-devel \
    libxml2-devel \
    libxslt-devel \
    perl-ExtUtils-Embed \
    python3-devel \
    tcl-devel \
    uuid-devel \
    libuuid-devel \
    uuid-c++-devel \
    systemd-devel \
    libicu-devel \
    wget \
    tar \
    gzip \
    gdb \
    procps-ng \
    util-linux \
    shadow-utils \
    which \
    less \
    vim

# Create working directory
WORKDIR /usr/src

# Set environment variables
ENV POSTGRES_VERSION=16.1
ENV POSTGRES_URL=https://ftp.postgresql.org/pub/source/v${POSTGRES_VERSION}/postgresql-${POSTGRES_VERSION}.tar.gz

# Download and extract PostgreSQL source
RUN wget ${POSTGRES_URL} && \
    tar -xzf postgresql-${POSTGRES_VERSION}.tar.gz && \
    rm postgresql-${POSTGRES_VERSION}.tar.gz

WORKDIR /usr/src/postgresql-${POSTGRES_VERSION}

# Copy build scripts
COPY scripts/ /usr/src/scripts/
RUN chmod +x /usr/src/scripts/*.sh

# Default command
CMD ["/bin/bash"]