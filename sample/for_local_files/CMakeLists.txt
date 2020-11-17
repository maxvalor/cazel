cmake_minimum_required(VERSION 3.0)

project(for_local_files CXX)

add_definitions(-std=c++11)

add_executable(sample main.cpp)

set(SAMPLE_DEPENDS lib1 lib2)
target_link_libraries(sample ${SAMPLE_DEPENDS})
 
# added by depends_resolver
include(depends.cmake)
