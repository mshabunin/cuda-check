#!/bin/bash

set -ex

CMAKE_C_COMPILER_LAUNCHER=ccache
CMAKE_CXX_COMPILER_LAUNCHER=ccache
CMAKE_CUDA_COMPILER_LAUNCHER=ccache

platform=$1

build() {
D=$1 ; shift 1
mkdir -p $D
pushd $D && rm -rf *
cmake -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DOPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
        -DWITH_CUDA=ON \
        -DCUDA_ARCH_BIN=90 \
        -DENABLE_CUDA_FIRST_CLASS_LANGUAGE=ON \
        ${@} \
    /opencv
ninja
}


test_() {
D=$1 ; shift 1
pushd $D
OPENCV_TEST_DATA_PATH=/opencv_extra/testdata \
    ./bin/opencv_test_videoio --gtest_filter=*:-*audio* \
        | tee /workspace/log-${platform}.txt 2>&1
popd
}

build /workspace/build-opencv
# test_ /workspace/build-opencv
