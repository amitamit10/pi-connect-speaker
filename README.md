# Pi Connect Speaker

A small Raspberry Pi Spotify Connect receiver with a local settings UI.

The target setup is a Raspberry Pi connected to a receiver through a USB DAC. The app keeps `librespot` as the playback engine and adds a configurable web UI, systemd services, logs, audio-device selection, profiles, and a one-command installer.

## Goals

- Stable Spotify Connect playback on Raspberry Pi OS.
- USB DAC first, with ALSA controls exposed in the UI.
- No Node, no frontend build step, and no database.
- All runtime behavior is configurable through `/etc/pi-connect-speaker/config.toml` and the web UI.
- No web password by default for trusted home networks.
- Built-in doctor checks, config backups, command preview, ALSA mixer controls, and profile management.

## Hardware Target

- Raspberry Pi 3B or newer.
- Raspberry Pi OS Lite or Debian-based OS with systemd.
- USB DAC connected to a receiver.
- Wi-Fi or Ethernet.

## Installation

Run this on the Raspberry Pi, not on your development machine:

```bash
git clone https://github.com/<your-github-user>/pi-connect-speaker.git
cd pi-connect-speaker
sudo scripts/install.sh
sudo systemctl start pi-connect-speaker.service
sudo systemctl start pi-connect-speaker-librespot.service
```

Open:

```text
http://<raspberry-pi-ip>:8080
```

The default Spotify Connect device name is:

```text
PiConnect Speaker
```

Install and start immediately:

```bash
sudo START_NOW=1 scripts/install.sh
```

Run the installer in specific `librespot` modes:

```bash
sudo LIBRESPOT_INSTALL_MODE=existing scripts/install.sh
sudo LIBRESPOT_INSTALL_MODE=apt scripts/install.sh
sudo LIBRESPOT_INSTALL_MODE=auto scripts/install.sh
```

`existing` requires `librespot` to already be installed. `apt` uses only the OS package. `auto` first uses an existing binary, then tries the OS package, then falls back to `cargo install`.

Verify the installation:

```bash
sudo -u pi-connect-speaker /opt/pi-connect-speaker/venv/bin/pi-connect-speaker-doctor
```

## What Gets Installed

- `pi-connect-speaker.service`: local web UI and JSON API.
- `pi-connect-speaker-librespot.service`: Spotify Connect engine wrapper.
- `/etc/pi-connect-speaker/config.toml`: active settings.
- `/etc/pi-connect-speaker/profiles`: saved setting profiles.
- `/etc/pi-connect-speaker/backups`: automatic config backups.
- `/var/cache/pi-connect-speaker`: librespot audio and credential caches.
- Limited sudo rules so the web UI can restart only the Spotify engine service.

`scripts/install.sh` uses an existing `librespot` binary when one is already installed. Otherwise it tries the OS package and then falls back to `cargo install librespot` with ALSA and mDNS support. On a Pi 3B, the cargo fallback can take a while.

## Web UI

The UI exposes:

- Device name and Spotify device type.
- Web bind address, port, theme, and auth mode.
- Audio backend, ALSA device, mixer, output format, and dither.
- Startup volume, volume curve, ReplayGain normalisation, and range.
- Bitrate, cache paths, gapless playback, and autoplay.
- Network recovery and stability settings.
- Service actions: start, stop, restart.
- Audio device discovery and test sound.
- Logs, command preview, and profiles.
- Doctor checks for systemd, ALSA, network, paths, binaries, and generated librespot command.
- Config backups with restore from the UI.

## Configuration

Main config:

```text
/etc/pi-connect-speaker/config.toml
```

Default config template:

```text
config/default_config.toml
```

The web API validates every setting before writing the TOML file. Unknown keys are rejected so mistakes do not silently change runtime behavior.

See [docs/CONFIGURATION.md](docs/CONFIGURATION.md).

## Librespot

`librespot` is the Spotify Connect engine. This project builds a command from `config.toml` and runs it under systemd.

Useful upstream references:

- https://github.com/librespot-org/librespot
- https://github.com/librespot-org/librespot/wiki/Options
- https://github.com/librespot-org/librespot/wiki/Audio-Backends

## Security Note

The default web UI auth mode is `none`. This matches a trusted home LAN setup. Do not expose port `8080` to the internet. Change `web.host` to `127.0.0.1` or set `web.auth_mode = "pin"` before using it on an untrusted network.

## Development

This project uses only the Python standard library at runtime.

```bash
python3 -m venv .venv
. .venv/bin/activate
python -m pip install -e .
python -m unittest discover -s tests
python -m compileall src
```

Run the doctor without starting the web server:

```bash
PCS_CONFIG=config/default_config.toml PYTHONPATH=src python -m pi_connect_speaker.cli doctor
```

Local development can use a temporary config:

```bash
PCS_CONFIG=/tmp/pi-connect-speaker.toml python -m pi_connect_speaker
```

Do not run systemd install commands on your development machine unless it is the target Pi.

## Uninstall

```bash
sudo scripts/uninstall.sh
```

This stops and removes the two systemd service files and removes `/opt/pi-connect-speaker`. It keeps config, profiles, backups, cache, and the service user.

Remove config, cache, data, and service user too:

```bash
sudo scripts/uninstall.sh --purge
```

After uninstalling, these commands should no longer find active services:

```bash
systemctl status pi-connect-speaker.service
systemctl status pi-connect-speaker-librespot.service
```

## License

MIT
