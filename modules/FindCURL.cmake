# - Find curl
# Find the native CURL headers and libraries.
#
#  CURL_INCLUDE_DIRS - where to find curl/curl.h, etc.
#  CURL_LIBRARIES    - List of libraries when using curl.
#  CURL_FOUND        - True if curl found.

if (NOT WIN32)
    find_package(PkgConfig)
    pkg_check_modules(PC_LIBCURL libcurl)
    set(CURL_DEFINITIONS ${PC_LIBCURL_CFLAGS_OTHER})
endif(NOT WIN32)

# Look for the header file.
FIND_PATH(CURL_INCLUDE_DIR NAMES curl/curl.h
        HINTS ${PC_LIBCURL_INCLUDEDIR}
        PATH_SUFFIXES include )
MARK_AS_ADVANCED(CURL_INCLUDE_DIR)

# Look for the library.
FIND_LIBRARY(CURL_LIBRARY NAMES curl libcurl HINTS ${PC_LIBCURL_LIBDIR})
FIND_LIBRARY(CURL_LIBRARY_D NAMES curld libcurld HINTS ${PC_LIBCURL_LIBDIR})
MARK_AS_ADVANCED(CURL_LIBRARY CURL_LIBRARY_D)

# handle the QUIETLY and REQUIRED arguments and set CURL_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(CURL DEFAULT_MSG CURL_LIBRARY CURL_INCLUDE_DIR)

IF(CURL_FOUND)
    SET(CURL_LIBRARIES ${CURL_LIBRARY})
    SET(CURL_LIBRARIES_D ${CURL_LIBRARY_D})
    SET(CURL_INCLUDE_DIRS ${CURL_INCLUDE_DIR})
  
    file (READ ${CURL_INCLUDE_DIR}/curl/curlver.h CURL_VERSION_H_CONTENTS)
    string (REGEX MATCH "LIBCURL_VERSION_MAJOR[ \t]+([0-9]+)"
            LIBCURL_VERSION_MJ ${CURL_VERSION_H_CONTENTS})
    string (REGEX MATCH "([0-9]+)" LIBCURL_VERSION_MJ ${LIBCURL_VERSION_MJ})
    string (REGEX MATCH "LIBCURL_VERSION_MINOR[ \t]+([0-9]+)"
            LIBCURL_VERSION_MI ${CURL_VERSION_H_CONTENTS})
    string (REGEX MATCH "([0-9]+)" LIBCURL_VERSION_MI ${LIBCURL_VERSION_MI})
    string (REGEX MATCH "LIBCURL_VERSION_PATCH[ \t]+([0-9]+)"
            LIBCURL_VERSION_PT ${CURL_VERSION_H_CONTENTS})
    string (REGEX MATCH "([0-9]+)" LIBCURL_VERSION_PT ${LIBCURL_VERSION_PT})
    set (CURL_MAJOR_VERSION ${LIBCURL_VERSION_MJ})
    set (CURL_MINOR_VERSION ${LIBCURL_VERSION_MI})
    set (CURL_PATCH_VERSION ${LIBCURL_VERSION_PT})
    set (CURL_VERSION ${CURL_MAJOR_VERSION}.${CURL_MINOR_VERSION}.${CURL_PATCH_VERSION})
    message(STATUS "curl version: ${CURL_VERSION}")
    set (CURL_VERSION_INT ${CURL_MAJOR_VERSION}${CURL_MINOR_VERSION}${CURL_PATCH_VERSION})
ELSE(CURL_FOUND)
  SET(CURL_LIBRARIES)
  SET(CURL_INCLUDE_DIRS)
ENDIF(CURL_FOUND)
