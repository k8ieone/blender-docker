FROM ghcr.io/k8ieone/arch-builder:latest AS builder
ADD --chown=builder:builder arch-package/ /home/builder/arch-package
WORKDIR /home/builder/arch-package
RUN /usr/local/bin/build-local

FROM ghcr.io/k8ieone/arch-base:latest AS runner
LABEL org.opencontainers.image.source=https://github.com/k8ieone/blender-docker
LABEL org.opencontainers.image.description Blender 3.4.1
COPY --from=builder /home/builder/built/ /built/
RUN pacman -U --noconfirm --noprogressbar /built/*.pkg.tar.* && rm -r /built

ENTRYPOINT ["/usr/bin/blender", "-b"]
