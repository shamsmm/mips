FILES = $(wildcard src/*.v)

all: visualize

visualize: simulate
	gtkwave test.fst

simulate: compile
	vvp test.vvp -fst

compile: assemble
	iverilog -g2005-sv -otest.vvp test/tb.v $(FILES)

compile-c:
	mips64-linux-gnu-gcc -mmicromips -mabi=32 -S asm/main.c -o test_compiled.s

assemble:
	mips64-linux-gnu-as -O0 -mips32 -mabi=32 asm/test.asm -o test.elf
	mips64-linux-gnu-objcopy -O binary -j .text test.elf irom.bin
	xxd -c 4 -p irom.bin > test/irom.txt

clean:
	rm -f test.vcd test.vpp
