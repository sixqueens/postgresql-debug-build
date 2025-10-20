#!/bin/bash
# Complete PostgreSQL debug build process

set -e

echo "Starting full PostgreSQL debug build process..."

# Step 1: Configuration with debug options
echo "Step 1: Debug Configuration"
/usr/src/scripts/configure-debug.sh

# Step 2: Build and Install
echo "Step 2: Build and Install"
/usr/src/scripts/build.sh

# Step 3: Environment Setup
echo "Step 3: Setting up PostgreSQL Environment"
useradd -r -s /bin/false postgres || true
mkdir -p /usr/local/pgsql/data
chown postgres:postgres /usr/local/pgsql/data

# Initialize database
su - postgres -s /bin/bash -c '/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data'

echo ""
echo "PostgreSQL debug build and setup completed!"
echo ""
echo "To start PostgreSQL server:"
echo "  su - postgres -s /bin/bash -c '/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l /usr/local/pgsql/data/logfile start'"
echo ""
echo "To start GDB debugging session:"
echo "  su - postgres -s /bin/bash -c 'cd /usr/local/pgsql && gdb -x /usr/src/scripts/gdb-auth-debug.gdb'"
echo ""