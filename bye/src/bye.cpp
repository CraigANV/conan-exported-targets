#include <iostream>

#include "bye.h"
#include "hello.h"

void bye()
{
    hello();

    #ifdef NDEBUG
    std::cout << "bye World Release!\n";
    #else
    std::cout << "bye World Debug!\n";
    #endif
}
