FILES = $(wildcard src/*.v)

all: visualize

visualize: simulate
	gtkwave test.fst

simulate: compile
	vvp test.vvp -fst

compile:
	iverilog -otest.vvp test/tb.v $(FILES)

clean:
	rm -f test.vcd test.vpp