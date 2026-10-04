THEOS_DEVICE_IP = 127.0.0.1
TARGET = iphone:clang:16.7
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SymbolsStub
SymbolsStub_FILES = Tweak.xm
SymbolsStub_FRAMEWORKS = Foundation UIKit
SymbolsStub_PRIVATE_FRAMEWORKS = CydiaSubstrate
SymbolsStub_LDFLAGS += -lobjc

include $(THEOS_MAKE_PATH)/tweak.mk
