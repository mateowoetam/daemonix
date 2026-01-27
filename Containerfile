# -----------------------------------------------------------------------------
# Build context
# -----------------------------------------------------------------------------
FROM scratch AS ctx
COPY build_files/ /

# -----------------------------------------------------------------------------
# Base image
# -----------------------------------------------------------------------------
FROM ghcr.io/ublue-os/kinoite-main:latest AS base

LABEL \
  org.opencontainers.image.title="daemonix" \
  org.opencontainers.image.description="Daemonix OS (Base)" \
  org.opencontainers.image.variant="base" \
  org.opencontainers.image.source="https://github.com/mateowoetam/daemonix" \
  org.opencontainers.image.licenses="Apache-2.0"

RUN rm -rf /opt && mkdir /opt

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,target=/var/cache \
    --mount=type=cache,target=/var/cache/dnf \
    --mount=type=cache,target=/var/lib/dnf \
    --mount=type=cache,target=/var/log \
    --mount=type=tmpfs,target=/tmp \
    install -m755 /ctx/flatpak.sh /tmp/flatpak.sh && \
    install -m755 /ctx/rpms.sh /tmp/rpms.sh && \
    install -m755 /ctx/services.sh /tmp/services.sh && \
    install -m755 /ctx/nix-overlay-service.sh /tmp/nix-overlay-service.sh && \
    install -m755 /ctx/nix.sh /tmp/nix.sh && \
    install -m755 /ctx/system-config.sh /tmp/system-config.sh && \
    install -m755 /ctx/custom.sh /tmp/custom.sh && \
    install -Dm755 /ctx/install-dev-flatpak.sh /usr/bin/dev-mode && \
    install -Dm755 /ctx/daemonix-helper.sh /usr/bin/daemonix-helper && \
    install -Dm755 /ctx/mount-nix-overlay.sh /usr/bin/mount-nix-overlay.sh && \
    sh /tmp/rpms.sh && \
    sh /tmp/flatpak.sh && \
    sh /tmp/nix-overlay-service.sh && \
    sh /tmp/nix.sh && \
    sh /tmp/system-config.sh && \
    sh /tmp/services.sh && \
    sh /tmp/custom.sh

# -----------------------------------------------------------------------------
# NVIDIA image
# -----------------------------------------------------------------------------
FROM ghcr.io/ublue-os/kinoite-nvidia:latest AS nvidia

LABEL \
  org.opencontainers.image.title="daemonix-nvidia" \
  org.opencontainers.image.description="Daemonix OS (NVIDIA)" \
  org.opencontainers.image.variant="nvidia" \
  org.opencontainers.image.source="https://github.com/mateowoetam/daemonix" \
  org.opencontainers.image.licenses="Apache-2.0"

RUN rm -rf /opt && mkdir /opt

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,target=/var/cache \
    --mount=type=cache,target=/var/cache/dnf \
    --mount=type=cache,target=/var/lib/dnf \
    --mount=type=cache,target=/var/log \
    --mount=type=tmpfs,target=/tmp \
    install -m755 /ctx/flatpak.sh /tmp/flatpak.sh && \
    install -m755 /ctx/rpms.sh /tmp/rpms.sh && \
    install -m755 /ctx/services.sh /tmp/services.sh && \
    install -m755 /ctx/nix-overlay-service.sh /tmp/nix-overlay-service.sh && \
    install -m755 /ctx/nix.sh /tmp/nix.sh && \
    install -m755 /ctx/system-config.sh /tmp/system-config.sh && \
    install -m755 /ctx/custom.sh /tmp/custom.sh && \
    install -Dm755 /ctx/install-dev-flatpak.sh /usr/bin/dev-mode && \
    install -Dm755 /ctx/daemonix-helper.sh /usr/bin/daemonix-helper && \
    install -Dm755 /ctx/mount-nix-overlay.sh /usr/bin/mount-nix-overlay.sh && \
    sh /tmp/rpms.sh && \
    sh /tmp/flatpak.sh && \
    sh /tmp/nix-overlay-service.sh && \
    sh /tmp/nix.sh && \
    sh /tmp/system-config.sh && \
    sh /tmp/services.sh && \
    sh /tmp/custom.sh

# -----------------------------------------------------------------------------
# Final selection
# -----------------------------------------------------------------------------
ARG BUILD_FLAVOR
FROM ${BUILD_FLAVOR} AS final

RUN bootc container lint
