#APP_ABI := armeabi armeabi-v7a mips mips-r2 x86
APP_ABI := armeabi
APP_OPTIM := release
APP_PLATFORM := android-9

#需要一些stl的库
#APP_STL := stlport_static
APP_STL := gnustl_static

SPECIAL_FLAGS := -D_GLIBCXX_PERMIT_BACKWARD_HASH -fpermissive
STLPORT_FLAGS	:= -D_STLP_USE_STATIC_LIB=1 -D_STLP_USE_EXCEPTIONS=1 
NORMAL_FALGS	:= -fvisibility=hidden -fno-builtin -fno-omit-frame-pointer -DANDROID -DANDROID_NDK 
APP_CFLAGS    	+= $(SPECIAL_FLAGS) $(STLPORT_FLAGS) $(NORMAL_FALGS) 
APP_CPPFLAGS	+= $(SPECIAL_FLAGS) $(STLPORT_FLAGS) $(NORMAL_FALGS)
APP_CPPFLAGS 	+= -fexceptions

#STLPORT_FORCE_REBUILD := true