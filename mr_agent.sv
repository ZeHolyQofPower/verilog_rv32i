class mr_agent extends uvm_pkg::uvm_agent;
    /* An agent encapsulates a squencer (containing multiple sequences), a driver,
     * and a monitor.
     * Active agents have all three parts and drives data to the DUT.
     * Passive agents only have a monitor and they check for coverage.
     * Each agent class is written to be both, and then configured by the config db.
     */
    // I used a macro to import a macro lol.
    `include "uvm_macros.svh"
    // TODO doesn't work for now...
    // This utility macro registers this object with the object factory.
    //`uvm_component_utils(mr_agent)

    // Standard component factory call
    function new(string name = "mr_agent", uvm_pkg::uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Create handles to your custom defined classes
    // TODO why can't the compiler find my custom classes?
    //mr_driver mr_driver0;
    //mr_monitor mr_monitor0;
    //mr_sequencer mr_sequencer0;
    //mr_configuration mr_configuration0;

    // Instatiate and build your components
    virtual function void build_phase (uvm_pkg::uvm_phase phase);
        // Active agents have a driver and sequencer
        if (get_is_active()) begin
            //mr_sequencer0 = uvm_pkg::uvm_sequencer::type_id::create ("mr_sequencer0", this);
            //mr_driver0 = mr_driver::type_id::create ("mr_driver0", this);
        end
        // Both Passive an Active agents have a monitor
        //mr_monitor0 = mr_monitor::type_id::creat ("mr_monitor0", this);
    endfunction

    //
    virtual function void connect_phase (uvm_pkg::uvm_phase phase);
        super.connect_phase(phase);
        // If active, connect driver to sequencer.
        if (get_is_active()) begin
            //mr_driver0.seq_item_port.connect (mr_sequencer0.seq_item_export);
        end
    endfunction

    // This is supposed to handle hardware resets here?
endclass