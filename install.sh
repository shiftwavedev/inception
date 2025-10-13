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
echo "  3. Run: cd srcs && docker compose up -d"
