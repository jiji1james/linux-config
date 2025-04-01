#!/usr/bin/env bash

# Refer the following website
# https://www.dataquest.io/blog/install-postgresql-14-7-on-your-ubuntu-system/

# Install Postgres
# Create the file repository configuration:
sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update the package lists:
sudo apt-get update

# Install the latest version of PostgreSQL.
# If you want a specific version, use 'postgresql-12' or similar instead of 'postgresql':
sudo apt-get -y install postgresql-16

# Disable Autostart
sudo systemctl disable postgresql.service

# Start Postgres
sudo systemctl start postgresql.service

# Install client
sudo apt-get install -y postgresql-client

# Postgres
sudo systemctl status postgresql.service

# Change the password for postgres user
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'P@55w0rd';"
