/*Copyright Adam Gazdecki.
* Licensed under the GNU General Public License v3.0 or later.
* SPDX-License-Identifier: GPL-3.0-or-later
*
* RISC-V
*/
/* Top-level module for running under simulation or testbenching.  In
 * this case, the I/Os and clock are driven by the simulator. */
module simtop;
	// QuestaSim has UVM integration out of the box!
	//import uvm_pkg::*;
	// Warning, do not wildcard import into root scope. You may get namespace collisions!
	// TODO, figure out a good way to avoid this issue.

	// Only simulation clock
	// Designs with multiple clocks use UVM generator modules.
	//always #5 clk = ~clk;
	logic [0:0] clk;
	always begin
		#5 clk = 1'b1;
		#5 clk = 1'b0;
	end
	// TODO, Figure out why the zero register hates this commented out one-liner clock?
	// I spent some time fidling with initializing it on high instead of low but that's not it.
	// EH. Don't break what's not causing current bugs.

	// UVM library's interface
	//dut_if mr_dut_if(clk);
	//dut_wrapper mr_dut_wr(._if(mr_dut_if));

	// At the very start of the simulation.
	/*
	initial begin
		// Connect the uvm interface you just made and the uvm config database.
		uvm_config_db #(virtual dut_if)::set (null, "uvm_test_top", "dut_if", mr_dut_if);
		// Run the set of tests by name.
		run_test ("mr_test_name");
	end
	*/

	// Logic wires that inputs into our modules
	//logic [0:0] clk;
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

	initial begin
		$display("=====Begin Testbench() Console Output=====");
		// Make sure reset is off
		SW = 18'b0000_0000_0000_0001_00;
		KEY[0:0] = 1'b0;
		#10
		KEY[0:0] = 1'b1;
		// clk = 1'b1;

		/* Test Instruction Memory loaded correctly */
		$display("=====End testbench() Console Output=====");
	end
	
endmodule