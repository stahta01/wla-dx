
CC = $(WLAVALGRIND) wla-z80
CFLAGS = -D TEST_STRING="S>HELLO<S" -i -o
LD = $(WLAVALGRIND) wlalink
LDFLAGS = -v -s -i

SFILES = setup.s main.s lib.s
IFILES = defines.i
OFILES = main.o setup.o lib.o

all: $(OFILES) makefile
	$(LD) $(LDFLAGS) linkfile linked.prg

main.o: main.s defines.i
	$(CC) $(CFLAGS) main.o main.s

setup.o: setup.s defines.i
	$(CC) $(CFLAGS) setup.o setup.s

lib.o: lib.s
	wla-z80 -i -v -s -l lib.o lib.s


$(OFILES): $(HFILES)


clean:
	rm -f $(OFILES) core *~ linked.prg linked.sym *.lst
