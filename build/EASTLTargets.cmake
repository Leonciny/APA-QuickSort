# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/EASTL-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${eastl_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${EASTL_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET EASTL::EASTL)
    add_library(EASTL::EASTL INTERFACE IMPORTED)
    message(${EASTL_MESSAGE_MODE} "Conan: Target declared 'EASTL::EASTL'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/EASTL-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()