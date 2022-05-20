ARG IMAGE_TAG=latest
FROM itzg/minecraft-server:${IMAGE_TAG}
ARG MCDR_VERSION

RUN apt update && apt upgrade -y && \
    apt install python3 python3-pip curl -y --fix-missing

# Install production version
RUN pip install $([ -n "$MCDR_VERSION" ] && echo "mcdreforged==${MCDR_VERSION}" || echo "mcdreforged")

# Download source code pack for dev environment
RUN mkdir -p /tmp/mcdr && \
    curl -sSLo /tmp/mcdr/source.tar.gz https://github.com/Fallen-Breath/MCDReforged/archive/refs/tags/v$([ -n "$MCDR_VERSION" ] && echo ${MCDR_VERSION} || echo  \
      $( \
        curl -sS https://api.github.com/repos/Fallen-Breath/MCDReforged/releases/latest |\
        grep "tag_name" |\
        cut -d'v' -f2 |\
        cut -d'"' -f1 \
      ) \
  ).tar.gz

COPY --chmod=644 files/config.yml /tmp/mcdr/config.yml
COPY --chmod=644 files/permission.yml /tmp/mcdr/permission.yml
COPY --chmod=755 scripts/start.sh /mcdr-start.sh
COPY --chmod=755 scripts/start-mcdr-server.sh /start-mcdr-server.sh

VOLUME [ "/mcdr" ]
WORKDIR /mcdr

ENTRYPOINT [ "/mcdr-start.sh" ]