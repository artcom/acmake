# __ ___ ____ _____ ______ _______ ________ _______ ______ _____ ____ ___ __
#
# Copyright (C) 1993-2009, ART+COM AG Berlin, Germany <www.artcom.de>
#
# This file is part of the ART+COM CMake Library (acmake).
#
# It is distributed under the Boost Software License, Version 1.0. 
# (See accompanying file LICENSE_1_0.txt or copy at
#  http://www.boost.org/LICENSE_1_0.txt)             
# __ ___ ____ _____ ______ _______ ________ _______ ______ _____ ____ ___ __
#
#
# subversion repository information utility
# This script inspects the the URL and the revision of the source directory
# and writes a snippet of code to a target file. This file is picked up by the
# build process to provide revision and branch information at runtime.
# The file is only updated when necessary to help with minimal rebuilds.
#
# This script is *not* meant to be included. It should be run as a standalone
# script, like:
# cmake -DSOURCE_DIR=foo -DBINARY_DIR=bar -DTARGET_NAME=libfoobar \
#       -DTARGET_TYPE=library -P AcUpdateSvnRevision.cmake
#
# __ ___ ____ _____ ______ _______ ________ _______ ______ _____ ____ ___ __
#

if(NOT TARGET_NAME)
    message(FATAL_ERROR "variable TARGET_NAME not set")
endif(NOT TARGET_NAME)

if(NOT TARGET_TYPE)
    message(FATAL_ERROR "variable TARGET_TYPE not set. Should be 'library', 'executable' or 'plugin'")
endif(NOT TARGET_TYPE)

if(NOT REVISION_FILE)
    message(FATAL_ERROR "variable REVISION_FILE not set")
endif(NOT REVISION_FILE)

if(NOT SOURCE_DIR)
    message(FATAL_ERROR "variable SOURCE_DIR not set")
endif(NOT SOURCE_DIR)

find_program( SVNVERSION_CMD svnversion )
if( SVNVERSION_CMD )
    execute_process(COMMAND ${SVNVERSION_CMD} ${SOURCE_DIR}
            OUTPUT_VARIABLE CURRENT_SVN_VERSION
            RESULT_VARIABLE SVNVERSION_EXITCODE
            OUTPUT_STRIP_TRAILING_WHITESPACE)

    if( SVNVERSION_EXITCODE )
        message(SEND_ERROR "Failed to run the 'svnversion' utility.")
        set( CURRENT_SVN_VERSION "unknown" )
    endif( SVNVERSION_EXITCODE )
else( SVNVERSION_CMD )
    message(SEND_ERROR "Failed to find the 'svnversion' utility.")
    set( CURRENT_SVN_VERSION "unknown" )
endif( SVNVERSION_CMD )


find_program( SVN_CMD svn )
if( SVN_CMD )
    execute_process(COMMAND ${SVN_CMD} info ${SOURCE_DIR}
            OUTPUT_VARIABLE SVN_INFO
            RESULT_VARIABLE SVN_INFO_EXITCODE
            OUTPUT_STRIP_TRAILING_WHITESPACE)

    if( SVN_INFO_EXITCODE )
        message(SEND_ERROR "Failed to run 'svn info'.")
        set( SVN_URL "unknwon" )
    else( SVN_INFO_EXITCODE )
        string( REGEX REPLACE "\r?\n" ";" SVN_INFO_LINES ${SVN_INFO})
        foreach( line ${SVN_INFO_LINES} )
            string( REGEX MATCH "^URL: (.*)$" SVN_URL_LINE ${line} )
            if( SVN_URL_LINE )
                string( REGEX REPLACE "^URL: (.*)$" "\\1" SVN_URL ${SVN_URL_LINE})
                break()
            endif( SVN_URL_LINE )
        endforeach( line ${SVN_INFO_LINES} )
        if( NOT SVN_URL )
            message(SEND_ERROR "Failed to find SVN URL.")
            set(SVN_URL "unknown")
        endif( NOT SVN_URL )
    endif( SVN_INFO_EXITCODE )
else( SVN_CMD )
    message(SEND_ERROR "Failed to find the 'svn' utility.")
    set( SVN_URL "unknwon" )
endif( SVN_CMD )

# XXX: This sucks big time. Currently the code snippet is hardcoded in this string.
# There should be some way for the user (of AcMake) to specify a template
# of some sort.
# [DS]
set( CURRENT_SVN_VERSION_CPP
"// Generated by AcUpdateSvnRevision.cmake
#include <asl/base/RevisionInfo.h>
AC_SVN_REVISION(\"${TARGET_NAME}\", \"${SVN_URL}\", \"${CURRENT_SVN_VERSION}\", \"${TARGET_TYPE}\");")

file( GLOB SVN_VERSION_FILE ${REVISION_FILE})

if( SVN_VERSION_FILE )
    message("Found revision file ${SVN_VERSION_FILE}")
    file( READ ${SVN_VERSION_FILE} LAST_KNOWN_VERSION)

    string( COMPARE NOTEQUAL "${LAST_KNOWN_VERSION}" "${CURRENT_SVN_VERSION_CPP}"
            SVN_VERSION_CHANGED )
else(SVN_VERSION_FILE )
    # message("No revision file exists. Generating ${SVN_VERSION_FILE}")
    set( SVN_VERSION_CHANGED TRUE )
    set( SVN_VERSION_FILE ${REVISION_FILE} )
endif(SVN_VERSION_FILE)

if( SVN_VERSION_CHANGED )
    # message("Revision file is outdated. "
    #         "Regenerating with revision ${CURRENT_SVN_VERSION}.")
    file( WRITE "${SVN_VERSION_FILE}" "${CURRENT_SVN_VERSION_CPP}" )
else( SVN_VERSION_CHANGED )
    # message("Revision has not changed.")
endif( SVN_VERSION_CHANGED )
