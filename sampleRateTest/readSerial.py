import serial

s = serial.Serial('/dev/tty.usbserial-A6008m4d',baudrate=115200,timeout=2)
s.write('a')
lines = s.readlines()

samples = []
for line in lines:
    line.strip()
    val = line.split(',')[0]
    #print val
    samples.append(val)
    
    
import numpy as np

#print samples
samples = np.array(samples, dtype=int)
samples = samples - samples[0]
print samples
import matplotlib.pyplot as plt

plt.close()
plt.plot(samples)
plt.show()

    
