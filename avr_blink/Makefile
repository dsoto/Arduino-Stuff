MCU = attiny13
MCU = attiny85
PROJECT = blink

$(PROJECT).hex: $(PROJECT).elf
	avr-objcopy -O ihex $(PROJECT).elf $(PROJECT).hex

$(PROJECT).elf: $(PROJECT).o
	avr-gcc -g -mmcu=$(MCU) -o $(PROJECT).elf $(PROJECT).o

$(PROJECT).o: $(PROJECT).c
	avr-gcc -g -Os -mmcu=$(MCU) -c $(PROJECT).c





program:$(PROJECT).hex
	avrdude -c usbtiny -p $(MCU) -U flash:w:$(PROJECT).hex

clean:
	rm *.o
	rm *.hex
	rm *.elf
