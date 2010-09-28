avr-gcc -Os -mmcu=atmega328p -DF_CPU=16000000L -c main.c -o main.o
avr-gcc -Os -mmcu=atmega328p -DF_CPU=16000000L -c soto.c -o soto.o
avr-gcc -Os -mmcu=atmega328p main.o soto.o -o main.elf
avr-objcopy -O ihex main.elf main.hex
avrdude -patmega328p -cusbtiny -Uflash:w:main.hex
