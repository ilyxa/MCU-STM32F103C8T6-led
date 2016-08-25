DEVICE ?= stm32f103c8t6
OPENCM3_DIR ?= $(CURDIR)/libopencm3

ifneq ($(V),1)
Q := @
endif

include $(OPENCM3_DIR)/mk/gcc-config.mk
include $(OPENCM3_DIR)/mk/genlink-config.mk

CPPFLAGS	+= -I$(OPENCM3_DIR)/include $(DEFS) -MD
LDFLAGS		+= --static -nostartfiles -Wl,-Map=$(*).map -L$(OPENCM3_DIR)/lib
#LDLIBS		+= -l$(OPENCM3_LIBNAME)
LDLIBS		+= -lc -lgcc #-l$(OPENCM3_LIBNAME)

LDFLAGS += -Wl,-gc-sections
CFLAGS += -ffunction-sections -fdata-sections

all: $(BINARY).elf

.PHONY: clean flash
clean:
	rm -rf $(OBJS) $(OBJS:.o=.d) $(BINARY).elf $(BINARY).map $(GENFILES)

flash_verify: $(BINARY).elf
#	echo "program `pwd`/$(BINARY).elf verify\nreset run\nexit" | nc 127.0.0.1 4444 | sed 1d

flash: $(BINARY).elf
#	echo "program `pwd`/$(BINARY).elf\nreset run\nexit" | nc 127.0.0.1 4444 | sed 1d
	st-util -v0 & echo -e "\ntarget remote localhost:4242\nfile `pwd`/$(BINARY).elf\nload\nquit\n" | arm-none-eabi-gdb --quiet | wait `pgrep arm-none-eabi-gdb`

debug: $(BINARY).elf
#	st-util -v0 & echo -e "\ntarget remote localhost:4242\nfile `pwd`/$(BINARY).elf\nload\nc\n" | arm-none-eabi-gdb

ifeq ($(ENABLE_SEMIHOSTING),1)
  $(info Enabled semihosting)
  LDFLAGS += --specs=rdimon.specs 
  LDLIBS += -lrdimon
  CFLAGS += -DSEMIHOSTING=1
else
  LDLIBS += -lnosys
endif

include $(OPENCM3_DIR)/mk/gcc-rules.mk
include $(OPENCM3_DIR)/mk/genlink-rules.mk
-include $(OBJS:.o=.d)

.PRECIOUS: $(OBJS)
