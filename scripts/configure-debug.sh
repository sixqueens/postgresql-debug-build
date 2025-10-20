#!/bin/bash
# PostgreSQL debug configuration script with maximum debugging options

set -e

echo "Configuring PostgreSQL build with maximum debugging options..."

# Configure with debug options
./configure \
    --prefix=/usr/local/pgsql \
    --with-openssl \
    --with-readline \
    --with-zlib \
    --with-libxml \
    --with-libxslt \
    --with-perl \
    --with-python \
    --with-tcl \
    --with-uuid=ossp \
    --with-systemd \
    --with-icu \
    --enable-nls \
    --enable-thread-safety \
    --enable-debug \
    --enable-cassert \
    --enable-depend \
    CFLAGS="-g3 -O0 -fno-omit-frame-pointer" \
    CXXFLAGS="-g3 -O0 -fno-omit-frame-pointer"

echo "Debug configuration completed successfully!"
echo "This build includes:"
echo "  - Maximum debug symbols (-g3)"
echo "  - No optimization (-O0)"
echo "  - C assertions enabled"
echo "  - Frame pointer preservation"
echo "  - Contrib modules will be built by build.sh"