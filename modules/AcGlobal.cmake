
# Make sure we have our templates and tools available.
# For an integrated build, this just means setting some vars.
# For a separate build, we load the installed config file.
if(NOT ACMAKE_INTEGRATED_BUILD)
    include(AcMakeConfig) # XXX this should probably use the same config file mechanism like pro60_deps
else(NOT ACMAKE_INTEGRATED_BUILD)
    set(ACMAKE_TOOLS_DIR ${AcMake_SOURCE_DIR}/tools)
    set(ACMAKE_MODULES_DIR ${AcMake_SOURCE_DIR}/modules)
    set(ACMAKE_TEMPLATES_DIR ${AcMake_SOURCE_DIR}/templates)
    set(ACMAKE_INCLUDE_DIR ${AcMake_SOURCE_DIR}/include)
endif(NOT ACMAKE_INTEGRATED_BUILD)

# Subdirectory for files generated by acmake, relative to CMAKE_CURRENT_BINARY_DIR
set(ACMAKE_BINARY_SUBDIR "ACMakeFiles")

# All sources may include acmake headers
include_directories(
    ${ACMAKE_INCLUDE_DIR}        # acmake distribution
    ${CMAKE_BINARY_DIR}/include/ # build global
)

