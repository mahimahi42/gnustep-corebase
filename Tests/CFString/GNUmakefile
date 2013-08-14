# __GENERATED__ makefile marker
#

include $(GNUSTEP_MAKEFILES)/common.make
-include ../GNUmakefile.super

GNUSTEP_OBJ_DIR=./obj

TEST_TOOL_NAME =  create encodings format general hash mutablestring normalize objc_bridge_from_cf objc_bridge

ifeq ($(gcov),yes)
ADDITIONAL_OBJCFLAGS += -ftest-coverage -fprofile-arcs
ADDITIONAL_OBJCCFLAGS += -ftest-coverage -fprofile-arcs
ADDITIONAL_LDFLAGS += -ftest-coverage -fprofile-arcs
ADDITIONAL_TOOL_LIBS+=-lgcov
endif


create_OBJC_FILES=create.m
encodings_OBJC_FILES=encodings.m
format_OBJC_FILES=format.m
general_OBJC_FILES=general.m
hash_OBJC_FILES=hash.m
mutablestring_OBJC_FILES=mutablestring.m
normalize_OBJC_FILES=normalize.m
objc_bridge_from_cf_OBJC_FILES=objc_bridge_from_cf.m
objc_bridge_OBJC_FILES=objc_bridge.m

-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/test-tool.make
-include GNUmakefile.postamble

after-clean::
	rm -f core tests.log tests.sum oldtests.log oldtests.sum

