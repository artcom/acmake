# - Find crypto++
# Find the native crypto++ headers and libraries.
#
#  CRYPTOPP_INCLUDE_DIRS - where to find crypto++ headers
#  CRYPTOPP_LIBRARIES    - List of libraries when using crypto++.
#  CRYPTOPP_FOUND        - True if crypto++ found.

# Look for the header file.
FIND_PATH(CRYPTOPP_INCLUDE_DIR NAMES crypto++/ cryptopp/
        PATH_SUFFIXES include )
MARK_AS_ADVANCED(CRYPTOPP_INCLUDE_DIR)

# Look for the library.
FIND_LIBRARY(CRYPTOPP_LIBRARY NAMES crypto++ libcrypto++ libcryptopp.a libcryptopp)
FIND_LIBRARY(CRYPTOPP_LIBRARY_D NAMES crypto++ libcrypto++ libcryptopp.a libcryptopp)
MARK_AS_ADVANCED(CRYPTOPP_LIBRARY CRYPTOPP_LIBRARY_D)

# handle the QUIETLY and REQUIRED arguments and set CRYPTOPP_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(CRYPTOPP DEFAULT_MSG CRYPTOPP_LIBRARY CRYPTOPP_INCLUDE_DIR)

IF(CRYPTOPP_FOUND)
  SET(CRYPTOPP_LIBRARIES ${CRYPTOPP_LIBRARY})
  SET(CRYPTOPP_LIBRARIES_D ${CRYPTOPP_LIBRARY_D})
  SET(CRYPTOPP_INCLUDE_DIRS ${CRYPTOPP_INCLUDE_DIR})
ELSE(CRYPTOPP_FOUND)
  SET(CRYPTOPP_LIBRARIES)
  SET(CRYPTOPP_INCLUDE_DIRS)
ENDIF(CRYPTOPP_FOUND)
