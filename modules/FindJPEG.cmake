# - Find JPEG
# Find the native JPEG includes and library
# This module defines
#  JPEG_INCLUDE_DIR, where to find jpeglib.h, etc.
#  JPEG_LIBRARIES, the libraries needed to use JPEG.
#  JPEG_FOUND, If false, do not try to use JPEG.
# also defined, but not for general use are
#  JPEG_LIBRARY, where to find the JPEG library.

FIND_PATH(JPEG_INCLUDE_DIR jpeglib.h)

SET(JPEG_NAMES ${JPEG_NAMES} jpeg libjpeg) 
FIND_LIBRARY(JPEG_LIBRARY NAMES ${JPEG_NAMES} )
SET(JPEG_NAMES_D ${JPEG_NAMES_D} jpegd libjpegd) 
FIND_LIBRARY(JPEG_LIBRARY_D NAMES ${JPEG_NAMES_D} )

# handle the QUIETLY and REQUIRED arguments and set JPEG_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(JPEG DEFAULT_MSG JPEG_LIBRARY JPEG_INCLUDE_DIR)

IF(JPEG_FOUND)
  SET(JPEG_LIBRARIES ${JPEG_LIBRARY})
  SET(JPEG_LIBRARIES_D ${JPEG_LIBRARY_D})
ENDIF(JPEG_FOUND)

# Deprecated declarations.
SET (NATIVE_JPEG_INCLUDE_PATH ${JPEG_INCLUDE_DIR} )
IF(JPEG_LIBRARY)
  GET_FILENAME_COMPONENT (NATIVE_JPEG_LIB_PATH ${JPEG_LIBRARY} PATH)
ENDIF(JPEG_LIBRARY)

MARK_AS_ADVANCED(JPEG_LIBRARY JPEG_LIBRARY_D JPEG_INCLUDE_DIR )
