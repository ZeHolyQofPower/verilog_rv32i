class mr_scoreboard extends uvm_pkg::uvm_scoreboard;
    /* This class contains the checkers and keeps track of the pass/fails.
     *
     */
    `include "uvm_macros.svh"
    //`uvm_component_utils(mr_agent)

    // Standard component factory call
    function new(string name = "mr_scoreboard", uvm_pkg::uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Declare and create TLM Analysis Port to receive data objects.
    //uvm_pkg::uvm_analysis_imp #(apb_pkt, mr_scoreboard) ap_imp;
    // Note: ap_imp means analysis_port_implementation

    // Instantiate the analysis port
    function void build_phase (uvm_pkg::uvm_phase phase);
        //ap_imp = new ("ap_imp", this);
    endfunction

    // When a packet is received
    virtual function void write ();
        // Do something with the packet
    endfunction

    // Checking can be done in either the run phase or the check phase.

    // Connect analysis ports to other components within the environment.
    virtual function void connect_phase (uvm_pkg::uvm_phase phase);
        super.connect_phase (phase);
        // m_apb_agent.m_apb_mon.analysis_port.connect (m_scdb.ap_imp);
    endfunction
endclass