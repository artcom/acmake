if(OSX) 
    FIND_PATH(OPENCV_INCLUDE_DIR cv.h cxcore.h
        PATH_SUFFIXES opencv
        PATHS
        "C:/OpenCV2.1/include"
        /usr/local/include/opencv
        NO_DEFAULT_PATH 
    )
else()
    FIND_PATH(OPENCV_INCLUDE_DIR cv.h cxcore.h
        PATH_SUFFIXES opencv
        PATHS
        "C:/OpenCV2.1/include"
        /usr/local/include/opencv
    )
endif(OSX)

set(OPENCV_INCLUDE_DIRS ${OPENCV_INCLUDE_DIR})
mark_as_advanced(OPENCV_DEFINITIONS OPENCV_INCLUDE_DIR OPENCV_INCLUDE_DIRS)

if(WIN32) 
    set(OPENCV_SUBLIBS cv210.lib cvaux210.lib cxcore210.lib cxts210.lib highgui210.lib ml210.lib)
elseif(OSX)
    set(OPENCV_SUBLIBS opencv_nonfree opencv_calib3d opencv_contrib opencv_core opencv_features2d opencv_flann opencv_gpu opencv_highgui opencv_imgproc opencv_legacy opencv_ml opencv_objdetect opencv_photo opencv_stitching opencv_ts opencv_video opencv_videostab cvblob)
else()
    set(OPENCV_SUBLIBS cv cvaux cxcore highgui ml)
endif(WIN32)
mark_as_advanced(OPENCV_SUBLIBS)

if(OSX) 
    set(OPENCV_BLOB_SUBLIBS cvblob)
endif(OSX)
mark_as_advanced(OPENCV_BLOB_SUBLIBS)

set(OPENCV_LIBRARIES)
foreach(SUBLIB ${OPENCV_SUBLIBS})
    mark_as_advanced(OPENCV_SUBLIB_${SUBLIB})
    find_library(OPENCV_SUBLIB_${SUBLIB} NAMES ${SUBLIB}  PATH_SUFFIXES lib PATHS "C:/OpenCV2.1" /usr/local/lib )
    list(APPEND OPENCV_LIBRARIES ${OPENCV_SUBLIB_${SUBLIB}})        
endforeach(SUBLIB ${OPENCV_ALL_SUBLIBS})

if(OPENCV_BLOB_SUBLIBS) 
foreach(SUBLIB ${OPENCV_BLOB_SUBLIBS})
    mark_as_advanced(OPENCV_SUBLIB_${SUBLIB})
    find_library(OPENCV_SUBLIB_${SUBLIB} NAMES ${SUBLIB}  PATH_SUFFIXES lib PATHS "C:/OpenCV2.1" /usr/local/lib )
    list(APPEND OPENCV_LIBRARIES ${OPENCV_SUBLIB_${SUBLIB}})        
endforeach(SUBLIB ${OPENCV_ALL_SUBLIBS})
endif(OPENCV_BLOB_SUBLIBS)    

if(WIN32)
    set(OPENCV_SUBLIBS_D cv210d.lib cvaux210d.lib cxcore210d.lib cxts210d.lib highgui210d.lib ml210d.lib)
elseif(OSX)
    set(OPENCV_SUBLIBS_D opencv_nonfree opencv_calib3d opencv_contrib opencv_core opencv_features2d opencv_flann opencv_gpu opencv_highgui opencv_imgproc opencv_legacy opencv_ml opencv_objdetect opencv_photo opencv_stitching opencv_ts opencv_video opencv_videostab)
else()
    set(OPENCV_SUBLIBS_D cv cvaux cxcore highgui ml)
endif(WIN32)
mark_as_advanced(OPENCV_SUBLIBS_D)

set(OPENCV_LIBRARIES_D)
foreach(SUBLIB ${OPENCV_SUBLIBS})
    mark_as_advanced(OPENCV_SUBLIB_${SUBLIB}_D)
    find_library(OPENCV_SUBLIB_${SUBLIB}_D NAMES ${SUBLIB}  PATH_SUFFIXES lib PATHS "C:/OpenCV2.1" /usr/local/lib )
    list(APPEND OPENCV_LIBRARIES_D ${OPENCV_SUBLIB_${SUBLIB}})        
endforeach(SUBLIB ${OPENCV_ALL_SUBLIBS})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    OPENCV DEFAULT_MSG
    OPENCV_LIBRARIES OPENCV_LIBRARIES_D OPENCV_INCLUDE_DIR
)

