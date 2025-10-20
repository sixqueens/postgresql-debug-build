#!/bin/bash
# PostgreSQL build script

set -e

echo "Starting PostgreSQL compilation..."

# Build PostgreSQL
make -j$(nproc)

echo "Running tests..."
make check

echo "Installing PostgreSQL..."
make install

echo "Building contrib modules..."
cd contrib
make -j$(nproc)
make install

echo "Build completed successfully!"
echo "PostgreSQL installed to: /usr/local/pgsql"