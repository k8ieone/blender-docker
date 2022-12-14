FROM ghcr.io/k8ieone/arch-builder:latest AS builder
ADD --chown=builder:builder arch-deps/ /home/builder/arch-deps
WORKDIR /home/builder/arch-deps/ispc
RUN sudo -u builder pikaur -Pi PKGBUILD --needed --noprogressbar --noconfirm
WORKDIR /home/builder/arch-deps/embree
RUN build-local
RUN pacman -U --noconfirm --noprogressbar --needed /home/builder/built/*.pkg.tar.*
ADD --chown=builder:builder arch-package/ /home/builder/arch-package
WORKDIR /home/builder/arch-package
RUN build-local

FROM ghcr.io/k8ieone/arch-base:latest AS runner
LABEL org.opencontainers.image.source=https://github.com/k8ieone/blender-docker
LABEL org.opencontainers.image.description Blender 3.4.1
COPY --from=builder /home/builder/built/ /built/
RUN pacman -U --noconfirm --noprogressbar --needed /built/*.pkg.tar.* && rm -r /built

ENTRYPOINT ["/usr/bin/blender", "-b"]
