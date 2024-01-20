TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = VFPB
VFPB_FILES = VFPBRootListController.m
VFPB_FRAMEWORKS = UIKit
VFPB_PRIVATE_FRAMEWORKS = Preferences
VFPB_INSTALL_PATH = ROOT_PATH_NS/Library/PreferenceBundles
VFPB_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
