########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(EABase_FIND_QUIETLY)
    set(EABase_MESSAGE_MODE VERBOSE)
else()
    set(EABase_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/EABaseTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${eabase_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(EABase_VERSION_STRING "2.09.12")
set(EABase_INCLUDE_DIRS ${eabase_INCLUDE_DIRS_RELEASE} )
set(EABase_INCLUDE_DIR ${eabase_INCLUDE_DIRS_RELEASE} )
set(EABase_LIBRARIES ${eabase_LIBRARIES_RELEASE} )
set(EABase_DEFINITIONS ${eabase_DEFINITIONS_RELEASE} )


# Only the last installed configuration BUILD_MODULES are included to avoid the collision
foreach(_BUILD_MODULE ${eabase_BUILD_MODULES_PATHS_RELEASE} )
    message(${EABase_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


