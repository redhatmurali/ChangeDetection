#!/usr/bin/env bash
set -euo pipefail

BACKUP_FILE="$1"
DATA_DIR="/var/lib/changedetection"
SERVICE="changedetection.service"

if [[ ! -f "$BACKUP_FILE" ]]; then
  echo "Backup file not found: $BACKUP_FILE"
  exit 1
fi

echo "[*] Stopping service..."
sudo systemctl stop "$SERVICE"

echo "[*] Renaming current data directory (backup): $DATA_DIR.old"
sudo mv "$DATA_DIR" "${DATA_DIR}.old.$(date +%s)" || true

echo "[*] Restoring from backup..."
sudo tar -xzf "$BACKUP_FILE" -C /

echo "[*] Fixing permissions..."
sudo chown -R changedetection:changedetection "$DATA_DIR"

echo "[*] Starting service..."
sudo systemctl start "$SERVICE"

echo
echo "[✔] Restore complete."
echo "Restored from: $BACKUP_FILE"
