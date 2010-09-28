# this is all library object code stuff
# -c assemble but do not link
# -g include debug stuff
# -Os optimize for size
# -w inhibit all warning messages
# -ffunction-sections and -fdata-sections are for optimization of code location
# -I adds directory to the head of the list to be searched for header files
# -o place the output in file
avr-gcc -c -g -Os -w -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=20 -Iarduino arduino/pins_arduino.c -obuild/pins_arduino.c.o
avr-gcc -c -g -Os -w -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=20 -Iarduino arduino/WInterrupts.c -obuild/WInterrupts.c.o
avr-gcc -c -g -Os -w -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=20 -Iarduino arduino/wiring.c -obuild/wiring.c.o
avr-gcc -c -g -Os -w -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=20 -Iarduino arduino/wiring_analog.c -obuild/wiring_analog.c.o
avr-gcc -c -g -Os -w -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=20 -Iarduino arduino/wiring_digital.c -obuild/wiring_digital.c.o
avr-gcc -c -g -Os -w -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=20 -Iarduino arduino/wiring_pulse.c -obuild/wiring_pulse.c.o
avr-gcc -c -g -Os -w -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=20 -Iarduino arduino/wiring_shift.c -obuild/wiring_shift.c.o
avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=20 -Iarduino arduino/HardwareSerial.cpp -obuild/HardwareSerial.cpp.o
avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=20 -Iarduino arduino/main.cpp -obuild/main.cpp.o
avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=20 -Iarduino arduino/Print.cpp -obuild/Print.cpp.o
avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=20 -Iarduino arduino/Tone.cpp -obuild/Tone.cpp.o
avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=20 -Iarduino arduino/WMath.cpp -obuild/WMath.cpp.o
avr-g++ -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=20 -Iarduino arduino/WString.cpp -obuild/WString.cpp.o
avr-ar rcs build/core.a build/pins_arduino.c.o
avr-ar rcs build/core.a build/WInterrupts.c.o
avr-ar rcs build/core.a build/wiring.c.o
avr-ar rcs build/core.a build/wiring_analog.c.o
avr-ar rcs build/core.a build/wiring_digital.c.o
avr-ar rcs build/core.a build/wiring_pulse.c.o
avr-ar rcs build/core.a build/wiring_shift.c.o
avr-ar rcs build/core.a build/HardwareSerial.cpp.o
avr-ar rcs build/core.a build/main.cpp.o
avr-ar rcs build/core.a build/Print.cpp.o
avr-ar rcs build/core.a build/Tone.cpp.o
avr-ar rcs build/core.a build/WMath.cpp.o
avr-ar rcs build/core.a build/WString.cpp.o

# now for my code
# -L is where to look for the libraries specified by -l
# -l search this library when linking
avr-gcc -c -g -Os -w -fno-exceptions -ffunction-sections -fdata-sections -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=20 -Iarduino blink.c -obuild/blink.o
# it doesn't look like we need the -L and -l options in this case
#avr-gcc -Os -Wl,--gc-sections -mmcu=atmega328p -o build/blink.elf build/blink.o build/core.a -Lbuild -lm
avr-gcc -Os -Wl,--gc-sections -mmcu=atmega328p -o build/blink.elf build/blink.o build/core.a
avr-objcopy -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 build/blink.elf build/blink.eep
avr-objcopy -O ihex -R .eeprom build/blink.elf build/blink.hex

# flash the chip
#avrdude -patmega328p -cusbtiny -Uflash:w:build/blink.hex