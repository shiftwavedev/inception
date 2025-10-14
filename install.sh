#!/bin/bash

#===============================================================================
# Inception - Installation script
#===============================================================================

set -e

echo "==> Installing dependencies for Inception"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root (sudo)"
   exit 1
fi

# Update system
echo "==> Updating system..."
pacman -Syu --noconfirm

# Install required packages
echo "==> Installing packages..."
pacman -S --noconfirm --needed \
    base-devel \
    git \
    make \
    docker \
    docker-compose

# Enable and start Docker
echo "==> Enabling Docker service..."
systemctl enable docker
systemctl start docker

# Add user to docker group
if [[ -n "$SUDO_USER" ]]; then
    echo "==> Adding $SUDO_USER to docker group..."
    usermod -aG docker "$SUDO_USER"
    echo "Note: Log out and back in for changes to take effect"
fi

# Create secrets directory if needed
SECRETS_DIR="$(dirname "$0")/secrets"
if [[ ! -d "$SECRETS_DIR" ]]; then
    echo "==> Creating secrets directory..."
    mkdir -p "$SECRETS_DIR"

    # Create secret template files
    echo "changeme_db_password" > "$SECRETS_DIR/db_password.txt"
    echo "changeme_root_password" > "$SECRETS_DIR/db_root_password.txt"
    cat > "$SECRETS_DIR/credentials.txt" << 'EOF'
admin_user=admin
admin_password=changeme_admin_password
admin_email=admin@example.com
user_login=user
user_password=changeme_user_password
user_email=user@example.com
EOF
    chmod 600 "$SECRETS_DIR"/*.txt
    echo "WARNING: Update the secret files in $SECRETS_DIR before deployment!"
fi

# Configure /etc/hosts for domain resolution
echo "==> Configuring domain resolution..."
SRCS_ENV="$(dirname "$0")/srcs/.env"
if [[ -f "$SRCS_ENV" ]]; then
    # Extract LOGIN from .env file
    LOGIN=$(grep -E "^LOGIN=" "$SRCS_ENV" | cut -d'=' -f2)
    if [[ -n "$LOGIN" ]]; then
        DOMAIN="${LOGIN}.42.fr"

        # Check if entry already exists
        if grep -q "$DOMAIN" /etc/hosts; then
            echo "Domain $DOMAIN already configured in /etc/hosts"
        else
            echo "127.0.0.1    $DOMAIN" >> /etc/hosts
            echo "Added $DOMAIN to /etc/hosts"
        fi
    else
        echo "WARNING: LOGIN not found in $SRCS_ENV"
        echo "You will need to manually add your domain to /etc/hosts:"
        echo "  sudo sh -c 'echo \"127.0.0.1    <your_login>.42.fr\" >> /etc/hosts'"
    fi
else
    echo "WARNING: .env file not found at $SRCS_ENV"
    echo "You will need to manually add your domain to /etc/hosts:"
    echo "  sudo sh -c 'echo \"127.0.0.1    <your_login>.42.fr\" >> /etc/hosts'"
fi

# Create data directories
echo "==> Creating data directories..."
DATA_DIR="/home/${SUDO_USER:-$USER}/data"
mkdir -p "$DATA_DIR/mariadb" "$DATA_DIR/wordpress"
if [[ -n "$SUDO_USER" ]]; then
    chown -R "$SUDO_USER:$SUDO_USER" "$DATA_DIR"
fi
echo "Data directories created at: $DATA_DIR"

# Verification
echo ""
echo "==> Verifying installation..."
docker --version
docker compose version
make --version | head -n1
git --version

echo ""
echo "[PASS] Installation completed !"
echo ""
echo "Next steps:"
echo "  1. Log out and back in"
echo "  2. Update secrets in: $SECRETS_DIR"
echo "  3. Verify domain in /etc/hosts: $(grep -E "\.42\.fr" /etc/hosts 2>/dev/null || echo 'Not configured')"
echo "  4. Run: make all"
