include $(THEOS)/makefiles/common.mk

TOOL_NAME = attach detach

attach_FILES = attach.m
attach_FRAMEWORKS = IOKit Foundation

detach_FILES = detach.c
detach_FRAMEWORKS = IOKit Foundation

include $(THEOS_MAKE_PATH)/tool.mk

before-package::
	$(THEOS)/toolchain/linux/iphone/bin/ldid -S./ent.plist $(THEOS_STAGING_DIR)/usr/bin/attach
	$(THEOS)/toolchain/linux/iphone/bin/ldid -S./ent.plist $(THEOS_STAGING_DIR)/usr/bin/detach
