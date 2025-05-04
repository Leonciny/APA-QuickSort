# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(eastl_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(eastl_FRAMEWORKS_FOUND_RELEASE "${eastl_FRAMEWORKS_RELEASE}" "${eastl_FRAMEWORK_DIRS_RELEASE}")

set(eastl_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET eastl_DEPS_TARGET)
    add_library(eastl_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET eastl_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${eastl_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${eastl_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:EABase::EABase>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### eastl_DEPS_TARGET to all of them
conan_package_library_targets("${eastl_LIBS_RELEASE}"    # libraries
                              "${eastl_LIB_DIRS_RELEASE}" # package_libdir
                              "${eastl_BIN_DIRS_RELEASE}" # package_bindir
                              "${eastl_LIBRARY_TYPE_RELEASE}"
                              "${eastl_IS_HOST_WINDOWS_RELEASE}"
                              eastl_DEPS_TARGET
                              eastl_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "eastl"    # package_name
                              "${eastl_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${eastl_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET EASTL::EASTL
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${eastl_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${eastl_LIBRARIES_TARGETS}>
                 )

    if("${eastl_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET EASTL::EASTL
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     eastl_DEPS_TARGET)
    endif()

    set_property(TARGET EASTL::EASTL
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${eastl_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET EASTL::EASTL
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${eastl_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET EASTL::EASTL
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${eastl_LIB_DIRS_RELEASE}>)
    set_property(TARGET EASTL::EASTL
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${eastl_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET EASTL::EASTL
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${eastl_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(eastl_LIBRARIES_RELEASE EASTL::EASTL)
