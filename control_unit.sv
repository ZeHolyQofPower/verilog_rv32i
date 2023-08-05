/*Copyright Adam Gazdecki.
* Licensed under the GNU General Public License v3.0 or later.
* SPDX-License-Identifier: GPL-3.0-or-later
*
* RISC-V
*/
// This module is purely a combinational LUT.
// Input: opcode, funct3, funct7, cst
// Output: 5 different control signals.
module control_unit(input logic [6:0] opcode_i,
                    input logic [2:0] funct3_i,
                    input logic [6:0] funct7_i,
                    input logic [11:0] cssrw_i,
                    output logic [0:0] alusrc_o_EX, // 1 bit signal.
                    output logic [0:0] gpio_writeenable_o,
                    output logic [0:0] regwrite_o_EX,
                    output logic [2:0] regsel_o_EX,
                    output logic [3:0] aluop_o_EX,
                    output logic [0:0] stall_o,
                    input logic [0:0] stall_i,
                    output logic [2:0] pcsrc_o,
                    input logic [31:0] aluoutput_r_i);
    always_comb begin
        // Default control signal values
        alusrc_o_EX = 1'bx;
        gpio_writeenable_o = 1'b0;
        regwrite_o_EX = 1'b0;
        regsel_o_EX = 3'bx;
        aluop_o_EX = 4'bx;
        stall_o = 1'b0;
        pcsrc_o = 3'b000;
        /* R-type Instructions */
        if (opcode_i == 7'b011_0011) begin
            regsel_o_EX = 3'b010;
            stall_o = 1'b0;
            pcsrc_o = 3'b000;
            if (funct3_i == 3'b000 && funct7_i == 7'b000_0000) begin // add
                alusrc_o_EX = 1'b0;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b0011;
            end else if (funct3_i == 3'b000 && funct7_i == 7'b010_0000) begin //sub
                alusrc_o_EX = 1'b0;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b0100;
            end else if (funct3_i == 3'b000 && funct7_i == 7'b000_0001) begin //mul
                alusrc_o_EX = 1'b0;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b0101;
            end else if (funct3_i == 3'b001 && funct7_i == 7'b000_0001) begin //mulh
                alusrc_o_EX = 1'b0;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b0110;
            end else if (funct3_i == 3'b011 && funct7_i == 7'b000_0001) begin //mulhu
                alusrc_o_EX = 1'b0;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b0111;
            end else if (funct3_i == 3'b010 && funct7_i == 7'b000_0000) begin //slt
                alusrc_o_EX = 1'b0;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b1100;
            end else if (funct3_i == 3'b011 && funct7_i == 7'b000_0000) begin //sltu
                alusrc_o_EX = 1'b0;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b1110;
            end else if (funct3_i == 3'b111 && funct7_i == 7'b000_0000) begin //and
                alusrc_o_EX = 1'b0;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b0000;
            end else if (funct3_i == 3'b110 && funct7_i == 7'b000_0000) begin //or
                alusrc_o_EX = 1'b0;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b0001;
            end else if (funct3_i == 3'b100 && funct7_i == 7'b000_0000) begin //xor
                alusrc_o_EX = 1'b0;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b0010;
            end else if (funct3_i == 3'b001 && funct7_i == 7'b000_0000) begin //sll
                alusrc_o_EX = 1'b0;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b1000;
            end else if (funct3_i == 3'b101 && funct7_i == 7'b000_0000) begin //srl
                alusrc_o_EX = 1'b0;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b1001;
            end else if (funct3_i == 3'b101 && funct7_i == 7'b010_0000) begin //sra
                alusrc_o_EX = 1'b0;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b1010; // What is this instruction? Shift Right by Amount (reg) //
            end else begin // Error
                // Intentionally Empty
            end
        /* I-Type Instructions */
        end else if (opcode_i == 7'b001_0011) begin
            stall_o = 1'b0;
            pcsrc_o = 3'b000;
            regsel_o_EX = 3'b010;   // Copy-Pasta error.
            if (funct3_i == 3'b000) begin // addi
                alusrc_o_EX = 1'b1;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b0011;
            end else if (funct3_i == 3'b111) begin // andi
                alusrc_o_EX = 1'b1;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b0000;
            end else if (funct3_i == 3'b110) begin // ori
                alusrc_o_EX = 1'b1;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b0001;
            end else if (funct3_i == 3'b100) begin // xori
                alusrc_o_EX = 1'b1;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b0010;
            end else if (funct3_i == 3'b001 && funct7_i == 7'b000_0000) begin // slli
                alusrc_o_EX = 1'b1;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b1000;
            end else if (funct3_i == 3'b101 && funct7_i == 7'b000_0000) begin // srai
                alusrc_o_EX = 1'b1;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b1001;
            end else if (funct3_i == 3'b101 && funct7_i == 7'b010_0000) begin // srli
                alusrc_o_EX = 1'b1;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'b1010;           // Error
            end else begin // Error
                // Intentionally Empty
            end
        /* U-Type Instructions */
        end else if (opcode_i == 7'b011_0111) begin
            alusrc_o_EX = 1'bx;
            gpio_writeenable_o = 1'b0;
            regwrite_o_EX = 1'b1;
            regsel_o_EX = 3'b011;
            aluop_o_EX = 4'bx;
            stall_o = 1'b0;
            pcsrc_o = 3'b000;
        /* CSSRRW-type Instructions */
        end else if (opcode_i == 7'b111_0011) begin
            stall_o = 1'b0;
            pcsrc_o = 3'b000;
            if (cssrw_i == 12'hf02 && funct3_i == 3'b001) begin //csrrw write to displays
                regsel_o_EX = 3'bx;
                alusrc_o_EX = 1'bx;
                gpio_writeenable_o = 1'b1;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'bx;
            end else if (cssrw_i == 12'hf00 && funct3_i == 3'b001) begin //csrrw read from switches
                regsel_o_EX = 3'b000;
                alusrc_o_EX = 1'bx;
                gpio_writeenable_o = 1'b0;
                regwrite_o_EX = 1'b1;
                aluop_o_EX = 4'bx;
            end else begin // Error
                // Intentionally Empty
            end
        /* B-type Instructions */
        end else if (opcode_i == 7'b110_0011) begin
            alusrc_o_EX = 1'b0;
            gpio_writeenable_o = 1'b0;
            regwrite_o_EX = 1'b0;
            regsel_o_EX = 3'b100;
            pcsrc_o = 3'b100; // Hold ur horses, I want that instruction back!
            stall_o = 1'b1; // Also make sure there's no funny business.
            if (funct3_i == 3'b000) begin // beq
                aluop_o_EX = 4'b0100; // sub
            end else if (funct3_i == 3'b001) begin // bne
                aluop_o_EX = 4'b0100; // sub
            end else if (funct3_i == 3'b100) begin // blt
                aluop_o_EX = 4'b1100; // slt
            end else if (funct3_i == 3'b110) begin // bltu
                aluop_o_EX = 4'b1110; // sltu
            end else if (funct3_i == 3'b101) begin // bge
                aluop_o_EX = 4'b1100; // slt
            end else if (funct3_i == 3'b111) begin // bgeu
                aluop_o_EX = 4'b1110; // sltu
            end else begin // Error
                // Intentionally Empty
            end
        /* J-type Instructions */
        end else if (opcode_i == 7'b110_1111) begin // jal
            alusrc_o_EX = 1'bx;
            gpio_writeenable_o = 1'b0;
            regwrite_o_EX = 1'b1;
            regsel_o_EX = 3'b100;
            stall_o = 1'b0;
            pcsrc_o = 3'b010;
            aluop_o_EX = 4'bx;
        end else if (opcode_i == 7'b110_0111) begin // jalr
            alusrc_o_EX = 1'bx; // Hardwired in addition, no ALU needed.
            gpio_writeenable_o = 1'b0;
            regwrite_o_EX = 1'b0;
            regsel_o_EX = 3'b100;
            stall_o = 1'b0;
            pcsrc_o = 3'b011;
            aluop_o_EX = 4'bx;
        /* Error-Type Instructions */
        end else begin
            // Do nothing for default values
        end

        /* Stall Processor Override */
        if (stall_i == 1'b1) begin
            // TODO maybe you're evaluating it wrong? Don't overwrite what the branch wants to do.
            // SO. you stalled this instruction eh?
            //alusrc_o_EX = 1'bx; // TODO ?
            gpio_writeenable_o = 1'b0;
            regwrite_o_EX = 1'b0;
            regsel_o_EX = 3'b010; // ALU. Warning from Lily
            //aluop_o_EX = 4'bx; // I do care for branch calc
            pcsrc_o = 3'b100;
            /* Branch Resolve */
            if (funct3_i == 3'b000) begin // beq
                if (aluoutput_r_i == 32'b0000_0000_0000_0000_0000_0000_0000_0000) // I'll take it!
                    pcsrc_o = 3'b001;
                else // Naw...
                    pcsrc_o = 3'b000;
            end else if (funct3_i == 3'b001) begin // bne
                if (aluoutput_r_i != 32'b0000_0000_0000_0000_0000_0000_0000_0000)
                    pcsrc_o = 3'b001;
                else
                    pcsrc_o = 3'b000;
            end else if (funct3_i == 3'b100) begin // blt
                if (aluoutput_r_i == 32'b0000_0000_0000_0000_0000_0000_0000_0001)
                    pcsrc_o = 3'b001;
                else
                    pcsrc_o = 3'b000;
            end else if (funct3_i == 3'b110) begin // bltu
                if (aluoutput_r_i == 32'b0000_0000_0000_0000_0000_0000_0000_0001)
                    pcsrc_o = 3'b001;
                else
                    pcsrc_o = 3'b000;
            end else if (funct3_i == 3'b101) begin // bge
                if (aluoutput_r_i == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
                    pcsrc_o = 3'b001;
                else
                    pcsrc_o = 3'b000;
            end else if (funct3_i == 3'b111) begin // bgeu
                if (aluoutput_r_i == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
                    pcsrc_o = 3'b001;
                else
                    pcsrc_o = 3'b000;
            end else begin // Error
                // Intentionally Empty
            end
            stall_o = 1'b0;
        end
    end
endmodule