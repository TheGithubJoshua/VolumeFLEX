TARGET := iphone:clang:latest:12.0
INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

VolumeFLEX_FRAMEWORKS = AudioToolbox UIKit
TWEAK_NAME = VolumeFLEX
VolumeFLEX_FILES = Tweak.xm
VolumeFLEX_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += vfpb
include $(THEOS_MAKE_PATH)/aggregate.mk
