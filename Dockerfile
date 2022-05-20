ARG IMAGE_TAG=latest
FROM itzg/minecraft-server:${IMAGE_TAG}

RUN apt update && apt upgrade -y && \
    apt install python3 python3-pip curl -y --fix-missing

COPY --chmod=644 files/config.yml /tmp/mcdr/config.yml
COPY --chmod=644 files/permission.yml /tmp/mcdr/permission.yml
COPY --chmod=755 scripts/start.sh /mcdr-start.sh
COPY --chmod=755 scripts/start-mcdr-server.sh /start-mcdr-server.sh

VOLUME [ "/mcdr" ]
WORKDIR /mcdr

ENTRYPOINT [ "/mcdr-start.sh" ]