#!/bin/sh

# Create runtime directory for socket
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Check if initialization is needed
if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
    echo "First run detected - initializing MariaDB..."

    # Initialize data directory if needed
    if [ ! -d "/var/lib/mysql/mysql" ]; then
        mysql_install_db --user=mysql --datadir=/var/lib/mysql
    fi

    # Create initialization SQL script
    cat > /tmp/init.sql << EOF
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    echo "MariaDB initialization completed!"
fi

# Start MariaDB in foreground with init script if it exists
if [ -f /tmp/init.sql ]; then
    echo "Starting MariaDB with initialization script..."
    exec mysqld --user=mysql --init-file=/tmp/init.sql
else
    echo "Starting MariaDB..."
    exec mysqld --user=mysql
fi
