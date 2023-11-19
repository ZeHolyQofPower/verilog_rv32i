class mr_driver extends uvm_pkg::uvm_driver;
    /* The Driver is parameterized to get a type red_item?
     * It also receives a handle to a virtual interface with the DUT.
     * It has a fancy handshake with a sequencer.
     */
    `include "uvm_macros.svh"
    //`uvm_component_utils (mr_driver)
    function new (string name = "mr_driver", uvm_pkg::uvm_component parent = null);
        super.new (name, parent);
    endfunction

    // Declare virtual interface handle
    virtual if_name mr_virtual_interface_handle;

    // Assign the virtual interface in the build phase.
    virtual function void build_phase (uvm_pkg::uvm_phase phase);
        super.build_phase (phase);
        if (!uvm_pkg::uvm_config_db #(virtual if_name)::get(this, "", "mr_virtual_interface_handle", mr_virtual_interface_handle)) begin
            //`uvm_fatal (get_type_name(), "Didn't get handle to virtual interface if_name")
        end
    endfunction

    //
    virtual task run_phase (uvm_pkg::uvm_phase phase);
        // Loop through all items in sequencer.
            // Assign data from received item to DUT interface.
        // "Finish driving transaction"?
    endtask
endclass