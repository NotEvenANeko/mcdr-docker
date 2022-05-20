# MCDReforged docker image

[English](https://github.com/Cattttttttt/mcdr-docker) | **简体中文**

**未经过测试**

**如果你在 Windows 11 上使用 Docker Desktop, 请关闭 Docker Desktop 设置中的 'Use the WSL 2 based engine' 以使用 Hyper-V 作为后端, 不然世界生成可能会出问题, [此 issue](https://github.com/itzg/docker-minecraft-server/issues/1102)**

**仅支持 MCDReforged 2.x**

Docker image for [MCDReforged](https://github.com/Fallen-Breath/MCDReforged)

基于[itzg/docker-minecraft-server](https://github.com/itzg/docker-minecraft-server)

## Docker run

`$ docker run -it -e EULA=TRUE mcdr-docker:latest`

**必须** 使用参数 `-i` 和 `-t` , 因为如果 stdin 没打开那么 MCDReforged 会读到 EOF 然后就退出了, 也可以参考下一节里修改 config.yml

## Docker Compose

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

`docker run -i` 没试过, 应该可以

## 更改 Minecraft 配置

参见 https://github.com/itzg/docker-minecraft-server

## 挂载目录

存在两个可以挂载的卷, 分别是 `/data` 和 `/mcdr`

前者为 [itzg/docker-minecraft-server](https://github.com/itzg/docker-minecraft-server) 提供的 Minecraft 目录, 参见 https://github.com/itzg/docker-minecraft-server#data-directory

后者为 MCDReforged 的目录, 参见 https://mcdreforged.readthedocs.io/zh_CN/latest/quick_start.html#start-up

```yaml
version: "3.8"
services:
  mcdr:
    image: mcdr:latest
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

## 从源码启动

把环境变量 `BOOT_FROM_SOURCE` 设置为非空字符串即可

```yaml
version: "3.8"
services:
  mcdr:
    image: mcdr:latest
    environment:
      - EULA=TRUE
      - BOOT_FROM_SOURCE=TRUE
    ports:
      - 25565:25565
    stdin_open: true
    tty: true
```

## 使用不同的 MCDReforged 版本

只需要更改 image 的 tag 就行

```yaml
version: "3.8"
services:
  mcdr:
    image: mcdr:2.3.2 # 使用 v2.3.2 的 MCDReforged
    environment:
      - EULA=TRUE
    ports:
      - 25565:25565
    stdin_open: true
    tty: true
```

## `TYPE` 与 `handler` 的对应关系

- `FABRIC` 和 `VANILLA`: `vanilla_handler`
- `FORGE`: `forge_handler`
- `BUKKIT` 和 `SPIGOT`: 游戏版本高于 1.14 时为 `bukkit14_handler`, 其他为 `bukkit_handler`
- `PAPER` 和 `MOHIST`: `bukkit_handler`
- `CATSERVER`: `cat_server_handler`
- 其他: `vanilla_handler`
