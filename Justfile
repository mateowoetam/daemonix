export image_name := env("IMAGE_NAME", "daemonix")
export default_tag := env("DEFAULT_TAG", "latest")
export bib_image := env("BIB_IMAGE", "quay.io/centos-bootc/bootc-image-builder:latest")

alias build-vm := build-qcow2
alias rebuild-vm := rebuild-qcow2
alias run-vm := run-vm-qcow2

[private]
default:
    @just --list

# Check Just Syntax
[group('Just')]
check:
    #!/usr/bin/bash
    find . -type f -name "*.just" | while read -r file; do
        echo "Checking syntax: $file"
        just --unstable --fmt --check -f $file
    done
    echo "Checking syntax: Justfile"
    just --unstable --fmt --check -f Justfile

# Fix Just Syntax
[group('Just')]
fix:
    #!/usr/bin/bash
    find . -type f -name "*.just" | while read -r file; do
        echo "Formatting: $file"
        just --unstable --fmt -f $file
    done
    echo "Formatting: Justfile"
    just --unstable --fmt -f Justfile || { exit 1; }

# Clean Repo
[group('Utility')]
clean:
    #!/usr/bin/bash
    set -eoux pipefail
    touch _build
    find *_build* -exec rm -rf {} \;
    rm -f previous.manifest.json
    rm -f changelog.md
    rm -f output.env
    rm -rf output/

# Sudo Clean Repo
[group('Utility')]
[private]
sudo-clean:
    just sudoif just clean

# sudoif bash function
[group('Utility')]
[private]
sudoif command *args:
    #!/usr/bin/bash
    function sudoif(){
        if [[ "${UID}" -eq 0 ]]; then
            "$@"
        elif [[ "$(command -v sudo)" && -n "${SSH_ASKPASS:-}" ]] && [[ -n "${DISPLAY:-}" || -n "${WAYLAND_DISPLAY:-}" ]]; then
            /usr/bin/sudo --askpass "$@" || exit 1
        elif [[ "$(command -v sudo)" ]]; then
            /usr/bin/sudo "$@" || exit 1
        else
            exit 1
        fi
    }
    sudoif {{ command }} {{ args }}

# -----------------------------------------------------------------------------
# Container Image Build (flavor-aware)
# -----------------------------------------------------------------------------

# Build the image
# Parameters:
#   target_image: image name (default: daemonix)
#   tag: image tag (default: latest)
#   flavor: base | nvidia
build $target_image=image_name $tag=default_tag $flavor="base":
    #!/usr/bin/env bash
    set -euo pipefail

    BUILD_ARGS=(
        "--build-arg" "BUILD_FLAVOR={{ flavor }}"
    )

    if [[ -z "$(git status -s)" ]]; then
        BUILD_ARGS+=("--build-arg" "SHA_HEAD_SHORT=$(git rev-parse --short HEAD)")
    fi

    podman build \
        "${BUILD_ARGS[@]}" \
        --pull=newer \
        --tag "{{ target_image }}:{{ tag }}" \
        .

# Convenience targets
build-base:
    just build {{ image_name }} {{ default_tag }} base

build-nvidia:
    just build {{ image_name }}-nvidia {{ default_tag }} nvidia

build-all:
    just build-base
    just build-nvidia

# -----------------------------------------------------------------------------
# Rootful Image Loader
# -----------------------------------------------------------------------------

_rootful_load_image $target_image=image_name $tag=default_tag:
    #!/usr/bin/bash
    set -eoux pipefail

    if [[ -n "${SUDO_USER:-}" || "${UID}" -eq "0" ]]; then
        echo "Already root or running under sudo."
        exit 0
    fi

    set +e
    podman inspect -t image "${target_image}:${tag}" >/dev/null 2>&1
    return_code=$?
    set -e

    USER_IMG_ID=$(podman images --filter reference="${target_image}:${tag}" --format "{{.ID}}")

    if [[ $return_code -eq 0 ]]; then
        ID=$(just sudoif podman images --filter reference="${target_image}:${tag}" --format "{{.ID}}")
        if [[ "$ID" != "$USER_IMG_ID" ]]; then
            COPYTMP=$(mktemp -p "${PWD}" -d -t _build_podman_scp.XXXXXXXXXX)
            just sudoif TMPDIR=${COPYTMP} podman image scp \
                ${UID}@localhost::"${target_image}:${tag}" \
                root@localhost::"${target_image}:${tag}"
            rm -rf "${COPYTMP}"
        fi
    else
        just sudoif podman pull "${target_image}:${tag}"
    fi

# -----------------------------------------------------------------------------
# Bootc Image Builder (BIB)
# -----------------------------------------------------------------------------

_build-bib $target_image $tag $type $config: (_rootful_load_image target_image tag)
    #!/usr/bin/env bash
    set -euo pipefail

    args="--type ${type} --use-librepo=True --rootfs=btrfs"

    BUILDTMP=$(mktemp -p "${PWD}" -d -t _build-bib.XXXXXXXXXX)

    sudo podman run \
        --rm -it --privileged --pull=newer --net=host \
        --security-opt label=type:unconfined_t \
        -v $(pwd)/${config}:/config.toml:ro \
        -v $BUILDTMP:/output \
        -v /var/lib/containers/storage:/var/lib/containers/storage \
        "${bib_image}" \
        ${args} \
        "${target_image}:${tag}"

    mkdir -p output
    sudo mv -f $BUILDTMP/* output/
    sudo rmdir $BUILDTMP
    sudo chown -R $USER:$USER output/

_rebuild-bib $target_image $tag $type $config:
    just build {{ target_image }} {{ tag }} base
    just _build-bib {{ target_image }} {{ tag }} {{ type }} {{ config }}

# -----------------------------------------------------------------------------
# ISO Targets (Base + NVIDIA)
# -----------------------------------------------------------------------------

build-iso:
    just build-base
    just _build-bib "localhost/{{ image_name }}" {{ default_tag }} iso disk_config/iso.toml

build-iso-nvidia:
    just build {{ image_name }}-nvidia {{ default_tag }} nvidia
    just _build-bib "localhost/{{ image_name }}-nvidia" {{ default_tag }} iso disk_config/iso.toml

# -----------------------------------------------------------------------------
# QCOW / RAW Builds (unchanged)
# -----------------------------------------------------------------------------

[group('Build Virtual Machine Image')]
build-qcow2 $target_image=("localhost/" + image_name) $tag=default_tag:
    just _build-bib {{ target_image }} {{ tag }} qcow2 disk_config/disk.toml

[group('Build Virtual Machine Image')]
build-raw $target_image=("localhost/" + image_name) $tag=default_tag:
    just _build-bib {{ target_image }} {{ tag }} raw disk_config/disk.toml

[group('Build Virtual Machine Image')]
rebuild-qcow2 $target_image=("localhost/" + image_name) $tag=default_tag:
    just _rebuild-bib {{ target_image }} {{ tag }} qcow2 disk_config/disk.toml

[group('Build Virtual Machine Image')]
rebuild-raw $target_image=("localhost/" + image_name) $tag=default_tag:
    just _rebuild-bib {{ target_image }} {{ tag }} raw disk_config/disk.toml

# -----------------------------------------------------------------------------
# Lint / Format
# -----------------------------------------------------------------------------

lint:
    #!/usr/bin/env bash
    set -eoux pipefail
    command -v shellcheck >/dev/null
    find . -iname "*.sh" -type f -exec shellcheck "{}" ';'

format:
    #!/usr/bin/env bash
    set -eoux pipefail
    command -v shfmt >/dev/null
    find . -iname "*.sh" -type f -exec shfmt --write "{}" ';'
