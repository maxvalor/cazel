cmake_minimum_required(VERSION 3.0)

project(lib2 CXX)

add_definitions(-std=c++11)

add_library(lib2 SHARED
  lib2.cpp
)

target_link_libraries(lib2
  lib3
)
