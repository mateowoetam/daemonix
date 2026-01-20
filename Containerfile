# Build context 

FROM scratch AS ctx
COPY build_files/ /

# Download Kinoite Upstream

FROM ghcr.io/ublue-os/kinoite-main:latest

# OPT preparation

RUN rm -rf /opt && mkdir /opt

# BUILD PHASE

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,target=/var/cache \
    --mount=type=cache,target=/var/log \
    --mount=type=tmpfs,target=/tmp \

    install -m755 /ctx/repository.sh /tmp/repository.sh && \
    install -m755 /ctx/rpms.sh /tmp/rpms.sh && \
    install -m755 /ctx/services.sh /tmp/services.sh && \
    install -m755 /ctx/nix-overlay-service.sh /tmp/nix-overlay-service.sh && \
    install -m755 /ctx/nix.sh /tmp/nix.sh && \
    install -m755 /ctx/nix.sh /tmp/security.sh && \
    install -m755 /ctx/custom.sh /tmp/custom.sh && \

    install -Dm755 /ctx/install-dev-flatpak.sh /usr/bin/dev-mode && \
    install -Dm755 /ctx/daemonix-helper.sh /usr/bin/daemonix-helper && \
    install -Dm755 /ctx/mount-nix-overlay.sh /usr/bin/mount-nix-overlay.sh && \

    bash /tmp/install-dev-flatpak.sh && \
    bash /tmp/repository.sh && \
    bash /tmp/rpms.sh && \
    bash /tmp/nix-overlay-service.sh && \
    bash /tmp/nix.sh && \
    bash /tmp/services.sh && \
    bash /tmp/security.sh && \
    bash /tmp/custom.sh


# NVIDIA DRIVERS

COPY --from=ghcr.io/ublue-os/akmods-nvidia-open:main-43 / /tmp/akmods-nvidia

RUN dnf install -y \
    /tmp/akmods-nvidia/rpms/kmods/kmod-nvidia-*.rpm \
    /tmp/akmods-nvidia/rpms/ublue-os/ublue-os-nvidia-addons-*.rpm \
    nvidia-driver \
    nvidia-driver-libs \
    nvidia-settings && \
    dnf clean all

# Container verification

RUN bootc container lint

# OCI Labels

LABEL org.opencontainers.image.title="daemonix" \
      org.opencontainers.image.version="latest.20251025" \
      org.opencontainers.image.source="https://github.com/mateowoetam/daemonix/blob/main/Containerfile" \
      org.opencontainers.image.revision="c7d20d37c17a23bc97c7e2aa22adfe329626302f" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.vendor="mateowoetam" \
      org.opencontainers.image.url="https://github.com/mateowoetam/daemonix" \
      org.opencontainers.image.documentation="https://raw.githubusercontent.com/mateowoetam/daemonix/refs/heads/main/README.md" \
      org.opencontainers.image.description="Universal Blue Supercharged by Nix" \
      org.opencontainers.image.created="2025-10-25T23:21:35Z"
