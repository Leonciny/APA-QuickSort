########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(eastl_COMPONENT_NAMES "")
if(DEFINED eastl_FIND_DEPENDENCY_NAMES)
  list(APPEND eastl_FIND_DEPENDENCY_NAMES EABase)
  list(REMOVE_DUPLICATES eastl_FIND_DEPENDENCY_NAMES)
else()
  set(eastl_FIND_DEPENDENCY_NAMES EABase)
endif()
set(EABase_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(eastl_PACKAGE_FOLDER_RELEASE "/home/iony/.conan2/p/b/eastl9a3d7ce7b6cb8/p")
set(eastl_BUILD_MODULES_PATHS_RELEASE )


set(eastl_INCLUDE_DIRS_RELEASE "${eastl_PACKAGE_FOLDER_RELEASE}/include")
set(eastl_RES_DIRS_RELEASE )
set(eastl_DEFINITIONS_RELEASE )
set(eastl_SHARED_LINK_FLAGS_RELEASE )
set(eastl_EXE_LINK_FLAGS_RELEASE )
set(eastl_OBJECTS_RELEASE )
set(eastl_COMPILE_DEFINITIONS_RELEASE )
set(eastl_COMPILE_OPTIONS_C_RELEASE )
set(eastl_COMPILE_OPTIONS_CXX_RELEASE )
set(eastl_LIB_DIRS_RELEASE "${eastl_PACKAGE_FOLDER_RELEASE}/lib")
set(eastl_BIN_DIRS_RELEASE )
set(eastl_LIBRARY_TYPE_RELEASE STATIC)
set(eastl_IS_HOST_WINDOWS_RELEASE 0)
set(eastl_LIBS_RELEASE EASTL)
set(eastl_SYSTEM_LIBS_RELEASE m pthread)
set(eastl_FRAMEWORK_DIRS_RELEASE )
set(eastl_FRAMEWORKS_RELEASE )
set(eastl_BUILD_DIRS_RELEASE )
set(eastl_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(eastl_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${eastl_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${eastl_COMPILE_OPTIONS_C_RELEASE}>")
set(eastl_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${eastl_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${eastl_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${eastl_EXE_LINK_FLAGS_RELEASE}>")


set(eastl_COMPONENTS_RELEASE )