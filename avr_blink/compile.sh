avr-gcc -g -Os -mmcu=atmega328p -c blink.c
avr-gcc -g -mmcu=atmega328p -o blink.elf blink.o
avr-objcopy -j .text -j .data -O ihex blink.elf blink.hex
avrdude -c usbtiny -p m328p -U flash:w:blink.hex
