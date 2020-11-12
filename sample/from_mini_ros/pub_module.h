#ifndef PUB_MODULE_H_
#define PUB_MODULE_H_

#include <mini_ros/module.h>
#include <iostream>
#include "sample_msg.h"

class PubModule : public mini_ros::Module {
private:
  bool running;

public:
  PubModule () {}
  virtual ~PubModule () {}

  void onInit() override
  {
    mini_ros::Publisher pub = getModuleHandle().advertise<SampleMsg>("sample_topic");
    int i = 10000000;
    running = true;
    while (running && --i)
    {
      SampleMsg msg;
      msg.data = new std::uint32_t[1];
      msg.data[0] = i;
      msg.len = 1;
      std::cout << "publish by object, data:" << msg.data[0] << std::endl;
      pub.publish(msg);

      std::shared_ptr<SampleMsg> spMsg(new SampleMsg());
      spMsg->data = new std::uint32_t[1];
      spMsg->data[0] = i;
      spMsg->len = 1;
      std::cout << "publish by shared pointer, data:" << spMsg->data[0] << std::endl;
      pub.publish(spMsg);

      sleep(100);
    }
  }

  void onStopped() override
  {
    running = false;
  }

  void onExit() override
  {
    std::cout << "publisher exit." << std::endl;
  }
};

#endif
