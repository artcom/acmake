# __ ___ ____ _____ ______ _______ ________ _______ ______ _____ ____ ___ __
#
# Copyright (C) 1993-2008, ART+COM AG Berlin, Germany <www.artcom.de>
#
# This file is part of the ART+COM CMake Library (acmake).
#
# It is distributed under the Boost Software License, Version 1.0. 
# (See accompanying file LICENSE_1_0.txt or copy at
#  http://www.boost.org/LICENSE_1_0.txt)             
# __ ___ ____ _____ ______ _______ ________ _______ ______ _____ ____ ___ __
#
#
# Macro to declare an executable within the current acmake project.
#
# __ ___ ____ _____ ______ _______ ________ _______ ______ _____ ____ ___ __
#

macro(ac_add_executable EXECUTABLE_NAME)
    parse_arguments(THIS_EXECUTABLE
        "SOURCES;HEADERS;DEPENDS;EXTERNS;"
        "DONT_INSTALL;NO_REVISION_INFO;"
        ${ARGN})

    # bring name into our namespace
    set(THIS_EXECUTABLE_NAME "${EXECUTABLE_NAME}")
    
    # declare searchpath for external headers and libs
    _ac_declare_searchpath(
        ${THIS_EXECUTABLE_NAME}
        "${THIS_EXECUTABLE_DEPENDS}" "${THIS_EXECUTABLE_EXTERNS}"
    )

    if( ACMAKE_BUILTIN_SVN_REVISIONS AND NOT THIS_EXECUTABLE_NO_REVISION_INFO)
        set( THIS_EXECUTABLE_REVISION_FILE
                "${CMAKE_CURRENT_BINARY_DIR}/${THIS_EXECUTABLE_NAME}${ACMAKE_REVISION_FILE_SUFFIX}")
    else( ACMAKE_BUILTIN_SVN_REVISIONS AND NOT THIS_EXECUTABLE_NO_REVISION_INFO)
        set( THIS_EXECUTABLE_REVISION_FILE "")
    endif( ACMAKE_BUILTIN_SVN_REVISIONS AND NOT THIS_EXECUTABLE_NO_REVISION_INFO)

    # define the target
    add_executable(${THIS_EXECUTABLE_NAME} ${THIS_EXECUTABLE_SOURCES}
            ${THIS_EXECUTABLE_HEADERS} ${THIS_EXECUTABLE_REVISION_FILE})

    if( ACMAKE_BUILTIN_SVN_REVISIONS AND NOT THIS_EXECUTABLE_NO_REVISION_INFO)
        # update repository and revision information
        _ac_add_repository_info( ${THIS_EXECUTABLE_NAME} ${THIS_EXECUTABLE_REVISION_FILE}
                "executable")
    endif( ACMAKE_BUILTIN_SVN_REVISIONS AND NOT THIS_EXECUTABLE_NO_REVISION_INFO)

    # attach rpath configuration
    _ac_attach_rpath(${THIS_EXECUTABLE_NAME})

    # attach depends and externs
    _ac_attach_depends(${THIS_EXECUTABLE_NAME} "${THIS_EXECUTABLE_DEPENDS}" "${THIS_EXECUTABLE_EXTERNS}")

    # define installation
    if(NOT THIS_EXECUTABLE_DONT_INSTALL)
        install(
            TARGETS ${THIS_EXECUTABLE_NAME}
            EXPORT ${CMAKE_PROJECT_NAME}
            RUNTIME
                DESTINATION bin
        )
    endif(NOT THIS_EXECUTABLE_DONT_INSTALL)
    
    # add our target to the current project
    if(NOT THIS_EXECUTABLE_DONT_INSTALL)
        ac_project_add_target(EXECUTABLES ${THIS_EXECUTABLE_NAME})
    endif(NOT THIS_EXECUTABLE_DONT_INSTALL)
    
endmacro(ac_add_executable)
