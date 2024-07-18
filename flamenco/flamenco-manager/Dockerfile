FROM ghcr.io/k8ieone/arch-builder:latest AS builder
RUN ulimit -n 1024000 && build-aur flamenco-manager

FROM ghcr.io/k8ieone/arch-base:latest AS runner
COPY --from=builder /home/builder/built/ /built/
RUN pacman -U --noconfirm --noprogressbar /built/*.pkg.tar.*

WORKDIR /data
CMD /usr/bin/flamenco-manager
