FROM ubuntu:focal
ARG DEBIAN_FRONTEND=noninteractive
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    SHELL=/bin/bash \
    LANG=C.UTF-8 \
    PS1="\u@\h:\w \$ " \
    TZ=Asia/Shanghai
RUN echo "change repo..." \
    && sed -i 's|archive.ubuntu.com|mirrors.bfsu.edu.cn|g' /etc/apt/sources.list \
    && sed -i 's|security.ubuntu.com|mirrors.bfsu.edu.cn|g' /etc/apt/sources.list \
    && sed -i 's|ports.ubuntu.com|mirrors.bfsu.edu.cn|g' /etc/apt/sources.list \
    && apt update \
    && apt upgrade -y \
    && apt install -y curl gnupg \
    && curl -fsSL https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/jellyfin.gpg \
    && VERSION_CODENAME=$(awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release) \
    && echo "deb [arch=$(dpkg --print-architecture)] https://repo.jellyfin.org/$(awk -F'=' '/^ID=/{ print $NF }' /etc/os-release) ${VERSION_CODENAME} main" | tee /etc/apt/sources.list.d/jellyfin.list \
    && apt update \
    && apt install -y jellyfin \
    && AMDGPU_PACKAGE=$(curl -fsSL http://repo.radeon.com/amdgpu-install/latest/ubuntu/${VERSION_CODENAME} | awk -F '<|>' '/.deb/{print $3}') \
    && curl -fsSL http://repo.radeon.com/amdgpu-install/latest/ubuntu/${VERSION_CODENAME}/${AMDGPU_PACKAGE} -o /tmp/amdgpu.deb \
    && dpkg -i /tmp/amdgpu.deb \
    && apt clean -y \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
VOLUME ["/cache", "/config"]
ENTRYPOINT ["jellyfin", \
    "--datadir", "/config", \
    "--cachedir", "/cache", \
    "--webdir", "/usr/share/jellyfin/web", \
    "--ffmpeg", "/usr/lib/jellyfin-ffmpeg/ffmpeg"]
