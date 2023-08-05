/*Copyright Adam Gazdecki.
* Licensed under the GNU General Public License v3.0 or later.
* SPDX-License-Identifier: GPL-3.0-or-later
*
* RISC-V
*/
/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */
module simtop;

	logic clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [17:0] SW;
	logic [31:0] GPIO_IN;
	logic [31:0] GPIO_OUT;
	logic [3:0] KEY;
	// Logic wire that inputs into our module
	/*
	logic [31:0] INSTRUCTION_DUMP[8191:0];
	logic [31:0] REGISTER_DUMP[31:0];
	logic [3:0] RESET_IN_N;
	*/
	top dut
	(
		//////////// CLOCK //////////
		.CLOCK_50(clk),
		.CLOCK2_50(),
	    .CLOCK3_50(),

		//////////// LED //////////
		.LEDG(),
		.LEDR(),

		//////////// KEY //////////
		.KEY(KEY),

		//////////// SW //////////
		.SW(SW),

		//////////// SEG7 //////////
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.HEX6(HEX6),
		.HEX7(HEX7)
		// Module on our board takes input from this logic.
	);
	/* We gotta make a clock */
	always begin
		#5 clk = 1'b1;
		#5 clk = 1'b0;
	end
	/* Self Checking Testbench */
	/*
	integer i;
	integer j;
	*/
	// initial begin
	// @(regwrite);
	// if (writeaddr -= 5'd5 || writedata -= 32'd17) $display ("error!");
	initial begin
		$display("=====Begin testbench() Console Output=====");
		// Make sure reset is off
		SW = 18'b0000_0000_0000_0001_00;
		KEY[0:0] = 1'b0;
		#10
		KEY[0:0] = 1'b1;
		//dut.mr_cpu.program_counter_FCH = -1;
		/* Test Instruction Memory loaded correctly */
		//$display("0x%0x", INSTRUCTION_DUMP[12'b0000_0000_0000]);
		// add x3, x1, x2 = 0x0000001D That's what is in "instmem.dat" rn
		/*
		// Loop through the registers you're interested in. 12-bit addresses
		for (j=12'h0000_0000; j<=12'h0000_000c; j=j+12'h0000_000c) begin
			$display("Address At: 0b%0b", j);
			// Output 32-bit register bit by bit.
			for (i=32'h0000_0000; i<32'h0000_0008; i=i+32'h0000_0020) begin
				// Look. the display function is torturing me.
				$display("0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b%0b", GPIO_OUT[j+i], GPIO_OUT[j+i+1], GPIO_OUT[j+i+2], GPIO_OUT[j+i+3], GPIO_OUT[j+i+4], GPIO_OUT[j+i+5], GPIO_OUT[j+i+6], GPIO_OUT[j+i+7], GPIO_OUT[j+i+8], GPIO_OUT[j+i+9], GPIO_OUT[j+i+10], GPIO_OUT[j+i+11], GPIO_OUT[j+i+12], GPIO_OUT[j+i+13], GPIO_OUT[j+i+14], GPIO_OUT[j+i+15], GPIO_OUT[j+i+16], GPIO_OUT[j+i+17], GPIO_OUT[j+i+18], GPIO_OUT[j+i+19], GPIO_OUT[j+i+20], GPIO_OUT[j+i+21], GPIO_OUT[j+i+22], GPIO_OUT[j+i+23], GPIO_OUT[j+i+24], GPIO_OUT[j+i+25], GPIO_OUT[j+i+26], GPIO_OUT[j+i+27], GPIO_OUT[j+i+28], GPIO_OUT[j+i+29], GPIO_OUT[j+i+30], GPIO_OUT[j+i+31]);
			end
		end
		*/
		/*
		for (i=12'h000; i<12'h008; i=i+12'h001) begin
			// Look. the display function is torturing me.
			$display("0x%0x", GPIO_OUT);
		end
		*/
		/*
		$display("0x%0x", SW);
		$display("=====End testbench() Console Output=====");
		*/
	end
endmodule