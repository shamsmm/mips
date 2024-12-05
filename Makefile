FILES = $(wildcard *.v)

all: visualize

visualize: simulate
	gtkwave test.vcd

simulate: compile
	vvp test.vvp -vcd

compile:
	iverilog -otest.vvp $(FILES)

clean:
	rm -f test.vcd test.vpp