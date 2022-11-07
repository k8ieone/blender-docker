FROM ghcr.io/k8ieone/arch-builder:latest AS builder
ADD --chown=builder:builder arch-package/ /home/builder/arch-package
WORKDIR /home/builder/arch-package
RUN /usr/bin/build-local

FROM ghcr.io/k8ieone/arch-base:latest AS runner
LABEL org.opencontainers.image.source=https://github.com/k8ieone/blender-docker
LABEL org.opencontainers.image.description Blender 3.3.1
COPY --from=builder /home/builder/built/ /built/
RUN pacman -U /built/*.pkg.tar.*

ENTRYPOINT ["/usr/bin/blender", "-b"]
