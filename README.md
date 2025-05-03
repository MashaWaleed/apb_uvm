# APB UART UVM Testbench

This is a UVM testbench for an APB UART project. The testbench provides the basic structure and components needed for verification, with specific components left for other team members to implement.

## Current Implementation

The testbench currently includes:

1. **Basic UVM Structure**
   - Package file (`apb_uart_pkg.sv`)
   - Environment (`apb_uart_env.sv`)
   - Base test (`base_test.sv`)

2. **Three Agents**
   - APB Agent (active)
   - UART Agent (active, can be converted to passive)
   - RAM Agent (active, can be converted to passive)

3. **Configuration Classes**
   - Agent configurations with virtual interfaces
   - Active/passive mode configuration

## Missing Components (To Be Implemented)

1. **Interfaces**
   - `apb_if.sv`
   - `uart_if.sv`
   - `ram_if.sv`

2. **Sequences**
   - APB sequences
   - UART sequences
   - RAM sequences

3. **Scoreboard**
   - Transaction comparison
   - Error checking

4. **Coverage**
   - Functional coverage
   - Code coverage

## How to Extend the Testbench

### 1. Adding Interfaces

Create the following interface files in the `tb` directory:

```systemverilog
// apb_if.sv
interface apb_if(input logic pclk, input logic presetn);
    // Add APB interface signals here
endinterface

// uart_if.sv
interface uart_if(input logic clk, input logic rst_n);
    // Add UART interface signals here
endinterface

// ram_if.sv
interface ram_if(input logic clk, input logic rst_n);
    // Add RAM interface signals here
endinterface
```

### 2. Adding Sequences

Create sequence files in a new `tb/uvm/seq_lib` directory:

```systemverilog
// apb_seq_lib.sv
class apb_base_seq extends uvm_sequence #(apb_seq_item);
    // Add sequence implementation
endclass

// uart_seq_lib.sv
class uart_base_seq extends uvm_sequence #(uart_seq_item);
    // Add sequence implementation
endclass

// ram_seq_lib.sv
class ram_base_seq extends uvm_sequence #(ram_seq_item);
    // Add sequence implementation
endclass
```

### 3. Adding Scoreboard

Create a scoreboard file in `tb/uvm`:

```systemverilog
// scoreboard.sv
class apb_uart_scoreboard extends uvm_scoreboard;
    // Add scoreboard implementation
endclass
```

### 4. Adding Coverage

Create coverage files in `tb/uvm`:

```systemverilog
// coverage.sv
class apb_uart_coverage extends uvm_subscriber #(apb_seq_item);
    // Add coverage implementation
endclass
```

## Integration Steps

1. **Add Missing Files**
   - Add all interface files
   - Add sequence files
   - Add scoreboard
   - Add coverage

2. **Update Package File**
   - Add includes for new files
   - Update import statements if needed

3. **Update Environment**
   - Add scoreboard instance
   - Add coverage instance
   - Connect analysis ports

4. **Update Base Test**
   - Add sequence creation and starting
   - Add scoreboard and coverage configuration

## Converting Agents to Passive

To convert UART and RAM agents to passive mode:

1. In the test configuration:
```systemverilog
uart_cfg.is_active = UVM_PASSIVE;
ram_cfg.is_active = UVM_PASSIVE;
```

2. Update the environment to handle passive agents:
```systemverilog
function void connect_phase(uvm_phase phase);
    // Connect passive agent monitors
    uart_agt.mon.ap.connect(scoreboard.uart_export);
    ram_agt.mon.ap.connect(scoreboard.ram_export);
endfunction
```

## Running the Testbench

1. Compile all files:
```bash
vlog -sv tb/uvm/*.sv tb/*.sv
```

2. Run simulation:
```bash
vsim -c work.base_test
```

## Directory Structure

```
tb/
├── uvm/
│   ├── apb_agent.sv
│   ├── uart_agent.sv
│   ├── ram_agent.sv
│   ├── apb_agent_config.sv
│   ├── uart_agent_config.sv
│   ├── ram_agent_config.sv
│   ├── apb_uart_env.sv
│   ├── base_test.sv
│   ├── apb_uart_pkg.sv
│   └── seq_lib/          # To be added
│       ├── apb_seq_lib.sv
│       ├── uart_seq_lib.sv
│       └── ram_seq_lib.sv
├── apb_if.sv            # To be added
├── uart_if.sv           # To be added
└── ram_if.sv            # To be added
```

## Notes

- All agents start as active but UART and RAM agents can be converted to passive
- TLM communication is set up through analysis ports
- config_db is used for configuration
- Scoreboard and coverage are left for other team members to implement
- Sequences are left for other team members to implement 