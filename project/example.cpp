#include <iostream>

#include <boost/chrono.hpp>
#include <boost/optional.hpp>

#include "bye.h"

int main()
{
    bye();

    boost::optional<std::string> md5 = get_md5_sum();
    std::cout << "MD5: " << *md5 << '\n';

    auto time_point = get_sys_clock();
    std::cout << "Time since epoch (ns): " << time_point.time_since_epoch() << '\n';
}
