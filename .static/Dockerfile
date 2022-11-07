FROM docker.io/alpine/git:latest AS cloner
WORKDIR /home/builder/
# Clone the sources
ENV blender_version=2.93.5
RUN git clone --branch v$blender_version --depth 1 https://git.blender.org/blender.git
WORKDIR /home/builder/blender
RUN git submodule init
RUN git submodule update
RUN git submodule foreach git checkout v$blender_version

FROM docker.io/debian:testing AS builder
# Install build dependencies
RUN apt update && apt install -y build-essential zip cmake bison pkg-config autoconf automake libtool yasm tcl ninja-build meson python3-mako mesa-common-dev libglu1-mesa-dev flex git libxrandr-dev libxinerama-dev libxcursor-dev libasound2-dev libpulse-dev libtinfo-dev libncurses-dev libxcb-randr0-dev libtbb-dev libxxf86vm-dev libxi-dev
# Create some directories
RUN mkdir -p /home/builder/blender-cmake
# Copy the sources
COPY --from=cloner /home/builder/blender /home/builder/blender
WORKDIR /home/builder/blender
COPY arm-tweaks.patch .
COPY oidn-fixbadpatch.patch .
COPY sqlite-config.patch .
RUN patch -p1 < arm-tweaks.patch
RUN patch -p1 < oidn-fixbadpatch.patch
RUN patch -p1 < sqlite-config.patch
RUN make deps
RUN cmake . -B../blender-cmake \
    -GNinja \
    -Cbuild_files/cmake/config/blender_release.cmake
#    -DLIBDIR=../blender-cmake/lib \
#    -DFFMPEG=/home/builder/blender-cmake/lib/ffmpeg \
#    -DWITH_CYCLES_EMBREE=OFF
WORKDIR /home/builder/blender-cmake
# Build!
RUN ninja
# Now create a release
RUN ninja install
# Now pack it into a zip
RUN cd bin && zip -r blender.zip .

FROM docker.io/debian:testing AS runner
COPY --from=builder /home/builder/blender-cmake/bin/blender.zip /home/builder/blender-cmake/blender.zip
