########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(EASTL_FIND_QUIETLY)
    set(EASTL_MESSAGE_MODE VERBOSE)
else()
    set(EASTL_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/EASTLTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${eastl_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(EASTL_VERSION_STRING "3.21.12")
set(EASTL_INCLUDE_DIRS ${eastl_INCLUDE_DIRS_RELEASE} )
set(EASTL_INCLUDE_DIR ${eastl_INCLUDE_DIRS_RELEASE} )
set(EASTL_LIBRARIES ${eastl_LIBRARIES_RELEASE} )
set(EASTL_DEFINITIONS ${eastl_DEFINITIONS_RELEASE} )


# Only the last installed configuration BUILD_MODULES are included to avoid the collision
foreach(_BUILD_MODULE ${eastl_BUILD_MODULES_PATHS_RELEASE} )
    message(${EASTL_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


