#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="/var/lib/changedetection"
BACKUP_DIR="/var/backups"
SERVICE="changedetection.service"

mkdir -p "$BACKUP_DIR"

echo "[*] Stopping service..."
sudo systemctl stop "$SERVICE"

BACKUP_FILE="$BACKUP_DIR/changedetection-backup-$(date +%Y%m%d-%H%M).tar.gz"

echo "[*] Creating backup: $BACKUP_FILE"
sudo tar -czf "$BACKUP_FILE" "$DATA_DIR"

echo "[*] Starting service..."
sudo systemctl start "$SERVICE"

echo
echo "[✔] Backup complete."
echo "Saved to: $BACKUP_FILE"
