
TARGET := iphone:clang:14.3:12.1.2
ARCHS = armv7 arm64 arm64e

TOOL_NAME = attach attach2 detach

include $(THEOS)/makefiles/common.mk

attach_FILES = attach.m
attach_FRAMEWORKS = IOKit Foundation
attach_CODESIGN_FLAGS = -Sent.plist

attach2_FILES = attach2.m
attach2_PRIVATE_FRAMEWORKS = DiskImages2
attach2_CODESIGN_FLAGS = -Sent.plist

detach_FILES = detach.c
detach_FRAMEWORKS = IOKit Foundation
detach_CODESIGN_FLAGS = -Sent.plist

include $(THEOS_MAKE_PATH)/tool.mk