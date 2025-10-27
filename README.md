### What the Script Installs

- Creates a dedicated system user named `changedetection` for security isolation.
- Installs Python and virtual environment tools required to run the application.
- Downloads and installs ChangeDetection.io into the directory `/opt/changedetection`.
- Creates a persistent data storage directory at `/var/lib/changedetection`.
- Sets up a systemd service so the application runs automatically at system startup.
- Configures the web interface to run and listen on port `5000` by default.

**Web UI:** http://localhost:5000


🗂 Backup
- Stop the service so no writes happen during backup:
- sudo systemctl stop changedetection.service
- Create backup of the data directory:
- sudo tar czf changedetection-backup-$(date +%Y%m%d).tar.gz /var/lib/changedetection

🔄 Restore
- Stop the service:
- sudo systemctl stop changedetection.service
- Remove or rename the existing data directory (just in case):
- sudo mv /var/lib/changedetection /var/lib/changedetection.old
- Extract your backup into the data directory location:
- sudo tar xzf changedetection-backup-YYYYMMDD.tar.gz -C /
- Make sure permissions are correct:
- sudo chown -R changedetection:changedetection /var/lib/changedetection
- Start the service again:
- sudo systemctl start changedetection.service


################# AUTOMATED ######################################
🗂 Backup

sudo chmod +x /usr/local/bin/backup-changedetection.sh
sudo backup-changedetection.sh



🔄 Restore
