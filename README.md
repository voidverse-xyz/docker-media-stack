# Self-Hosted Docker Media Stack

A self-hosted Docker Compose media server stack using Jellyfin, Sonarr, Radarr, Prowlarr, qBittorrent, FlareSolverr, and Gluetun VPN.

## Gluetun VPN Setup

Edit the Gluetun environment variables according to the [Gluetun wiki](https://github.com/qdm12/gluetun-wiki/tree/main/setup/providers).

## Storage Setup

The download client and media managers share one `/data` mount so imports can use atomic moves and hardlinks. Configure these settings in the applications:

| Application | Setting | Value |
| ------ | ------ | ------ |
| qBittorrent | Default save path | `/data/torrents` |
| qBittorrent | `tv` category save path | `/data/torrents/tv` |
| qBittorrent | `movies` category save path | `/data/torrents/movies` |
| Sonarr | Download client category | `tv` |
| Sonarr | Root folder | `/data/media/tv` |
| Radarr | Download client category | `movies` |
| Radarr | Root folder | `/data/media/movies` |
| Jellyfin | TV library | `/data/media/tv` |
| Jellyfin | Movie library | `/data/media/movies` |

## Run

`sudo docker compose up`

## Network

The VPN-routed applications use `network_mode: service:gluetun` and share Gluetun's network namespace. When configuring connections between those containers, use `localhost` with the destination port—not the Compose service name. For example, configure Sonarr and Radarr to reach qBittorrent at `localhost:8080`, and configure Prowlarr to reach Sonarr and Radarr at `localhost:8989` and `localhost:7878`.

Jellyfin uses the Docker host's network directly so LAN discovery and DLNA multicast can work. From another device, connect to Jellyfin and the published Gluetun ports using the Docker host's IP address.

| Container | VPN-network address | Host/LAN address |
| ------ | ------ | ------ |
| Jellyfin | Not VPN-routed | `<host-ip>:80` (proxy), `<host-ip>:8096` (direct) |
| docker-whats-my-ip | `localhost:3000` | `<host-ip>:3000` |
| qBittorrent | `localhost:8080` | `<host-ip>:8080` |
| Radarr | `localhost:7878` | `<host-ip>:7878` |
| Sonarr | `localhost:8989` | `<host-ip>:8989` |
| FlareSolverr | `localhost:8191` | `<host-ip>:8191` |
| Prowlarr | `localhost:9696` | `<host-ip>:9696` |

### Jellyfin on port 80

The `jellyfin-proxy` Nginx service uses host networking and forwards HTTP port 80 to Jellyfin at `127.0.0.1:8096`, including WebSocket connections. Jellyfin keeps host networking for LAN discovery/DLNA and remains accessible directly on port 8096.

Ensure no other service is listening on the Docker host's port 80, then start Jellyfin and its proxy:

```sh
sudo docker compose up -d jellyfin jellyfin-proxy
```

Open `http://<host-ip>/` from your LAN. This is plain HTTP, not HTTPS; do not expose it directly to the internet. In Jellyfin's Networking settings, add `127.0.0.1` as a Known Proxy if you want Jellyfin to trust the forwarded client address. The proxy configuration is in `config/jellyfin-proxy.conf`; restart `jellyfin-proxy` after editing it.

## Containers

- QBittorrent - [QBittorrent Website](https://www.qbittorrent.org/) | [QBittorrent Docker Image](https://hub.docker.com/r/linuxserver/qbittorrent)
- Radarr - [Radarr Website](https://radarr.video/) | [Radarr Docker Image](https://hub.docker.com/r/linuxserver/radarr)
- Sonarr - [Sonarr Website](https://sonarr.tv/) | [Sonarr Docker Image](https://hub.docker.com/r/linuxserver/sonarr)
- FlareSolverr - [FlareSolverr Website](https://github.com/flaresolverr/flaresolverr) | [FlareSolverr Docker Image](https://hub.docker.com/r/flaresolverr/flaresolverr)
- Jellyfin - [Jellyfin Website](https://jellyfin.org/) | [Jellyfin Docker Image](https://hub.docker.com/r/linuxserver/jellyfin)
- Prowlarr - [Prowlarr Website](https://prowlarr.com/) | [Prowlarr Docker Image](https://hub.docker.com/r/linuxserver/prowlarr)
- Gluetun - [Gluetun Website](https://github.com/qdm12/gluetun) | [Gluetun Docker Image](https://hub.docker.com/r/qmcgaw/gluetun)
- docker-whats-my-ip - [Docker image](https://hub.docker.com/r/00000vish/docker-whats-my-ip)

## License

MIT
