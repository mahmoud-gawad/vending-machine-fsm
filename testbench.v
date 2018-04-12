`timescale 1ns / 1ns

module testbench();

	reg		clk;
	reg		reset;
	reg		one_in, half_in;

	wire	can_out, change_out;

	// instantiate device to be tested
	vendingMachine dut (can_out, change_out, clk, reset, one_in, half_in);

	// generate clock to sequence tests
	always
		begin
			clk <= 1; # 50; clk <= 0; # 50;
		end

	// initialize test
	initial
		begin
			one_in <= 0; half_in <= 0;
			reset <= 1; # 120; reset <= 0;
			# 80; one_in <= 1;
			# 300; one_in <= 0; half_in <= 1;
			# 300; half_in <= 0; one_in <= 1;
			# 50; one_in <= 0; half_in <= 1;
			# 50; half_in <= 0;
			# 200; half_in <= 1;
			# 50; half_in <= 0; one_in <= 1;
			# 50; one_in <= 0;
			# 200; half_in <= 1;
			# 100; half_in <= 0; one_in <= 1;
			# 200; half_in <=0; one_in <= 0;
		end

endmodule
