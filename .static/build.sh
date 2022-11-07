#!/usr/bin/env bash
# Blender extractor, inspired by mguentner/remote-aur-builder

set -x
set -e
CIDFILE=$(mktemp /tmp/build-container.XXXXXXXXX)
[[ -e $CIDFILE ]] && rm $CIDFILE

docker buildx build . --platform=linux/$1 -t k8ie/arch-builder:blender-$1 --load
docker run --cidfile $CIDFILE k8ie/aur-builder:blender-$1 /usr/bin/file /home/builder/blender-cmake/blender.zip
docker cp $(cat $CIDFILE):/home/builder/blender-cmake/blender.zip ./blender-$1.zip
[[ -e $CIDFILE ]] && rm $CIDFILE
