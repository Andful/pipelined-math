#TODO add subtractor
all: adder_tb delay_tb multiplier_tb shifter_tb mask_tb

clean:
	rm traces/*.vcd sim/*.vvp

%_tb:
	iverilog -g2012 -osim/$@.vvp -s $@ src/* test/$@.sv
