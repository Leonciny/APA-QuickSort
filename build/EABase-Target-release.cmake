# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(eabase_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(eabase_FRAMEWORKS_FOUND_RELEASE "${eabase_FRAMEWORKS_RELEASE}" "${eabase_FRAMEWORK_DIRS_RELEASE}")

set(eabase_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET eabase_DEPS_TARGET)
    add_library(eabase_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET eabase_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${eabase_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${eabase_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### eabase_DEPS_TARGET to all of them
conan_package_library_targets("${eabase_LIBS_RELEASE}"    # libraries
                              "${eabase_LIB_DIRS_RELEASE}" # package_libdir
                              "${eabase_BIN_DIRS_RELEASE}" # package_bindir
                              "${eabase_LIBRARY_TYPE_RELEASE}"
                              "${eabase_IS_HOST_WINDOWS_RELEASE}"
                              eabase_DEPS_TARGET
                              eabase_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "eabase"    # package_name
                              "${eabase_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${eabase_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET EABase::EABase
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${eabase_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${eabase_LIBRARIES_TARGETS}>
                 )

    if("${eabase_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET EABase::EABase
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     eabase_DEPS_TARGET)
    endif()

    set_property(TARGET EABase::EABase
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${eabase_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET EABase::EABase
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${eabase_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET EABase::EABase
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${eabase_LIB_DIRS_RELEASE}>)
    set_property(TARGET EABase::EABase
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${eabase_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET EABase::EABase
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${eabase_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(eabase_LIBRARIES_RELEASE EABase::EABase)
