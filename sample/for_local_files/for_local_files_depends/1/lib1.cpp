#include "lib1.h"
#include "depends/3/lib3.h"
#include <iostream>

void C1::name()
{
  std::cout << "I am C1, and I have a C3:" << std::endl;
  C3 c;
  c.name();
}
