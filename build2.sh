#!/usr/bin/env bash

set -eux

exec > >(tee "build.log") 2>&1
date

function mkcd()
{
  rm -rf "$1" && mkdir "$1" && pushd "$1"
}

function revert_conan_uninstall()
{
  # revert simulated uninstall (if present)
  if [[ -d ~/.conan/data.bk ]]; then
    mv ~/.conan/data.bk ~/.conan/data
  fi
}

function conan_uninstall()
{
  mv ~/.conan/data ~/.conan/data.bk # simulate uninstall to save time
}

# Remove old 'hello' and 'bye' installs
sudo rm -rf /usr/local/include/hello.h \
            /usr/local/include/bye.h \
            /usr/local/lib/libhello** \
            /usr/local/lib/libbye** \
            /usr/local/lib/cmake/hello/ \
            /usr/local/lib/cmake/bye/
conan remove -f hello

# Create 'hello' Conan package
pushd hello
conan create . user/channel
popd

# Build 'bye' library against 'hello' Conan package and install to /usr/local/
pushd bye/src
mkcd "build"
conan install ..
cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_paths.cmake -DCMAKE_BUILD_TYPE=Debug
cmake --build .
sudo cmake --install .
cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_paths.cmake -DCMAKE_BUILD_TYPE=Release
cmake --build .
sudo cmake --install .
popd
popd

# Remove 'hello' Conan package and install to /usr/local/ instead
conan remove -f hello

pushd hello/src
mkcd "build"
cmake .. -DCMAKE_BUILD_TYPE=Debug
cmake --build .
sudo cmake --install .

cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .
sudo cmake --install .

popd
popd

# Build project against /usr/local/ versions of 'hello' and 'bye'
pushd project
mkcd "build"
cmake .. -DCMAKE_BUILD_TYPE=Debug
cmake --build .
./example

cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .
./example

popd
popd
