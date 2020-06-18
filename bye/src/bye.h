#pragma once

#include <boost/chrono.hpp>
#include <boost/optional.hpp>

#ifdef WIN32
  #define BYE_EXPORT __declspec(dllexport)
#else
  #define BYE_EXPORT
#endif

BYE_EXPORT void bye();

BYE_EXPORT boost::optional<std::string> get_md5_sum();

BYE_EXPORT boost::chrono::system_clock::time_point get_sys_clock();
