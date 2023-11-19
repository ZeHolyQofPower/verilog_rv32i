class mr_uvm_test extends uvm_pkg::uvm_test;
    `include "uvm_macros.svh"
    //`uvm_component_utils(mr_uvm_test)
    // TODO idk how to write this macro but I did confirm it has one nonstring argument.

    // Standard component factory call
    function new(string name = "mr_uvm_test", uvm_pkg::uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Declare other testbench components
    //my_env m_top_env; // Environment contains other agents, register models, etc.
    //my_cfg m_cfg0;    // Configuration object that tweaks environment for this test.

    // Instantiate and build these
    virtual function void build_phase(uvm_pkg::uvm_phase phase);
        super.build_phase(phase);
        // Components instantiate with type_id::create() instead of new().
        //m_top_env = my_env::type_id::create("m_top_env", this);
        //m_cfg0 = my_cfg::type_id::create("m_cfg0", this);

        // Configure testbench components if needed
        //set_cfg_params();

        // Make the config object available to all components in environment/agent/etc?
        //uvm_config_db #(my_cfg)::set(this, "m_top_env.my_agent", "m_cfg0", m_cfg0);
    endfunction

    // After the environment is all complete, print topology for debugging.
    virtual function void end_of_elaboration_phase(uvm_pkg::uvm_phase phase);
        uvm_pkg::uvm_top.print_topology();
    endfunction

    // Start a virtual or normal sequence for this this particular test
    /*
    virtual task run_phase(uvm_pkg::uvm_phase phase);
        // Create and instantiate sequence
        my_seq mr_sequence = my_seq::type_id::create("mr_sequence");
        // Raise objection. This makes the test consume simulation time.
        phase.raise_objection(this);
        // Start sequence on a given sequencer.
        mr_sequence.start(mr_sequence.seqr);
        // Drop objection to finish test correctly.
        phase.drop_objection(this);
    endtask
    */


endclass