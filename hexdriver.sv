/*Copyright Adam Gazdecki.
* Licensed under the GNU General Public License v3.0 or later.
* SPDX-License-Identifier: GPL-3.0-or-later
*
* RISC-V
*/
module hexdriver (input  logic [3:0] value_in_hex_i, 
                  output logic [6:0] segements_no);
	// Check if input has changed
    always_comb begin
		// Figure out our input number.
		unique case(value_in_hex_i)
			4'h0 : segements_no = 7'b100_0000; // 0 
            4'h1 : segements_no = 7'b111_1001; // 1
            4'h2 : segements_no = 7'b010_0100; // 2 
            4'h3 : segements_no = 7'b011_0000; // 3 
            4'h4 : segements_no = 7'b001_1001; // 4 
            4'h5 : segements_no = 7'b001_0010; // 5 
            4'h6 : segements_no = 7'b000_0010; // 6 
            4'h7 : segements_no = 7'b111_1000; // 7 
            4'h8 : segements_no = 7'b000_0000; // 8 
            4'h9 : segements_no = 7'b001_0000; // 9 
            4'hA : segements_no = 7'b000_1000; // A 
            4'hb : segements_no = 7'b000_0011; // b 
            4'hC : segements_no = 7'b100_0110; // C 
            4'hd : segements_no = 7'b010_0001; // d 
            4'hE : segements_no = 7'b000_0110; // E
            4'hF : segements_no = 7'b000_1110; // F
            default: segements_no = 7'b111_1101; // -
        endcase
    end
endmodule