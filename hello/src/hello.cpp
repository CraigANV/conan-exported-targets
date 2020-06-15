#include <iostream>

#include "hello.h"

void hello()
{
	#ifdef NDEBUG
    std::cout << "Hello World Release!\n";
    #else
    std::cout << "Hello World Debug!\n";
    #endif
}
