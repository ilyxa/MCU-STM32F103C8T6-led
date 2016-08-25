BINARY := led
OBJS += led.o
CFLAGS += -std=gnu99 -O3 -Wall -I. -Werror
CFLAGS += -ggdb3

include opencm3.mk
