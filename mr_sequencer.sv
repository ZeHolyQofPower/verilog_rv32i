class mr_sequencer extends uvm_pkg::uvm_sequencer;
    /* This small object generates the random stimulus for the TB.
     */
    `include "uvm_macros.svh"
    //`uvm_object_utils (mr_sequencer)
    function new (string name = "mr_sequencer");
        super.new(name);
    endfunction

    // When a sequence is started on this sequencer, this body method is executed.
    virtual task body();
        //`uvm_info("SEQ", $sformatf("Generate new item: ", uvm_pkg::UVM_LOW))
    endtask
endclass