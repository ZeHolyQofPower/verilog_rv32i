/*Copyright Adam Gazdecki.
* Licensed under the GNU General Public License v3.0 or later.
* SPDX-License-Identifier: GPL-3.0-or-later
*
* RISC-V
*/
// Input:32 bits This module is combinational
module decoder (input logic [31:0] instruction_i,
                // All R-type parts
                output logic [6:0] opcode_o,
                output logic [4:0] rd_o,
                output logic [2:0] funct3_o,
                output logic [4:0] rs1_o,
                output logic [4:0] rs2_o,
                output logic [6:0] funct7_o,
                // I-type immediate
                output logic [11:0] immediate12_o,
                // U-type immediate
                output logic [19:0] immediate20_o,
                // B-type offset
                output logic [12:0] branch_offset_o,    // 13 bit offset
                // J-type offsets
                output logic [13:0] jal_offset_o,   // 14 bit offset
                output logic [31:0] jalr_offset_o); // 32 bits cause added to address
    assign opcode_o = instruction_i[6:0];
    assign rd_o = instruction_i[11:7];
    assign funct3_o = instruction_i[14:12];
    assign rs1_o = instruction_i[19:15];
    assign rs2_o = instruction_i[24:20];
    assign funct7_o = instruction_i[31:25];
    // I-type immediate
    assign immediate12_o = instruction_i[31:20];
    // U-type immediate
    assign immediate20_o = instruction_i[31:12];
    // B-type offset
    assign branch_offset_o = {instruction_i[31], instruction_i[7], instruction_i[30:25], instruction_i[11:8], 1'b0};
    // jal offset. An offset has the correct width to bee simply added to the address or pointer.
    /*
    logic [13:0] jal_immediate;
    assign jal_immediate = {instruction_i[31],instruction_i[19:12],instruction_i[20],instruction_i[30:21],1'b0};
    assign jal_offset_o = jal_immediate[13:2];
    */
    assign jal_offset_o = {instruction_i[31],instruction_i[19:12],instruction_i[20],instruction_i[30:21],1'b0};
    // jalr offset
    /*
    logic [11:0] jalr_immediate;
    assign jalr_immediate = instruction_i[31:20];
    assign jalr_offset_o ={{2{jalr_immediate[11]}},jalr_immediate[11:2]};
    */
    assign jalr_offset_o = instruction_i[31:20];
endmodule