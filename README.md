# MCDReforged docker image

**大概能用，未经过测试，以后会加**

Docker image for [MCDReforged](https://github.com/Fallen-Breath/MCDReforged)

基于[itzg/docker-minecraft-server](https://github.com/itzg/docker-minecraft-server)

docker-compose.yml

```yaml
version: "3.8"
services:
  mcdr:
    image: mcdr:latest
    environment:
      - EULA=TRUE
    ports:
      - 25565:25565
    stdin_open: true
    tty: true
```

`stdin_open` 与 `tty` 必须为 `true`, 或者去 MCDR 的 config.yml 里把 `disable_console_thread` 改为 `true`

`docker run -i` 没试过，应该可以

以后再慢慢改（咕
