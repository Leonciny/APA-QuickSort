########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(eabase_COMPONENT_NAMES "")
if(DEFINED eabase_FIND_DEPENDENCY_NAMES)
  list(APPEND eabase_FIND_DEPENDENCY_NAMES )
  list(REMOVE_DUPLICATES eabase_FIND_DEPENDENCY_NAMES)
else()
  set(eabase_FIND_DEPENDENCY_NAMES )
endif()

########### VARIABLES #######################################################################
#############################################################################################
set(eabase_PACKAGE_FOLDER_RELEASE "/home/iony/.conan2/p/eabasd910375b4b3a0/p")
set(eabase_BUILD_MODULES_PATHS_RELEASE )


set(eabase_INCLUDE_DIRS_RELEASE "${eabase_PACKAGE_FOLDER_RELEASE}/include"
			"${eabase_PACKAGE_FOLDER_RELEASE}/include/Common"
			"${eabase_PACKAGE_FOLDER_RELEASE}/include/Common/EABase")
set(eabase_RES_DIRS_RELEASE )
set(eabase_DEFINITIONS_RELEASE )
set(eabase_SHARED_LINK_FLAGS_RELEASE )
set(eabase_EXE_LINK_FLAGS_RELEASE )
set(eabase_OBJECTS_RELEASE )
set(eabase_COMPILE_DEFINITIONS_RELEASE )
set(eabase_COMPILE_OPTIONS_C_RELEASE )
set(eabase_COMPILE_OPTIONS_CXX_RELEASE )
set(eabase_LIB_DIRS_RELEASE )
set(eabase_BIN_DIRS_RELEASE )
set(eabase_LIBRARY_TYPE_RELEASE UNKNOWN)
set(eabase_IS_HOST_WINDOWS_RELEASE 0)
set(eabase_LIBS_RELEASE )
set(eabase_SYSTEM_LIBS_RELEASE )
set(eabase_FRAMEWORK_DIRS_RELEASE )
set(eabase_FRAMEWORKS_RELEASE )
set(eabase_BUILD_DIRS_RELEASE )
set(eabase_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(eabase_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${eabase_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${eabase_COMPILE_OPTIONS_C_RELEASE}>")
set(eabase_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${eabase_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${eabase_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${eabase_EXE_LINK_FLAGS_RELEASE}>")


set(eabase_COMPONENTS_RELEASE )