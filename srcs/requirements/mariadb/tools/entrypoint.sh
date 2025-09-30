#!/bin/sh

# Create runtime directory for socket
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Check if initialization is needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "First run detected - initializing MariaDB..."

    # Initialize data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start MariaDB temporarily in background
    mysqld --user=mysql &
    pid="$!"

    # Wait for MariaDB to be ready
    echo "Waiting for MariaDB to start..."
    sleep 5

    # Execute initialization commands
    echo "Creating database and user..."
    mariadb -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
    mariadb -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
    mariadb -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
    mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
    mariadb -e "FLUSH PRIVILEGES;"

    # Stop temporary instance
    mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
    wait "$pid"

    echo "MariaDB initialization completed!"
else
    echo "MariaDB already initialized, skipping setup..."
fi

# Start MariaDB in foreground
exec mysqld --user=mysql
