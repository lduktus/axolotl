ARG VERSION=40
ARG IMG_NAME=axolotl
FROM quay.io/fedora/fedora-silverblue:${VERSION}

COPY rootfs/ /
COPY bin/ /tmp
COPY cosign.pub /usr/etc/pki/containers/${IMG_NAME}.pub

RUN set -euo pipefail; /tmp/00-setup.sh \
    && rm -rf /var /tmp \
    && rpm-ostree cleanup -m \
    && ostree container commit
