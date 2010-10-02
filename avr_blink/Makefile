MCU = attiny13
MCU = attiny85
PROJECT = blink

# convert to hex file
$(PROJECT).hex: $(PROJECT).elf
	avr-objcopy -O ihex $(PROJECT).elf $(PROJECT).hex

# link libraries and startup code
$(PROJECT).elf: $(PROJECT).o
	avr-gcc -g -mmcu=$(MCU) -o $(PROJECT).elf $(PROJECT).o

# compile but do not yet link (-c supresses linking)
$(PROJECT).o: $(PROJECT).c
	avr-gcc -c -g -Os -mmcu=$(MCU) -o $(PROJECT).o $(PROJECT).c

# program the flash memory
program:$(PROJECT).hex
	avrdude -c usbtiny -p $(MCU) -U flash:w:$(PROJECT).hex

clean:
	-rm *.o
	-rm *.hex
	-rm *.elf
