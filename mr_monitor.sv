class mr_monitor extends uvm_pkg::uvm_monitor;
    /* This class collects info from a virtual interface.
     * This data is exported to an analysis port.
     */
    `include "uvm_macros.svh"
    //`uvm_object_utils (mr_sequencer)
    function new (string name = "mr_sequencer", uvm_pkg::uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    //
    virtual if_name mr_virtual_interface_handle;

    // Declare analysis port for "signal_packet"s, a custom class object.
    //uvm_pkg::uvm_analysis_port #(signal_packet) mr_monitor_analysis_port;

    //
    virtual function void build_phase (uvm_pkg::uvm_phase phase);
        super.build_phase (phase);
        // Create analysis port
        //mr_monitor_analysis_port = new ("mr_monitor_analysis_port", this);
        // Get virtual interface handle from then configuration DB
        if (!uvm_pkg::uvm_config_db #(virtual if_name)::get(this, "", "mr_virtual_interface_handle", mr_virtual_interface_handle)) begin
            //`uvm_error (get_type_name(), "DUT interface not found");
        end
    endfunction

    //
    virtual task run_phase (uvm_pkg::uvm_phase phase);
        // For off multiple threads as needed to monitor the interface.
        fork
            //mr_monitor_analysis_port.write();
            //`uvm_info(get_type_name(), $sformatf("Mr_Monitor found packet %s", item.convert2str()), uvm_pkg::UVM_LOW)
        join_none
    endtask
endclass