#!/usr/bin/env bash

set -eux

exec > >(tee "build.log") 2>&1
date

function mkcd()
{
  rm -rf "$1" && mkdir "$1" && pushd "$1"
}

# Remove old 'hello' and 'bye' installs
sudo rm -rf /usr/local/include/hello.h \
            /usr/local/include/bye.h \
            /usr/local/lib/libhello** \
            /usr/local/lib/libbye** \
            /usr/local/lib/cmake/hello/ \
            /usr/local/lib/cmake/bye/
conan remove -f hello

# Remove any apt install packages that may confuse things
readonly APT_PACKAGES="libboost-all-dev libboost-dev"
sudo apt purge -y $APT_PACKAGES
sudo apt autoremove -y

# Create 'hello' Conan package
pushd hello
conan create . user/channel
popd

# Build 'bye' library against 'hello' Conan package and install to /usr/local/
pushd bye/src
mkcd "build"
conan install ../.. # Install using conanfile.py
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

# Remove Conan 'boost' package and install using apt instead
conan remove -f boost
sudo apt install libboost-all-dev -y

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
