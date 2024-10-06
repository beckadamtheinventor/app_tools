APP_TOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

PYTHON := python3

INIT_LOC = 0
LINKER_SCRIPT = $(APP_TOOLS_DIR)/linker_script
OUTPUT_MAP = NO

APP_SRC_FILE = $(APP_TOOLS_DIR)/app.src

DEPS := $(APP_SRC_FILE) $(APP_TOOLS_DIR)/makefile $(DEPS)

EXTRA_LDFLAGS += \
	-i $(call QUOTE_ARG,provide __app_name = "$(APP_NAME)") \
	-i $(call QUOTE_ARG,provide __app_version = "$(APP_VERSION)") \
	-i $(call QUOTE_ARG,provide __app_desc = "$(DESCRIPTION)")

EXTRA_LDFLAGS += \
	-i $(call QUOTE_ARG,include "$(OBJDIR)/$(NAME)_exports.inc")

default: installer

include $(shell cedev-config --makefile)

TARGET8EK ?= $(NAME).8ek
APP_INST_NAME ?= APPINST

app: gen_exports $(BINDIR)/$(TARGET8EK)
installer: gen_exports $(BINDIR)/AppInstA.8xv

gen_exports:
	$(PYTHON) $(APP_TOOLS_DIR)/gen_exports.py $(SRCDIR)/main.c $(OBJDIR)/$(NAME)_exports.inc

$(BINDIR)/$(TARGET8EK): $(BINDIR)/$(TARGETBIN) $(APP_TOOLS_DIR)/make_8ek.py
	$(PYTHON) $(APP_TOOLS_DIR)/make_8ek.py $(BINDIR)/$(TARGETBIN) $(BINDIR)/$(TARGET8EK) $(NAME)

$(BINDIR)/AppInstA.8xv: $(BINDIR)/$(TARGETBIN) $(APP_TOOLS_DIR)/installer.bin $(APP_TOOLS_DIR)/make_installer.py
	$(PYTHON) $(APP_TOOLS_DIR)/make_installer.py $(BINDIR)/$(TARGETBIN) $(BINDIR) $(NAME) $(APP_INST_NAME)

.PHONY: default gen_exports installer app
