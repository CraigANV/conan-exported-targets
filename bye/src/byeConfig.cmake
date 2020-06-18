include(CMakeFindDependencyMacro)

find_dependency(hello)
find_dependency(Boost COMPONENTS chrono regex REQUIRED)

include("${CMAKE_CURRENT_LIST_DIR}/byeTargets.cmake")
