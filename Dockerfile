FROM ghcr.io/k8ieone/arch-builder:latest AS builder
ADD --chown=builder:builder arch-deps/ispc/ /home/builder/arch-deps/ispc
WORKDIR /home/builder/arch-deps/ispc
RUN ulimit -n 1024000 && sudo -u builder pikaur -Pi PKGBUILD --needed --noprogressbar --noconfirm
ADD --chown=builder:builder arch-deps/embree/ /home/builder/arch-deps/embree
WORKDIR /home/builder/arch-deps/embree
RUN ulimit -n 1024000 && sudo -u builder pikaur -Pi PKGBUILD --needed --noprogressbar --noconfirm
ADD --chown=builder:builder arch-package/ /home/builder/arch-package
WORKDIR /home/builder/arch-package
RUN ulimit -n 1024000 && build-local

FROM ghcr.io/k8ieone/arch-base:latest AS runner
LABEL org.opencontainers.image.source=https://github.com/k8ie/blender-docker
LABEL org.opencontainers.image.description Blender 4.2.0
COPY --from=builder /home/builder/built/ /built/
RUN pacman -S --noconfirm --noprogressbar git mercurial python-zstandard xorg-xinit xorg-server xf86-video-dummy xterm psmisc
COPY ./10-headless.conf /etc/X11/xorg.conf.d/10-headless.conf
RUN pacman -U --noconfirm --noprogressbar --needed /built/*.pkg.tar.* && rm -r /built

ENTRYPOINT ["/usr/bin/blender", "-b"]
