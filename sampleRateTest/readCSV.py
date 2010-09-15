import serial

#s = open('SD analog read.CSV','r')
s = open('SD digital read.CSV','r')
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
plt.plot(samples,label='data')
plt.plot([0,100],[0,100*1000],label='1 kHz')
plt.plot([0,100],[0,100*10000],label='100 Hz')
plt.xlabel('sample number')
plt.ylabel('time (usec)')
plt.legend()
plt.show()

    
