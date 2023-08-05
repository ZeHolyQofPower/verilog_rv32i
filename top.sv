/*Copyright Adam Gazdecki.
* Licensed under the GNU General Public License v3.0 or later.
* SPDX-License-Identifier: GPL-3.0-or-later
*
* RISC-V
*/
module top (input CLOCK_50,
			input CLOCK2_50,
			input CLOCK3_50,
			output [8:0] LEDG,
			output [17:0] LEDR,
			input [3:0] KEY,
			input [17:0] SW,
			output [6:0] HEX0,
			output [6:0] HEX1,
			output [6:0] HEX2,
			output [6:0] HEX3,
			output [6:0] HEX4,
			output [6:0] HEX5,
			output [6:0] HEX6,
			output [6:0] HEX7
			// Modules on our board
);
//=======================================================
//  CPU Declarations!
//=======================================================
	// Logic wires to connect other modules to the CPU
	logic [0:0] clock;
	logic [0:0] reset_n;
	logic [31:0] gpio_in;
	logic [31:0] gpio_out;
	// Connect to other modules
	// Connections for board usage AND testbench. Testbench pretends to be the board.
	assign clock = CLOCK_50;
	assign reset_n = KEY[0:0];
	assign gpio_in = SW;
	// Instantiate our CPU
	cpu mr_cpu(.clock_i(clock),
			   .reset_ni(reset_n),
			   .gpio_i(gpio_in),
			   .gpio_o(gpio_out));
	//=======================================================
	//  Connect Seven Segment Displays!
	//=======================================================
	// CSR write 0xF00,  rs1,001,rd,    111_0011
	// 1111_0000_0010 0010_0 001 0010_0 111_0011
	// f00            2    1     2    7     3

	// csrrw x20, 0xf02, x3
	// f0219a73 HEX <= x3 (Good and known!)
	// f02 0001_1001_1010_0111_0011
	// f02 00011 001 10100 111_0011

	// Reverse Engineered to write x8
	// f02 01000 001 10100 111_0011
	// f02 0100_0 001 1010_0 111_0011
	// f02 4      1   c      73
	logic [6:0] hex0_o, hex1_o, hex2_o, hex3_o, hex4_o, hex5_o, hex6_o, hex7_o;
	assign HEX0 = hex0_o;
	assign HEX1 = hex1_o;
	assign HEX2 = hex2_o;
	assign HEX3 = hex3_o;
	assign HEX4 = hex4_o;
	assign HEX5 = hex5_o;
	assign HEX6 = hex6_o;
	assign HEX7 = hex7_o;
	hexdriver mr_hex0(.value_in_hex_i(gpio_out[3:0]), .segements_no(hex0_o));
	hexdriver mr_hex1(.value_in_hex_i(gpio_out[7:4]), .segements_no(hex1_o));
	hexdriver mr_hex2(.value_in_hex_i(gpio_out[11:8]), .segements_no(hex2_o));
	hexdriver mr_hex3(.value_in_hex_i(gpio_out[15:12]), .segements_no(hex3_o));
	hexdriver mr_hex4(.value_in_hex_i(gpio_out[19:16]), .segements_no(hex4_o));
	hexdriver mr_hex5(.value_in_hex_i(gpio_out[23:20]), .segements_no(hex5_o));
	hexdriver mr_hex6(.value_in_hex_i(gpio_out[27:24]), .segements_no(hex6_o));
	hexdriver mr_hex7(.value_in_hex_i(gpio_out[31:28]), .segements_no(hex7_o));
//=======================================================
//  REG/WIRE declarations
//=======================================================

	/* 24 bit clock divider, converts 50MHz clock signal to 2.98Hz */
	logic [23:0] clkdiv;
	logic ledclk;
	assign ledclk = clkdiv[23];

	/* driver for LEDs */
	logic [25:0] leds;
	assign LEDR = leds[25:8];
	assign LEDG = leds[7:0];

	/* LED state register, 0 means going left, 1 means going right */
	logic ledstate;


//=======================================================
//  Behavioral coding
//=======================================================

	initial begin
		clkdiv = 26'h0;
		/* start at the far right, LEDG0 */
		leds = 26'b1;
		/* start out going to the left */
		ledstate = 1'b0;
	end

	always @(posedge CLOCK_50) begin
		/* drive the clock divider, every 2^26 cycles of CLOCK_50, the
		* top bit will roll over and give us a clock edge for clkdiv
		* */
		clkdiv <= clkdiv + 1;
	end

	always @(posedge ledclk) begin
		// If reset key is hit, restart state.
		if (~reset_n) begin
			leds = 26'b1;
			ledstate = 1'b0;
		end else begin
			/* going left and we are at the far left, time to turn around */
			if ( (ledstate == 0) && (leds == 26'b10000000000000000000000000) ) begin
				ledstate <= 1;
				leds <= leds >> 1;
			/* going left and not at the far left, keep going */
			end else if (ledstate == 0) begin
				ledstate <= 0;
				leds <= leds << 1;
			/* going right and we are at the far right, turn around */
			end else if ( (ledstate == 1) && (leds == 26'b1) ) begin
				ledstate <= 0;
				leds <= leds << 1;
			/* going right, and we aren't at the far right */
			end else begin
				leds <= leds >> 1;
			end
		end
	end

endmodule
