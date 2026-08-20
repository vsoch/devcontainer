FROM fluxrm/flux-core:bookworm

LABEL maintainer="Vanessasaurus <@vsoch>"

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
ENV USERNAME=${USERNAME}
USER root

# Build dependencies for flux-sched, plus tools you'll want interactively
RUN apt-get update && \
    apt-get -qq install -y --no-install-recommends \
        libboost-graph-dev \
        libboost-system-dev \
        libboost-filesystem-dev \
        libboost-regex-dev \
        python3-yaml \
        libyaml-cpp-dev \
        libedit-dev \
        ninja-build \
        curl \
        sudo \
        fd-find \
        less \
        bats \
        ripgrep && \
    rm -rf /var/lib/apt/lists/*

# Assuming you install to /usr/local
ENV LD_LIBRARY_PATH=/usr/lib:/usr/local/lib

# Add the group and user. The sudo rule goes in a drop-in under /etc/sudoers.d
# rather than overwriting /etc/sudoers, which would drop the
# "@includedir /etc/sudoers.d" line and with it any other drop-in - including
# the firewall rule the claude feature adds when layered on top of this image.
RUN groupadd -g ${USER_GID} ${USERNAME} && \
    adduser --disabled-password --uid ${USER_UID} --gid ${USER_GID} --gecos "" ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

USER $USERNAME
