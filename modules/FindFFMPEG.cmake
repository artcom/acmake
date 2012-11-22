set(FFMPEG_SUBLIBS avcodec avformat avutil swscale)

if(WIN32)
    foreach(SUBLIB ${FFMPEG_SUBLIBS})
        string(TOUPPER ${SUBLIB} SUBLIB_UPPER)
        find_path( ${SUBLIB_UPPER}_INCLUDE_DIRS lib${SUBLIB}/${SUBLIB}.h )
        find_library( ${SUBLIB_UPPER}_LIBRARIES NAMES ${SUBLIB} lib${SUBLIB})
        mark_as_advanced(
            ${SUBLIB_UPPER}_LIBRARIES
            ${SUBLIB_UPPER}_INCLUDE_DIRS
        )
    endforeach(SUBLIB ${FFMPEG_SUBLIBS})

    set(FFMPEG_ALL_FOUND YES)
else(WIN32)
    foreach(SUBLIB ${FFMPEG_SUBLIBS})
        string(TOUPPER ${SUBLIB} SUBLIB_UPPER)
        pkg_search_module(${SUBLIB_UPPER} REQUIRED lib${SUBLIB})
        set (${SUBLIB_UPPER}_INCLUDE_DIRS ${${SUBLIB_UPPER}_INCLUDEDIR})
        find_library( ${SUBLIB_UPPER}_LIBRARIES NAMES ${SUBLIB} lib${SUBLIB} HINTS ${${SUBLIB_UPPER}_LIBDIR})
        mark_as_advanced(
            ${SUBLIB_UPPER}_LIBRARIES
            ${SUBLIB_UPPER}_INCLUDE_DIRS
        )
    endforeach(SUBLIB ${FFMPEG_SUBLIBS})

    if(AVCODEC_FOUND AND AVFORMAT_FOUND AND AVUTIL_FOUND)
        set(FFMPEG_ALL_FOUND YES)
    endif(AVCODEC_FOUND AND AVFORMAT_FOUND AND AVUTIL_FOUND)
endif(WIN32)

set(FFMPEG_LIBRARIES ${AVCODEC_LIBRARIES} ${AVFORMAT_LIBRARIES} ${AVFILTER_LIBRARIES} ${SWSCALE_LIBRARIES} ${AVUTIL_LIBRARIES})
set(FFMPEG_LIBRARY_DIRS ${AVCODEC_LIBRARY_DIRS} ${AVFORMAT_LIBRARY_DIRS} ${AVFILTER_LIBRARY_DIRS} ${SWSCALE_LIBRARY_DIRS} ${AVUTIL_LIBRARY_DIRS})
set(FFMPEG_INCLUDE_DIRS ${AVCODEC_INCLUDE_DIRS} ${AVFORMAT_INCLUDE_DIRS} ${AVFILTER_INCLUDE_DIRS} ${SWSCALE_INCLUDE_DIRS} ${AVUTIL_INCLUDE_DIRS})
mark_as_advanced(FFMPEG_LIBRARIES FFMPEG_LIBRARY_DIRS FFMPEG_INCLUDE_DIRS)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    FFMPEG DEFAULT_MSG FFMPEG_LIBRARIES FFMPEG_ALL_FOUND
)

