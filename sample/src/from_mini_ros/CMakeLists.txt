cmake_minimum_required(VERSION 3.0)

project(sample_ps CXX)

add_definitions(-std=c++11)

include_directories(
  include
  depends
  depends/mini_ros/include
)

add_executable(sample ./main.cpp)

set(SAMPLE_DEPENDS miniros)
target_link_libraries(sample ${SAMPLE_DEPENDS})
