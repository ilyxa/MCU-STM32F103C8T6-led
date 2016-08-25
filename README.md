# MCU-STM32F103C8T6-led

Arch Linux packages:

community/stlink 1.2.0-2

community/arm-none-eabi-gcc 6.1.1-4

community/arm-none-eabi-gdb 7.11.1-1

# Preparing

git submodule update --init # do not forget this, do not try compile

make -C libopencm3 #-j16

# Making LED blinking

make

make flash

# Making some debug (check opencm3.mk for few details)

st-util -v0 &

arm-none-eabi-gdb # (and target remote localhost:4242 , file led.elf , load , c)
