cmake_minimum_required(VERSION 3.0)

project(lib3 CXX)

add_definitions(-std=c++11)

add_library(lib3 SHARED
  lib3.cpp
)

target_link_libraries(lib3
  pthread
)
