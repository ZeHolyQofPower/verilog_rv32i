/*Copyright Adam Gazdecki.
* Licensed under the GNU General Public License v3.0 or later.
* SPDX-License-Identifier: GPL-3.0-or-later
*
* RISC-V
*/
// Input: clock, reset signal, 32 bit general purpose io register
// Output: 32 bit general purpose io register
// All pipelining and clocking will be done here.
module cpu (input logic clock_i,
            input logic reset_ni,
            input logic [31:0] gpio_i,
            output logic [31:0] gpio_o);
    /* Create and Load into Instruction Memory */
    logic [31:0] instruction_memory[2048:0];
    logic [12:0] address;
    logic [31:0] readdata, writedata;
    logic [0:0] write_enable;
    assign write_enable = 1'b1;
    assign address = 12'b0000_0000_0000;
    initial $readmemh("instmem.dat", instruction_memory);
    //initial $readmemh("branch_and_jump.dat", instruction_memory);
    //initial $readmemh("bin2dec2.dat", instruction_memory);
    //initial $readmemh("sqrt2.dat", instruction_memory);
    always_ff @(posedge clock_i) begin
        if (write_enable) instruction_memory[address] <= writedata;
            readdata <= instruction_memory[address];
    end
    /* Decode Instruction */
    // Logic wires to connect decoder to rest of board.
	logic [31:0] instruction;
	logic [6:0] opcode;
	logic [4:0] rd_EX;
	logic [2:0] funct3;
	logic [4:0] rs1;
	logic [4:0] rs2;
	logic [6:0] funct7;
	logic [11:0] immediate12_EX;
	logic [19:0] immediate20_EX;
	logic [1:0] instruction_type;
    logic [12:0] branch_offset_EX;
    logic [13:0] jal_offset_EX;
    logic [31:0] jalr_offset_EX;
	// Instantiate Our Decoder
	decoder mr_decoder(.instruction_i(instruction),
					   .opcode_o(opcode),
					   .rd_o(rd_EX),
					   .funct3_o(funct3),
					   .rs1_o(rs1),
					   .rs2_o(rs2),
					   .funct7_o(funct7),
				 	   .immediate12_o(immediate12_EX),
					   .immediate20_o(immediate20_EX),
                       .branch_offset_o(branch_offset_EX),
                       .jal_offset_o(jal_offset_EX),
                       .jalr_offset_o(jalr_offset_EX));
	// Connect outputs to the other modules

    /* Control Signals */
    // Logic wires to connect control unit to rest of board.
    logic [11:0] cssrw;
    logic [0:0] alusrc_EX;
    logic [0:0] gpio_writeenable;
    logic [0:0] regwrite_EX;
    logic [2:0] regsel_EX;
    logic [3:0] aluop_EX;
    logic [0:0] stall_FCH;
    logic [0:0] stall_EX;
    logic [2:0] pcsrc_EX;
    logic [31:0] aluoutput_r_EX; // ALU's Output. Sorry it's out of place.
    // Instantiate our control unit
    control_unit mr_control_unit(.opcode_i(opcode),
                                 .funct3_i(funct3),
                                 .funct7_i(funct7),
                                 .cssrw_i(cssrw),
                                 .alusrc_o_EX(alusrc_EX),
                                 .gpio_writeenable_o(gpio_writeenable),
                                 .regwrite_o_EX(regwrite_EX),
                                 .regsel_o_EX(regsel_EX),
                                 .aluop_o_EX(aluop_EX),
                                 .stall_o(stall_FCH),
                                 .stall_i(stall_EX),
                                 .pcsrc_o(pcsrc_EX),
                                 .aluoutput_r_i(aluoutput_r_EX));
    // Connect outputs to the other modules
    assign cssrw = immediate12_EX;
    // Delay stall to EX
    always_ff @(posedge clock_i) begin
        stall_EX = stall_FCH;
    end
    
    /* Register File */
    // Logic wires to connect registers to rest of board.
    logic [31:0] readdata1;
    logic [31:0] readdata2;
    logic [31:0] register_dump;
    // Delay writeaddr from decoder to wb stage
    logic [4:0] rd_WB;
    always_ff @(posedge clock_i) begin
        rd_WB = rd_EX;
    end
    // Delay write enable to wb stage
    logic [0:0] regwrite_WB;
    always_ff @(posedge clock_i) begin
        regwrite_WB = regwrite_EX;
    end
        /* Register Subsection Four Delays and Mux into writedata */
        // Delay gpio_in to WB
        logic [31:0] gpio_i_WB;
        always_ff @(posedge clock_i) begin
          gpio_i_WB = gpio_i;
        end
        // Delay regsel to WB
        logic [2:0] regsel_WB;
        always_ff @(posedge clock_i) begin
            regsel_WB = regsel_EX;
        end
        // Delay immediate12 to WB
        logic [31:0] immediate12_WB;
        always_ff @(posedge clock_i) begin
            immediate12_WB = immediate12_EX;
        end
        // Delay aluoutput_r to WB
        logic [31:0] aluoutput_r_WB;
        always_ff @(posedge clock_i) begin
            aluoutput_r_WB = aluoutput_r_EX;
        end
        // Delay immediate20 to WB
        logic [31:0] immediate20_WB;
        always_ff @(posedge clock_i) begin
          //immediate20_WB = { {12{immediate20_EX[19]}}, immediate20_EX}; // Sign Extend
          immediate20_WB = {immediate20_EX, {12'b0000_0000_0000}}; // Shove in upper half
        end
        // 5-1 Mux for GPIO || 12bit immediate || ALU into writedata_WB || LUI 20bit imm || program counter
        logic [31:0] writedata_WB;
        logic [11:0] program_counter_FCH = 12'b0000_0000_0000;
        always_comb begin
            unique case (regsel_WB)
                3'b000: writedata_WB = gpio_i_WB;
                3'b001: writedata_WB = immediate12_WB;
                3'b010: writedata_WB = aluoutput_r_WB;
                3'b011: writedata_WB = immediate20_WB;
                3'b100: writedata_WB = program_counter_FCH;
                default: writedata_WB = 3'b11;
            endcase
        end
        /* End Subsection and Continue Registers */
    // Instantiate our registers.
    regfile mr_registers(.clk(clock_i),
                         .rst(reset_ni),
                         .we(regwrite_WB),
                         .readaddr1(rs1),
                         .readaddr2(rs2),
                         .writeaddr(rd_WB),
                         .writedata(writedata_WB), // regsel_wb mux
                         .readdata1(readdata1),
                         .readdata2(readdata2));
    // Connect outputs to all the other modules.
    always_ff @(posedge clock_i) begin
        if (gpio_writeenable)
            gpio_o = readdata1;
    end
    /* ALU Operation */
    // Logic wires to connect ALU to the rest of board.
    logic [31:0] b;
    logic [0:0] zero_flag;
    // 2-1 Mux for readdata2 || sign-extender into ALU B
    always_comb begin
        unique case (alusrc_EX)
            1'b0: b = readdata2;
            1'b1: b = { {20{immediate12_EX[11]}}, immediate12_EX};
            default: b = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        endcase
    end
    // Instantiate our ALU.
    alu mr_alu(.A(readdata1),
               .B(b), // alusrc mux
               .op(aluop_EX),
               .R(aluoutput_r_EX), // defined under Control Unit section
               .zero(zero_flag));
    // Connect outputs to other modules.

    /* Next Program Counter */
    //logic [11:0] program_counter_FCH = 12'b0000_0000_0000; // Defined above redsel_WB mux
    logic [11:0] program_counter_EX = 12'b0000_0000_0000;
    // 5-1 Mux for next program_counter
    always_comb begin
        unique case (pcsrc_EX)
            3'b000: program_counter_FCH = program_counter_EX + 12'b0000_0000_0001;
            3'b001: program_counter_FCH = program_counter_EX + {branch_offset_EX[12],branch_offset_EX[12:2]};
            3'b010: program_counter_FCH = program_counter_EX + jal_offset_EX[13:2];
            3'b011: program_counter_FCH = program_counter_EX + {{2{jalr_offset_EX[11]}},jalr_offset_EX[11:2]} + 12'b0000_0000_0001;
            3'b100: program_counter_FCH = program_counter_EX;
            default: program_counter_FCH = program_counter_EX; // Error
        endcase
        //program_counter_FCH = program_counter_FCH - 12'b0000_0000_0001;
    end

    /* Clocked Behavior */
    always_ff @(posedge clock_i) begin
        if (~reset_ni) begin    // Zero Everything out.
            //program_counter_EX <= 12'b0000_0000_0000;
            //instruction <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        end else begin  // Grab the correct next instruction.
            // Delay program_counter to EX incase we want to write it.
            program_counter_EX <= program_counter_FCH;
            instruction <= instruction_memory[program_counter_FCH];
        end
    end
endmodule