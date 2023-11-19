
class mr_environment extends uvm_pkg::uvm_env;
    `include "uvm_macros.svh"
    /* The Enviroment contains multiple agents, scoreboards, a coverage collector, and
     * other checkers along with all the default configurations.
     * It may also contain other smaller environments.
     * 
     * You could shove verification components in the test class, but this would 
     * require knowing their default configs to use them, and rewriting tests for each
     * and EVERy environment or set of components.
     * (For example you can't reuse the ALU test on the system level without rewriting it)
     * 
     * This is why you- do the do.
     */

    //`uvm_component_utils (mr_environment)
    // Standard component factory call first.
    function new (string name = "mr_environment", uvm_pkg::uvm_component parent = null);
        super.new (name, parent);
    endfunction

    // Agents, scoreboards, coverage collectors, and configurations handles defined in our TB
    //mr_agent mr_agent_handle;
    // TODO Why is this class not being found by the compiler...
    //mr_scoreboard mr_scoreboard_handle;

    // Build all the components defined above.
    virtual function void build_phase (uvm_pkg::uvm_phase phase);
        super.build_phase (phase);
        // Instantiate agent(s) and environment(s) here.
        //mr_agent_handle = mr_agent::type_id::create ("mr_agent", this);
        //mr_scoreboard_handle = mr_scoreboard::type_id::create ("mr_scoreboard", this);
        // TODO crete paramater zero, handle name or class name?
    endfunction

    //
    virtual function void connect_phase (uvm_pkg::uvm_phase phase);
        // Connect environments, agents, analysis ports, and scoreboards here.
        // Connecting agent to scoreboard
        //mr_agent_handle.mr_monitor0.item_collected_port.connect (mr_scoreboard_handle.data_export);
    endfunction
endclass