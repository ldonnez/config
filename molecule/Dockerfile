ARG BASE_IMAGE=debian:13
FROM ${BASE_IMAGE}

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        curl \
        git \
        python3 \
        python3-apt \
        python3-setuptools \
        sudo \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash molecule

RUN usermod --append --groups sudo molecule

RUN echo 'molecule ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/molecule \
    && chmod 0440 /etc/sudoers.d/molecule

USER molecule

CMD ["bash", "-c", "while true; do sleep 10000; done"]
