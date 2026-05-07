# API

The web UI uses a small JSON API. Default host and port:

```text
http://<raspberry-pi-ip>:8080
```

## Settings

`GET /api/schema`

Returns editable sections and fields.

`GET /api/settings`

Returns the active validated config.

`PUT /api/settings`

Writes the full config. The body can be either the config object or `{ "config": ... }`.

## Status and Doctor

`GET /api/status`

Returns service state, generated librespot command, device name, and key paths.

`GET /api/system`

Returns hostname, IP addresses, platform, uptime, temperature, memory, and disk summary.

`GET /api/doctor`

Runs installation and runtime checks.

## Audio

`GET /api/audio/devices`

Returns ALSA hardware devices, logical devices, and mixer controls.

`GET /api/audio/mixer`

Returns the configured mixer state.

`POST /api/audio/volume`

Sets ALSA mixer volume.

```json
{ "percent": 40 }
```

`POST /api/diagnostics/test-sound`

Runs the configured test sound command.

## Services

`POST /api/service/spotify/start`

`POST /api/service/spotify/stop`

`POST /api/service/spotify/restart`

`POST /api/service/spotify/enable-now`

`POST /api/service/spotify/disable-now`

The UI intentionally controls only the Spotify engine service. Restarting the web service from its own request path is less predictable and is left to SSH/systemd.

## Logs

`GET /api/logs?target=spotify&lines=200`

Targets: `spotify`, `web`.

## Profiles and Backups

`GET /api/profiles`

`POST /api/profiles/save`

`POST /api/profiles/load`

`DELETE /api/profiles/<name>`

`GET /api/backups`

`POST /api/backups/restore`

```json
{ "name": "config-20260507T180000000000Z.toml" }
```
