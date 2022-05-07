ARG IMAGE_TAG=latest
FROM itzg/minecraft-server:${IMAGE_TAG}

RUN apt update && apt upgrade -y

RUN apt install python3 python3-pip -y

RUN pip install mcdreforged

COPY --chmod=644 files/config.yml /tmp/mcdr/config.yml
COPY --chmod=644 files/permission.yml /tmp/mcdr/permission.yml
COPY --chmod=755 scripts/start.sh /mcdr-start.sh

VOLUME [ "/mcdr" ]
WORKDIR /mcdr

ENTRYPOINT [ "/mcdr-start.sh" ]