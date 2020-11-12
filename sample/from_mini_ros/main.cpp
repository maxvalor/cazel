#include <mini_ros/mini_ros.h>
#include "pub_module.h"
#include "sub_module.h"


int main()
{
  mini_ros::init();
  PubModule pm;
  SubModule sm;
  mini_ros::hold(&pm, &sm);
  return 0;
}
