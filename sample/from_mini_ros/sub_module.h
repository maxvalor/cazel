#ifndef SUB_MODULE_H_
#define SUB_MODULE_H_

#include <mini_ros/module.h>
#include <iostream>
#include "sample_msg.h"

class SubModule : public mini_ros::Module {
private:
  mini_ros::Subscriber sub;

public:
  SubModule () {}
  virtual ~SubModule () {}

  void onMsg(std::shared_ptr<SampleMsg> msg)
  {
    if (msg->data[0] == 9999990)
    {
      std::cout << "stop." << std::endl;
      sub.shutdown();
    }
    std::cout << "receive data:" << msg->data[0] << std::endl;
  }

  void onInit() override
  {
    sub =
      getModuleHandle().subscribe<SampleMsg>("sample_topic",
        std::bind(&SubModule::onMsg, this, std::placeholders::_1));

    mini_ros::Subscriber sub2 =
      getModuleHandle().subscribe<SampleMsg>("sample_topic",
        std::bind(&SubModule::onMsg, this, std::placeholders::_1));
  }

  void onExit() override
  {
    std::cout << "subscriber exit." << std::endl;
  }
};

#endif
