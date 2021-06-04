# see hooks/build and hooks/.config
ARG BASE_IMAGE_PREFIX
FROM ${BASE_IMAGE_PREFIX}debian:buster-slim

# see hooks/post_checkout
ARG QEMU_ARCH
COPY qemu-${QEMU_ARCH}-static /usr/bin

# S6 overlay
ARG S6OVERLAY_ARCH
ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-${S6OVERLAY_ARCH}-installer /tmp/s6overlay.tar.gz

# update
RUN apt-get update && apt-get upgrade --update --no-cache -y \
  && tar xzf /tmp/s6overlay.tar.gz -C / && rm /tmp/s6overlay.tar.gz

# French
RUN apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i fr_FR -c -f UTF-8 -A /usr/share/locale/locale.alias fr_FR.UTF-8
ENV LANG fr_FR.utf8



ENTRYPOINT [ "/init" ]

# Labels
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

LABEL maintainer="Jeremie-C" \
  Description="My Docker multiarch template" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.name="docker-multiarch" \
  org.label-schema.description="My Docker multiarch template" \
  org.label-schema.url="https://github.com/Jeremie-C/docker-multiarch" \
  org.label-schema.usage="https://github.com/Jeremie-C/docker-multiarch/tree/master/README.md" \
  org.label-schema.vcs-url="https://github.com/Jeremie-C/docker-multiarch" \
  org.label-schema.vcs-ref="${BUILD_REF}" \
  org.label-schema.version="${BUILD_VERSION}"
