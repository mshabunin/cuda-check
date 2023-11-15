#!/bin/bash

set -ex

# =======
# Prepare

mkdir -p workspace

# ===
# Run

run() {
    docker run -it \
    -u $(id -u):$(id -g) \
    -v `pwd`/workspace:/workspace \
    -v `pwd`/scripts:/scripts:ro \
    -v `pwd`/../opencv:/opencv \
    -v `pwd`/../opencv_contrib:/opencv_contrib:ro \
    -v `pwd`/../opencv_extra:/opencv_extra:ro \
    -e CCACHE_DIR=/workspace/.ccache \
    -e PATH=/scripts:${PATH} \
    ${tag} \
    $@
}

# 
for platform in 22-12.3 22-11.8 ; do

tag=opencv-cuda-check-${platform}
docker build --build-arg CPUNUM=12 -t ${tag} -f Dockerfile-${platform} .
run build.sh ${platform}

done
