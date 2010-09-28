avr-gcc -g -Os -mmcu=attiny13 -c blink.c
avr-gcc -g -mmcu=attiny13 -o blink.elf blink.o
avr-objcopy -j .text -j .data -O ihex blink.elf blink.hex
avrdude -c usbtiny -p attiny13 -U flash:w:blink.hex
