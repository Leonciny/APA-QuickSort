# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/EABase-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${eabase_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${EABase_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET EABase::EABase)
    add_library(EABase::EABase INTERFACE IMPORTED)
    message(${EABase_MESSAGE_MODE} "Conan: Target declared 'EABase::EABase'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/EABase-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()