cmake_minimum_required(VERSION 3.0)

project(lib1 CXX)

add_definitions(-std=c++11)

add_library(lib1 SHARED
  lib1.cpp
)

target_link_libraries(lib1
  lib3
)
