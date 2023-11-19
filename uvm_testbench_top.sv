module uvm_testbench_top;
    // QuestaSim has UVM integration out of the box!
	import uvm_pkg::*;
    // Warning, do not wildcard import into root namespace.
    // You may get namespace collisions!
	// TODO, figure out a good way to avoid this issue.
    // Maybe learn how SystemVerilog namespaces work eventually...

    // Designs with multiple clocks use UVM generator modules.
    logic [0:0] clk;
	//always #5 clk = ~clk;
	always begin
		#5 clk = 1'b1;
		#5 clk = 1'b0;
	end
	// TODO, Figure out why the zero register hates this commented out one-liner clock?
	// I spent some time fidling with initializing it on high instead of low but that's not it.
	// EH. Don't break what's not causing current bugs.

	// UVM library's interface
	dut_if mr_dut_interface_handle(clk);
	dut_wrapper mr_dut_wr(._if(mr_dut_interface_handle));

	// At the very start of the simulation.
	initial begin
		// Connect the uvm interface you just made and the uvm config database.
		uvm_config_db #(virtual dut_if)::set (null, "uvm_test_top", "dut_if", mr_dut_interface_handle);
		// Run the set of tests by name.
		run_test ("mr_uvm_test");
	end
endmodule