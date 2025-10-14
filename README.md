# inception

Containerized web infrastructure with WordPress, MariaDB, and NGINX using Docker Compose.


## Quick Start

### 0. Git clone

```bash
git clone https://github.com/shiftwavedev/inception.git

cd inception
```

### 1. Setup Secrets

Generate strong passwords and create secrets:

```bash
# Create secrets directory
mkdir -p secrets

# Generate random passwords
openssl rand -base64 32 > secrets/db_password.txt
openssl rand -base64 32 > secrets/db_root_password.txt

# Create credentials file (6 lines format)
cat > secrets/credentials.txt << 'EOF'
wpowner
admin_password_secure_123
wpowner@inception.42.fr
wpuser
user_password_secure_456
user@inception.42.fr
EOF
```

### 2. Configure Environment

```bash
# Copy example environment file
cp .env.example .env

# Edit .env and configure:
# - LOGIN=<login42>
# - WP_TITLE=Inception
# - WP_URL=https://<login42>.42.fr
# ...
```

### 3. Launch

```bash
make all
```

**Access:** `https://<login42>.42.fr` _(self-signed cert warning is normal)_

## Commands

| Command | Description |
|---------|-------------|
| `make all` | Build and start all services |
| `make re` | Rebuild from scratch (fclean + all) |
| `make clean` | Stop services and remove volumes |
| `make fclean` | Complete Docker cleanup (system prune) |


## Configuration

### Environment Variables

Create `.env` file from template:

```bash
cp .env.example .env
```

Edit the following values:

```bash
SQL_DATABASE=wordpress                  # Database name
SQL_USER=wpuser                         # Database user
WP_TITLE=My WordPress Site              # Site title
WP_URL=https://<login42>.42.fr     # Site URL
WP_VERSION=6.8.1                        # WordPress version (optional)
LOGIN=<login42>                         # Your login42
```

### Secrets Files

**Location:** `secrets/` directory

| File | Content | Example |
|------|---------|---------|
| `db_password.txt` | Database user password | `xK9mP2vQ8nL5...` |
| `db_root_password.txt` | Database root password | `7Rj4wT1sN9hM...` |
| `credentials.txt` | WordPress users (admin/user) | See format below |

**Format for credentials.txt:**
```
admin_username
admin_password
admin_email@example.com
user_username
user_password
user_email@example.com
```

**Note:** Admin username must NOT contain 'admin', 'Admin', 'administrator', or 'Administrator' (ex use 'wpowner', 'siteadmin', 'manager', etc.)

### Password Generator

```bash
# Generate secure random password (32 characters)
openssl rand -base64 32

# Generate and save to file
openssl rand -base64 32 > secrets/db_password.txt

# Generate custom length (e.g., 48 characters)
openssl rand -base64 48

# Alternative: using /dev/urandom (Linux/macOS)
tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c 32
```

## Accessing Services Web

```bash
# WordPress frontend
https://<login42>.42.fr

# WordPress admin dashboard
https://<login42>.42.fr/wp-admin
```


## License

This project is licensed under the [MIT License](./LICENSE) - see the [LICENSE](./LICENSE) file for details.

---

**Note:** While this project is freely available under the MIT license, attribution is always appreciated. If you use or reference this work, please consider citing the original repository.
