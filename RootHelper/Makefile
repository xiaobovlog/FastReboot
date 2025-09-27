TARGET := iphone:clang:16.2:14.0
ARCHS = arm64e

include /Users/macair/theos/makefiles/common.mk

TOOL_NAME = ipccroothelper

ipccroothelper_FILES = $(wildcard *.m)
ipccroothelper_CFLAGS = -fobjc-arc
ipccroothelper_CODESIGN_FLAGS = -Sentitlements.plist
ipccroothelper_INSTALL_PATH = /usr/local/bin


include $(THEOS_MAKE_PATH)/tool.mk
