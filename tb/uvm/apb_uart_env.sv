class apb_uart_env extends uvm_env;
    `uvm_component_utils(apb_uart_env)

    apb_agent apb_agt;
    uart_agent uart_agt;
    ram_agent ram_agt;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create agents
        apb_agt = apb_agent::type_id::create("apb_agt", this);
        uart_agt = uart_agent::type_id::create("uart_agt", this);
        ram_agt = ram_agent::type_id::create("ram_agt", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

endclass 