CC=gcc

OBJS1=snmpdemoapp.o
OBJS2=example-demon.o IsaSNMPMIB.o
OBJS3=asyncapp.o
TARGETS=IsaSNMPMIB.so

CFLAGS=-I. `net-snmp-config --cflags`

# shared library flags (assumes gcc)
DLFLAGS=-fPIC -shared

all: $(TARGETS)

clean:
	rm $(OBJS2) $(OBJS2) $(TARGETS)

IsaSNMPMIB.so: IsaSNMPMIB.c Makefile
	$(CC) $(CFLAGS) $(DLFLAGS) -c -o IsaSNMPMIB.o IsaSNMPMIB.c
	$(CC) $(CFLAGS) $(DLFLAGS) -o IsaSNMPMIB.so IsaSNMPMIB.o
