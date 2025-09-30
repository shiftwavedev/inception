#!/bin/sh

# Create runtime directory for socket
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialize data directory if not exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB temporarily in background
echo "Starting MariaDB temporarily..."
mysqld --user=mysql &
pid="$!"

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to start..."
sleep 5

# Execute initialization commands
echo "Configuring database and user..."
mariadb -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mariadb -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
mariadb -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mariadb -e "FLUSH PRIVILEGES;"

# Stop temporary MariaDB instance
echo "Stopping temporary MariaDB..."
mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown

# Wait for shutdown
wait "$pid"

echo "MariaDB initialization completed!"

# Start MariaDB in foreground
exec mysqld --user=mysql
