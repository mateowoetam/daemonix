# Use an ARG for the base image, provided by the CI/CD pipeline
ARG BASE_IMAGE
# Build context
FROM scratch AS ctx
COPY build_files/ /

# -----------------------------------------------------------------------------
# Base image (Kinoite-Main or Kinoite-Nvidia)
# -----------------------------------------------------------------------------
FROM ${BASE_IMAGE} AS final

# Re-declare ARGs to use them inside this stage
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

# BUILD PHASE
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,target=/var/cache \
    --mount=type=cache,target=/var/cache/dnf \
    --mount=type=cache,target=/var/lib/dnf \
    --mount=type=cache,target=/var/log \
    --mount=type=tmpfs,target=/tmp \
    # Install binary helpers to /usr/bin
    install -Dm755 /ctx/install-dev-flatpak.sh /usr/bin/dev-mode && \
    install -Dm755 /ctx/daemonix-helper.sh /usr/bin/daemonix-helper && \
    install -Dm755 /ctx/mount-nix-overlay.sh /usr/bin/mount-nix-overlay.sh && \
    # Prepare and execute scripts in the correct order from the working version

    for script in rpms.sh flatpak.sh nix-overlay-service.sh nix.sh
                    system-config.sh services.sh custom.sh; do \
        if [ -f "/ctx/$script" ]; then \
            install -m755 "/ctx/$script" "/tmp/$script" && \
            sh "/tmp/$script"; \
        fi \
    done

# Final health check for bootc compatibility
RUN bootc container lint
