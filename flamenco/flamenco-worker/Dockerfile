FROM ghcr.io/k8ieone/arch-builder:latest AS builder
RUN ulimit -n 1024000 && build-aur flamenco-worker

FROM ghcr.io/k8ieone/blender:latest AS runner
COPY --from=builder /home/builder/built/ /built/
RUN pacman -U --noconfirm --noprogressbar /built/*.pkg.tar.*
ENTRYPOINT /usr/bin/flamenco-worker
