# -----------------------------------------------------------------------------
# Build context
# -----------------------------------------------------------------------------
FROM scratch AS ctx
COPY build_files/ /

# -----------------------------------------------------------------------------
# Base image
# -----------------------------------------------------------------------------
FROM ghcr.io/ublue-os/kinoite-main:latest AS base

ARG BUILD_FLAVOR=base
ENV BUILD_FLAVOR=${BUILD_FLAVOR}

# Prepare /opt once
RUN rm -rf /opt && mkdir /opt

# Base build phase
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
# NVIDIA extension
# -----------------------------------------------------------------------------
FROM base AS nvidia

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,target=/var/cache \
    --mount=type=cache,target=/var/cache/dnf \
    --mount=type=cache,target=/var/lib/dnf \
    --mount=type=cache,target=/var/log \
    --mount=type=tmpfs,target=/tmp \
    install -m755 /ctx/nvidia.sh /tmp/nvidia.sh && \
    sh /ctx/nvidia.sh

# -----------------------------------------------------------------------------
# Final image selection
# -----------------------------------------------------------------------------
FROM ${BUILD_FLAVOR}

# Container verification
RUN bootc container lint

# -----------------------------------------------------------------------------
# OCI Labels
# -----------------------------------------------------------------------------
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
