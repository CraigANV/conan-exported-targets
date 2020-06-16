#!/usr/bin/env bash

set -eux

sudo rm -rf \
	/usr/local/lib/libhello* \
	/usr/local/lib/libbye* \
	/usr/local/lib/cmake/bye/ \
	/usr/local/lib/cmake/hello/ \
	/usr/local/include/hello.h \
	/usr/local/include/bye.h

conan remove -f hello
conan remove -f bye