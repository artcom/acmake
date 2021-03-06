
if(GTKMM_FIND_REQUIRED)
    set(GTKMM_REQUIRED_FLAG REQUIRED)
endif(GTKMM_FIND_REQUIRED)

include(FindPkgConfig)

pkg_search_module(GTKMM gtkmm-2.4 ${GTKMM_REQUIRED_FLAG})
pkg_search_module(GLADEMM libglademm-2.4 ${GTKMM_REQUIRED_FLAG})

list(APPEND GTKMM_LIBRARIES ${GLADEMM_LIBRARIES})
list(APPEND GTKMM_LIBRARY_DIRS ${GLADEMM_LIBRARY_DIRS})
list(APPEND GTKMM_INCLUDE_DIRS ${GLADEMM_INCLUDE_DIRS})

function(gtkmm_fix_cxx_libname OUTR OUTD IN)
    string(REGEX REPLACE "([a-z]*)-([0-9]*)\\.([0-9]*)" "\\1-vc90-\\2_\\3" RESULTR "${LIB}")
    string(REGEX REPLACE "([a-z]*)-([0-9]*)\\.([0-9]*)" "\\1-vc90-d-\\2_\\3" RESULTD "${LIB}")
    set(${OUTR} ${RESULTR} PARENT_SCOPE)
    set(${OUTD} ${RESULTD} PARENT_SCOPE)
endfunction(gtkmm_fix_cxx_libname)

if(WIN32 AND GTKMM_FOUND)
    set(GTKMM_LIBRARIES_FIXED)
    set(GTKMM_LIBRARIES_FIXED_D)
    set(GTKMM_LIBRARIES_FIXED_C)
    foreach(LIB ${GTKMM_LIBRARIES})
        if(LIB MATCHES ".*mm-[0-9]*\\.[0-9]*$")
            gtkmm_fix_cxx_libname(LIBR LIBD ${LIB})
            list(APPEND GTKMM_LIBRARIES_FIXED   ${LIBR})
            list(APPEND GTKMM_LIBRARIES_FIXED_D ${LIBD})
        elseif(LIB MATCHES "sigc-[0-9]*\\.[0-9]*$")
            gtkmm_fix_cxx_libname(LIBR LIBD ${LIB})
            list(APPEND GTKMM_LIBRARIES_FIXED   ${LIBR})
            list(APPEND GTKMM_LIBRARIES_FIXED_D ${LIBD})
        else(LIB MATCHES ".*mm-[0-9]*\\.[0-9]*$")
            if(LIB MATCHES "xml2")
                set(LIB "libxml2")
            elseif(LIB MATCHES "z")
                set(LIB "zdll")
            elseif(LIB MATCHES "png14")
                set(LIB "libpng")
            else(LIB MATCHES "xml2")
                set(LIB ${LIB})
            endif(LIB MATCHES "xml2")
            list(APPEND GTKMM_LIBRARIES_FIXED_C ${LIB})
        endif(LIB MATCHES ".*mm-[0-9]*\\.[0-9]*$")
    endforeach(LIB)
    set(GTKMM_LIBRARIES   ${GTKMM_LIBRARIES_FIXED})
    set(GTKMM_LIBRARIES_D ${GTKMM_LIBRARIES_FIXED_D})
    set(GTKMM_LIBRARIES_C ${GTKMM_LIBRARIES_FIXED_C})
endif(WIN32 AND GTKMM_FOUND)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    GTKMM DEFAULT_MSG GTKMM_LIBRARIES
)
