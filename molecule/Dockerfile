ARG BASE_IMAGE=debian:13
FROM ${BASE_IMAGE}

ARG DEBIAN_FRONTEND=noninteractive

ENV container=docker

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        curl \
        dbus \
        git \
        python3 \
        python3-apt \
        python3-setuptools \
        sudo \
        systemd \
        systemd-sysv \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash molecule

RUN usermod --append --groups sudo molecule

RUN echo 'molecule ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/molecule \
    && chmod 0440 /etc/sudoers.d/molecule

STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init"]
