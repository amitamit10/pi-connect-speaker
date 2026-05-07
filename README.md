# Pi Connect Speaker

<p align="center">
  <strong>A stable Raspberry Pi Spotify Connect speaker with a local settings UI.</strong>
</p>

<p align="center">
  <img alt="Python" src="https://img.shields.io/badge/Python-3.11+-3776AB?logo=python&logoColor=white">
  <img alt="Raspberry Pi" src="https://img.shields.io/badge/Raspberry%20Pi-3B+-A22846?logo=raspberrypi&logoColor=white">
  <img alt="Runtime" src="https://img.shields.io/badge/Runtime-no%20Node%20%2F%20no%20DB-168443">
  <img alt="License" src="https://img.shields.io/badge/License-MIT-black">
</p>

Pi Connect Speaker turns a Raspberry Pi into a Spotify Connect receiver for a USB DAC and receiver setup. It uses `librespot` for playback and adds a clean web UI for settings, audio output, logs, diagnostics, profiles, and config backups.

## Highlights

| Area | What you get |
| --- | --- |
| Stability | `systemd` services, auto-restart, health checks, doctor command |
| Audio | USB DAC selection, ALSA mixer control, test sound, command preview |
| Settings | Every runtime option is editable in the UI and saved to TOML |
| Recovery | Config backups, profile save/load, logs from the web UI |
| Lightweight | Python stdlib backend, static HTML/CSS/JS, no database |

## Target Setup

- Raspberry Pi 3B or newer
- Raspberry Pi OS Lite or another Debian/systemd image
- USB DAC connected to a receiver
- Wi-Fi or Ethernet

## Install

Run this on the Raspberry Pi:

```bash
git clone https://github.com/<owner>/pi-connect-speaker.git
cd pi-connect-speaker
sudo START_NOW=1 scripts/install.sh
```

Open the UI:

```text
http://<raspberry-pi-ip>:8080
```

Default Spotify Connect device name:

```text
PiConnect Speaker
```

## Verify

```bash
sudo -u pi-connect-speaker /opt/pi-connect-speaker/venv/bin/pi-connect-speaker-doctor
```

Useful service commands:

```bash
sudo systemctl status pi-connect-speaker.service
sudo systemctl status pi-connect-speaker-librespot.service
sudo systemctl restart pi-connect-speaker-librespot.service
```

## Uninstall

Remove services and app files, keeping config/cache:

```bash
sudo scripts/uninstall.sh
```

Remove everything, including config, cache, data, and service user:

```bash
sudo scripts/uninstall.sh --purge
```

## Installer Options

`scripts/install.sh` uses an existing `librespot` binary when available. Otherwise it tries the OS package, then falls back to building with Cargo.

```bash
sudo LIBRESPOT_INSTALL_MODE=existing scripts/install.sh
sudo LIBRESPOT_INSTALL_MODE=apt scripts/install.sh
sudo LIBRESPOT_INSTALL_MODE=auto scripts/install.sh
```

## Paths

| Path | Purpose |
| --- | --- |
| `/etc/pi-connect-speaker/config.toml` | Active configuration |
| `/etc/pi-connect-speaker/profiles` | Saved profiles |
| `/etc/pi-connect-speaker/backups` | Automatic config backups |
| `/var/cache/pi-connect-speaker` | Librespot audio/system cache |

## Security

The web UI defaults to `auth_mode = "none"` for trusted home networks. Do not expose port `8080` to the internet. For stricter use, change `web.host` to `127.0.0.1` or set `web.auth_mode = "pin"`.

## Development

```bash
python3 -m venv .venv
. .venv/bin/activate
python -m pip install -e .
python -m unittest discover -s tests
python -m compileall src
```

Run locally with a temporary config:

```bash
PCS_CONFIG=/tmp/pi-connect-speaker.toml python -m pi_connect_speaker
```

Do not run `scripts/install.sh` on your development machine unless it is the target Raspberry Pi.

## Docs

- [Configuration](docs/CONFIGURATION.md)
- [Operations](docs/OPERATIONS.md)
- [API](docs/API.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## Credits

Playback is powered by [`librespot`](https://github.com/librespot-org/librespot).

## License

MIT
