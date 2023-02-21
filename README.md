# Blender
The image is based on Arch Linux, using [lopsided](https://github.com/lopsided98/archlinux-docker)'s images. Blender is simply installed as a package.
The PKGBUILD was adopted from the [x86 package](https://github.com/archlinux/svntogit-community/tree/packages/blender/trunk).

Supported architectures are `linux/aarch64` and `linux/amd64`. `linux/arm/v7` was dropped because I couldn't get it to build 😩. The support of ARMv7 in most of Blender's dependencies is basically nonexistent 😔.

## Known issues
 - In order to compile on ARM and have feature parity with x86, some features had to be disabled:
   - GPGPU rendering, this includes [Optix](https://developer.nvidia.com/rtx/ray-tracing/optix), [CUDA](https://developer.nvidia.com/cuda-toolkit) and AMD HIP
   - [OpenImageDenoise](https://www.openimagedenoise.org/), [#125](https://github.com/OpenImageDenoise/oidn/issues/125)
   - [OpenPGL](https://github.com/OpenPathGuidingLibrary/openpgl/issues/6)

## Versions
| Blender version | Tag                             | GHCR Link                                                                                   | Notes              |
| :-------------- | :-------------:                 | :-------------:                                                                             | --------------:    |
| 2.93.5          | `ghcr.io/a13xie/blender:2.93.5` | [Here](https://github.com/a13xie/blender-docker/pkgs/container/blender/13501502?tag=2.93.5) |                    |
| 3.3.1           | `ghcr.io/a13xie/blender:3.3.1`  | [Here](https://github.com/a13xie/blender-docker/pkgs/container/blender/49465751?tag=3.3.1)  | Enabled Alembic    |
| 3.4.1           | `ghcr.io/a13xie/blender:3.4.1`  | [Here](https://github.com/a13xie/blender-docker/pkgs/container/blender/49465751?tag=3.4.1)  | Working Embree 🎉  |
