### What the Script Installs

- Creates a dedicated system user named `changedetection` for security isolation.
- Installs Python and virtual environment tools required to run the application.
- Downloads and installs ChangeDetection.io into the directory `/opt/changedetection`.
- Creates a persistent data storage directory at `/var/lib/changedetection`.
- Sets up a systemd service so the application runs automatically at system startup.
- Configures the web interface to run and listen on port `5000` by default.

**Web UI:** http://localhost:5000
