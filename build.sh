#! /bin/sh
python depends_resolver target_project
cd target_project
mkdir build
cd build
cmake ..
make
