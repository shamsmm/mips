FILES = $(wildcard src/*.v)

all: visualize

visualize: simulate
	gtkwave test.fst

simulate: compile
	vvp test.vvp -fst

compile: assemble
	iverilog -g2005-sv -otest.vvp test/tb.v $(FILES)

# GCC uses too many extra features, needs quite time to implement them
compile-c:
	mips64-linux-gnu-gcc -mips32 -mabi=32 -S test/main.c -o test_compiled.s

assemble:
	mips64-linux-gnu-as -O0 -mips32 -mabi=32 test/test.asm -o test.elf
	mips64-linux-gnu-objcopy -O binary -j .text test.elf irom.bin
	xxd -c 4 -p irom.bin > test/irom.txt

clean:
	rm -f test.fst test.vvp test.elf irom.bin
