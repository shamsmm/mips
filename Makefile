FILES = $(wildcard src/*.v)

all: visualize

visualize: simulate
	gtkwave test.fst

simulate: compile
	vvp test.vvp -fst

compile:
	iverilog -otest.vvp test/tb.v $(FILES)

assemble:
	mips64-linux-gnu-as -mips32 -mabi=32 asm/test.asm -o test.elf
	mips64-linux-gnu-objcopy -O binary -j .text test.elf irom.bin
	xxd -c 4 -p irom.bin > test/irom.txt

clean:
	rm -f test.vcd test.vpp