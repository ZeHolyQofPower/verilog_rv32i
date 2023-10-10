/*Copyright Adam Gazdecki.
* Licensed under the GNU General Public License v3.0 or later.
* SPDX-License-Identifier: GPL-3.0-or-later
*
* RISC-V
*/
/* Top-level module for running under simulation or manual testbenching.  In
 * this case, the I/Os and clock are driven by the simulator. */
module simtop;
	// Logic wires that inputs into our modules
	logic [0:0] clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [17:0] SW;
	logic [31:0] GPIO_IN;
	logic [31:0] GPIO_OUT;
	logic [3:0] KEY;

	top dut
	(
		// Modules on our board with inputs accept here.
		// CLOCK
		.CLOCK_50(clk),
		.CLOCK2_50(),
	    .CLOCK3_50(),
		// LED
		.LEDG(),
		.LEDR(),
		// KEY
		.KEY(KEY),
		// SW
		.SW(SW),
		// SEG7
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.HEX6(HEX6),
		.HEX7(HEX7)
	);
	/* Only simulation clock */
	//always #5 clk = ~clk;
	always begin
		#5 clk = 1'b1;
		#5 clk = 1'b0;
	end
	// TODO, Figure out why the zero register hates this commented out one-liner clock?
	// I spent some time fidling with initializing it on high instead of low but that's not it.
	// EH. Don't break what's not causing current bugs.

	/* Testbench */
	initial begin
		$display("=====Begin simtop Verilog Testbench Console Output=====");
		// Make sure reset is off
		SW = 18'b0000_0000_0000_0001_00;
		KEY[0:0] = 1'b0;
		#10	// TODO this delay seems to be messing with our startup sequence if changed...
		KEY[0:0] = 1'b1;
		// clk = 1'b1;

		/* Test Instruction Memory loaded correctly */
		$display("=====End simtop Verilog TestbenchConsole Output=====");
	end
	
endmodule