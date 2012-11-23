
cmake_minimum_required(VERSION 2.6)

project(AcMake)

# installation paths for our files
if(WIN32)
    set(ACMAKE_MODULES_SUB cmake)
elseif(APPLE)
    set(ACMAKE_MODULES_SUB lib/acmake/cmake)
elseif(UNIX)
    set(ACMAKE_MODULES_SUB lib/acmake/cmake)
endif(WIN32)
set(ACMAKE_TOOLS_SUB lib/acmake/tools)
set(ACMAKE_TEMPLATES_SUB lib/acmake/templates)
set(ACMAKE_INCLUDE_SUB include)

# determine absolute build time locations of our files
set(ACMAKE_INSTALLED_TOOLS_DIR ${CMAKE_INSTALL_PREFIX}/${ACMAKE_TOOLS_SUB})
set(ACMAKE_INSTALLED_MODULES_DIR ${CMAKE_INSTALL_PREFIX}/${ACMAKE_MODULES_SUB})
set(ACMAKE_INSTALLED_TEMPLATES_DIR ${CMAKE_INSTALL_PREFIX}/${ACMAKE_TEMPLATES_SUB})
set(ACMAKE_INSTALLED_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/${ACMAKE_INCLUDE_SUB})

# generate the config script
configure_file(AcMakeConfig.cmake.in ${CMAKE_BINARY_DIR}/${ACMAKE_MODULES_SUB}/AcMakeConfig.cmake @ONLY)

get_filename_component(ACMAKE_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
list(INSERT CMAKE_MODULE_PATH 0 ${ACMAKE_CMAKE_DIR}/modules)


include(AcBoostUtils)
include(AcVariableUtils)
include(AcDebug)
include(AcInstaller)

# declare our packaging solution
ac_begin_solution(
    AcMake
    VERSION_MAJOR 1 VERSION_MINOR 0 VERSION_PATCH 8
    DESCRIPTION  "AcMake"
    VENDOR       "ART+COM AG"
    CONTACT      "info@artcom.de"
    DESCRIPTION_FILE "${CMAKE_SOURCE_DIR}/DESCRIPTION.txt"
    LICENSE_FILE     "${CMAKE_SOURCE_DIR}/LICENSE.txt"
    PACKAGE_ICON     "${CMAKE_SOURCE_DIR}/installer/windows/NSIS-Header.bmp"
    INSTALLER_ICON   "${CMAKE_SOURCE_DIR}/installer/windows/shopping_bag.ico"
    UNINSTALLER_ICON "${CMAKE_SOURCE_DIR}/installer/windows/shopping_bag_grey.ico"
)

ac_end_solution(AcMake)
# install config file
install(
    FILES ${CMAKE_BINARY_DIR}/${ACMAKE_MODULES_SUB}/AcMakeConfig.cmake
    DESTINATION ${ACMAKE_MODULES_SUB}
)

# install modules
install(
    DIRECTORY modules/
    DESTINATION ${ACMAKE_MODULES_SUB}
    FILES_MATCHING
        PATTERN "*.cmake"
        PATTERN ".svn" EXCLUDE
)

# install templates
install(
    DIRECTORY templates/
    DESTINATION ${ACMAKE_TEMPLATES_SUB}
    FILES_MATCHING
        PATTERN "*.in"
        PATTERN "*.cpp"
        PATTERN ".svn" EXCLUDE
)

# install tools
set(EXTRA_TOOLS)
if(WIN32)
    list(APPEND EXTRA_TOOLS PATTERN "*.bat")
    list(APPEND EXTRA_TOOLS PATTERN "*.wsf")
    list(APPEND EXTRA_TOOLS PATTERN "*.js")
endif(WIN32)
install(
    DIRECTORY tools/
    DESTINATION ${ACMAKE_TOOLS_SUB}
    FILES_MATCHING
        PATTERN "*.jar"
        PATTERN "*.cmake"
        ${EXTRA_TOOLS}
	PATTERN ".svn" EXCLUDE
)

#install acmake headers
#install(
#    DIRECTORY include/
#    DESTINATION ${ACMAKE_INCLUDE_SUB}
#    FILES_MATCHING
#        PATTERN "*.h"
#	PATTERN ".svn" EXCLUDE
#)
