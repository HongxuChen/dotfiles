#!/bin/sh

V1=4.9
V2=4.8
VD=$V1

update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-$V1 50
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-$V1 50
update-alternatives --install /usr/bin/cpp cpp-bin /usr/bin/cpp-$V1 50

update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-$V2 100
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-$V2 100
update-alternatives --install /usr/bin/cpp cpp-bin /usr/bin/cpp-$V2 100

update-alternatives --set g++ /usr/bin/g++-$VD
update-alternatives --set gcc /usr/bin/gcc-$VD
update-alternatives --set cpp-bin /usr/bin/cpp-$VD
