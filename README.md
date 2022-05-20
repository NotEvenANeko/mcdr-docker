# MCDReforged docker image

**English** | [简体中文](https://github.com/Cattttttttt/mcdr-docker/docs/README-zh.md)

**This image is not tested yet**

**If you're using Docker Desktop on Windows 11, disable ‘Use the WSL 2 based engine' in Docker Desktop settings to use Hyper-V as backend, or your world might be corrupted. [This issue](https://github.com/itzg/docker-minecraft-server/issues/1102)**

Docker image for [MCDReforged](https://github.com/Fallen-Breath/MCDReforged)

Based on [itzg/docker-minecraft-server](https://github.com/itzg/docker-minecraft-server)

## Docker run

`$ docker run -it -e EULA=TRUE mcdr-docker:latest`

**MUST** use with `-i` and `-t` because MCDReforged will read EOF and exit if stdin is closed, or modify config.yml in the next section

## Docker Compose

```yaml
version: "3.8"
services:
  mcdr:
    image: mcdr-docker:latest
    environment:
      - EULA=TRUE
    ports:
      - 25565:25565
    stdin_open: true
    tty: true
```

`stdin_open` and `tty` **MUST** be `true`, or set `disable_console_thread` to `true` in config.yml of MCDReforged

## Modify Minecraft config

See https://github.com/itzg/docker-minecraft-server

## Attach volumes

You can attach your volume to `/data` and `/mcdr`

`/data` is the Minecraft main directory provided by [itzg/docker-minecraft-server](https://github.com/itzg/docker-minecraft-server), see https://github.com/itzg/docker-minecraft-server#data-directory

`/mcdr` is the directory of MCDReforged, see https://mcdreforged.readthedocs.io/zh_CN/latest/quick_start.html#start-up

```yaml
version: "3.8"
services:
  mcdr:
    image: mcdr-docker:latest
    environment:
      - EULA=TRUE
    ports:
      - 25565:25565
    volumes:
      - /path/to/your/server.property:/data/server.property
      - /path/to/your/world:/data/world
      - /path/to/your/mcdr/config.yml:/mcdr/config.yml
      - /path/to/your/mcdr/plugins:/mcdr/plugins
    stdin_open: true
    tty: true
```

## Boot from source code

Set environment variable `BOOT_FROM_SOURCE` to non-empty string.

```yaml
version: "3.8"
services:
  mcdr:
    image: mcdr-docker:latest
    environment:
      - EULA=TRUE
      - BOOT_FROM_SOURCE=TRUE
    ports:
      - 25565:25565
    stdin_open: true
    tty: true
```

## Use different version of MCDReforged

Just change the tag of the image.

```yaml
version: "3.8"
services:
  mcdr:
    image: mcdr-docker:2.3.2 # Use MCDReforged v2.3.2
    environment:
      - EULA=TRUE
    ports:
      - 25565:25565
    stdin_open: true
    tty: true
```
