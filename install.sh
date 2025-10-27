#!/usr/bin/env bash
set -euo pipefail

# ==== Settings you may change ====
APP_USER="changedetection"
APP_DIR="/opt/changedetection"
DATA_DIR="/var/lib/changedetection"
PORT="5000"                           # Web UI port
PYTHON_BIN="python3"                  # e.g. python3.10 on newer distros
# =================================

echo "[*] Updating apt and installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y git curl ca-certificates $PYTHON_BIN $PYTHON_BIN-venv $PYTHON_BIN-pip

# Create service user (no login shell)
if ! id -u "$APP_USER" >/dev/null 2>&1; then
  echo "[*] Creating system user $APP_USER"
  sudo useradd --system --home "$APP_DIR" --shell /usr/sbin/nologin "$APP_USER"
fi

echo "[*] Creating directories..."
sudo mkdir -p "$APP_DIR" "$DATA_DIR"
sudo chown -R "$APP_USER":"$APP_USER" "$APP_DIR" "$DATA_DIR"

echo "[*] Creating Python virtualenv..."
sudo -u "$APP_USER" bash -c "
  cd '$APP_DIR'
  $PYTHON_BIN -m venv venv
  ./venv/bin/pip install --upgrade pip
  ./venv/bin/pip install --upgrade wheel
  ./venv/bin/pip install changedetection.io
"

# Create systemd service
SERVICE_FILE="/etc/systemd/system/changedetection.service"
echo "[*] Writing systemd unit to $SERVICE_FILE"
sudo bash -c "cat > '$SERVICE_FILE' <<'UNIT'
[Unit]
Description=ChangeDetection.io (no Docker)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$APP_DIR
# -d : data dir  |  -p : port
ExecStart=$APP_DIR/venv/bin/changedetection.io -d $DATA_DIR -p $PORT
Restart=on-failure
RestartSec=5
# Hardening (optional, loosen if you add plugins needing extra perms)
NoNewPrivileges=true
ProtectSystem=full
ProtectHome=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
UNIT"

echo "[*] Reloading systemd and starting ChangeDetection.io..."
sudo systemctl daemon-reload
sudo systemctl enable --now changedetection.service

echo
echo "============================================================"
echo " ChangeDetection.io is installing/running."
echo " Service:   systemctl status changedetection.service"
echo " Data dir:  $DATA_DIR"
echo " Binary:    $APP_DIR/venv/bin/changedetection.io"
echo " Web UI:    http://localhost:$PORT"
echo "============================================================"

