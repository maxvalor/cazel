cmake_minimum_required(VERSION 3.0)

project(lib3 CXX)

add_definitions(-std=c++11)

add_library(lib3 SHARED
  lib3.cpp
)

option(TEST_CMAKE_OPTION "test cmake option." OFF)
if(TEST_CMAKE_OPTION)
  message(STATUS "This is the config log:" ${TEST_CMAKE_OPTION})
endif(TEST_CMAKE_OPTION)

target_link_libraries(lib3
  pthread
)
