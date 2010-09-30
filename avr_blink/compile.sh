avr-gcc -g -Os -mmcu=attiny85 -c blink.c
avr-gcc -g -mmcu=attiny85 -o blink.elf blink.o
avr-objcopy -j .text -j .data -O ihex blink.elf blink.hex
avrdude -c usbtiny -p attiny85 -U flash:w:blink.hex
