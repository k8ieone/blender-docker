# Blender
The image is based on Arch Linux, using [lopsided](https://github.com/lopsided98/archlinux-docker)'s images. Blender is simply installed as a package.
The PKGBUILD was adopted from the [x86 package](https://github.com/archlinux/svntogit-community/tree/packages/blender/trunk).

Supported architectures are `linux/arm/v7`, `linux/aarch64` and `linux/amd64`.

## Known issues
 - In order to work with ARM, some features had to be disabled:
   - [Optix](https://developer.nvidia.com/rtx/ray-tracing/optix) and [CUDA](https://developer.nvidia.com/cuda-toolkit)
   - [OpenImageDenoise](https://www.openimagedenoise.org/)
   - [Embree](https://www.embree.org/)
   - 3.3.1 doesn't build for ARMv7 yet

## Versions
| Blender version | Tag                              | GHCR Link                                                                                    | Notes           |
| :-------------- | :-------------:                  | :-------------:                                                                              | --------------: |
| 2.93.5          | `ghcr.io/k8ieone/blender:2.93.5` | [Here](https://github.com/k8ieone/blender-docker/pkgs/container/blender/13501502?tag=2.93.5) |                 |
| 3.3.1           | `ghcr.io/k8ieone/blender:3.3.1`  | [Here](https://github.com/k8ieone/blender-docker/pkgs/container/blender/49465751?tag=3.3.1)  | Enabled Alembic |
