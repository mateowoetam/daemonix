# Use an ARG for the base image, provided by the CI/CD pipeline
ARG BASE_IMAGE
FROM scratch AS ctx
COPY build_files/ /

# -----------------------------------------------------------------------------
# Base image (Kinoite-Main or Kinoite-Nvidia)
# -----------------------------------------------------------------------------
FROM ${BASE_IMAGE} AS final

# Re-declare ARG to use it inside this stage
ARG VARIANT
ARG IMAGE_NAME

LABEL \
  org.opencontainers.image.title="${IMAGE_NAME}" \
  org.opencontainers.image.description="Daemonix OS (${VARIANT})" \
  org.opencontainers.image.variant="${VARIANT}" \
  org.opencontainers.image.source="https://github.com/mateowoetam/daemonix" \
  org.opencontainers.image.licenses="Apache-2.0"

# Clean up opt and prepare directories
RUN rm -rf /opt && mkdir -p /opt

# Mount scripts and helpers
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,target=/var/cache \
    --mount=type=cache,target=/var/cache/dnf \
    --mount=type=cache,target=/var/lib/dnf \
    --mount=type=cache,target=/var/log \
    --mount=type=tmpfs,target=/tmp \
    install -Dm755 /ctx/install-dev-flatpak.sh /usr/bin/dev-mode && \
    install -Dm755 /ctx/daemonix-helper.sh /usr/bin/daemonix-helper && \
    install -Dm755 /ctx/mount-nix-overlay.sh /usr/bin/mount-nix-overlay.sh && \
    # Prepare and execute scripts
    for script in rpms.sh flatpak.sh nix-overlay-service.sh nix.sh \
                   system-config.sh services.sh custom.sh; do \
        install -m755 "/ctx/$script" "/tmp/$script"; \
    done && \
    sh /tmp/rpms.sh && \
    sh /tmp/flatpak.sh && \
    sh /tmp/nix-overlay-service.sh && \
    sh /tmp/nix.sh && \
    sh /tmp/system-config.sh && \
    sh /tmp/services.sh && \
    sh /tmp/custom.sh

# Final health check for bootc compatibility
RUN bootc container lint
