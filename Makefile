ARCHS = arm64
GO_EASY_ON_ME=1
include $(THEOS)/makefiles/common.mk

TOOL_NAME = jailsu
jailsu_FILES = main.mm

include $(THEOS_MAKE_PATH)/tool.mk
