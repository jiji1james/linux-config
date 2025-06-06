#!/usr/bin/env bash

# Install Postgres
sudo dnf install -y postgresql16-server postgresql16 postgresql16-contrib

# Initialize the database
# database in '/var/lib/pgsql/data'
# logs are in /var/lib/pgsql/initdb_postgresql.log
sudo /usr/bin/postgresql-setup initdb

# Enable and start the service
sudo systemctl enable postgresql.service
sudo systemctl start postgresql.service

# Check the status of the service
sudo systemctl status postgresql.service

# Setup default user password
echo "postgres:P@55w0rd" | sudo chpasswd

# Configure Postgres properties
# Login as postgres user
# sudo -i -u postgres

# Change postgres password in database
# ALTER USER postgres WITH PASSWORD 'P@55w0rd';
