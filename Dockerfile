FROM ghcr.io/k8ieone/arch-builder:latest AS ispc_builder
RUN rm /usr/share/libalpm/hooks/package-cleanup.hook
ADD --chown=builder:builder arch-deps/ispc/ /home/builder/arch-deps/ispc
WORKDIR /home/builder/arch-deps/ispc
RUN --mount=type=cache,target=/var/cache/pacman,sharing=locked \
  --mount=type=cache,target=/home/builder/.cache/ccache,uid=1000,gid=1000 \
  --mount=type=cache,target=/home/builder/.cache/pikaur,uid=1000,gid=1000 \
  build-local

FROM ispc_builder AS embree_oidn_builder_base
RUN --mount=type=cache,target=/var/cache/pacman,sharing=locked \
  pacman -U --noconfirm --noprogressbar --needed /home/builder/built/*.pkg.tar.*

FROM embree_oidn_builder_base AS embree_builder
ADD --chown=builder:builder arch-deps/embree/ /home/builder/arch-deps/embree
WORKDIR /home/builder/arch-deps/embree
RUN --mount=type=cache,target=/var/cache/pacman,sharing=locked \
  --mount=type=cache,target=/home/builder/.cache/ccache,uid=1000,gid=1000 \
  --mount=type=cache,target=/home/builder/.cache/pikaur,uid=1000,gid=1000 \
  build-local

FROM embree_oidn_builder_base AS oidn_builder
ADD --chown=builder:builder arch-deps/oidn/ /home/builder/arch-deps/oidn
WORKDIR /home/builder/arch-deps/oidn
RUN --mount=type=cache,target=/var/cache/pacman,sharing=locked --mount=type=cache,target=/home/builder/.cache/ccache,uid=1000,gid=1000 build-local

FROM ghcr.io/k8ieone/arch-builder:latest AS blender_builder
RUN rm /usr/share/libalpm/hooks/package-cleanup.hook
ADD --chown=builder:builder arch-package/ /home/builder/arch-package
COPY --from=embree_builder /home/builder/built/* /built/
COPY --from=oidn_builder /home/builder/built/* /built/
RUN --mount=type=cache,target=/var/cache/pacman,sharing=locked \
  pacman -U --noconfirm --noprogressbar --needed /built/*.pkg.tar.* && rm -r /built
WORKDIR /home/builder/arch-package
RUN --mount=type=cache,target=/var/cache/pacman,sharing=locked \
  --mount=type=cache,target=/home/builder/.cache/ccache,uid=1000,gid=1000 \
  --mount=type=cache,target=/home/builder/.cache/pikaur,uid=1000,gid=1000 \
  build-local

FROM ghcr.io/k8ieone/arch-base:latest AS runner
RUN rm /usr/share/libalpm/hooks/package-cleanup.hook
LABEL org.opencontainers.image.source=https://github.com/k8ieone/blender-docker
LABEL org.opencontainers.image.description Blender 4.4.0
COPY --from=ispc_builder /home/builder/built/* /built/
COPY --from=embree_builder /home/builder/built/* /built/
COPY --from=oidn_builder /home/builder/built/* /built/
COPY --from=blender_builder /home/builder/built/* /built/
RUN --mount=type=cache,target=/var/cache/pacman,sharing=locked \
  pacman -U --noconfirm --noprogressbar --needed /built/*.pkg.tar.* && rm -r /built
COPY ./10-headless.conf /etc/X11/xorg.conf.d/10-headless.conf
RUN --mount=type=cache,target=/var/cache/pacman,sharing=locked \
  pacman -S --noconfirm --noprogressbar git mercurial python-zstandard xorg-xinit xorg-server xf86-video-dummy xterm psmisc

ENTRYPOINT ["/usr/bin/blender", "-b"]
