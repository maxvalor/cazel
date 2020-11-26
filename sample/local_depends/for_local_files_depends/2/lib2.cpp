#include "lib2.h"
#include "depends_not_same/3/lib3.h"
#include <iostream>

void C2::name()
{
  std::cout << "I am C2, and I have a C3:" << std::endl;
  C3 c;
  c.name();
}
