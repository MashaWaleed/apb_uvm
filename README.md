# UART System with FIFO and Baud Rate Generator

This project implements a complete UART (Universal Asynchronous Receiver-Transmitter) system with FIFO buffers and an integrated baud rate generator. The system is designed for both simulation and hardware implementation.

## 📁 Project Structure

```
├── README.md                    # This file
├── baud_rate_generator.sv       # Baud rate generator module
├── uart_top.sv                  # Top-level UART module with FIFOs
├── tb_uart_top.sv              # Testbench for uart_top
├── compile_and_run.do          # ModelSim compilation and simulation script
├── uart_rx_if.sv               # UART RX interface
├── uart_tx_if.sv               # UART TX interface
├── fifo_if.sv                  # FIFO interface
├── UartRx.sv                   # UART receiver module
├── UartTx.sv                   # UART transmitter module
├── fifo.sv                     # FIFO implementation
└── APB_slave.sv               # APB slave interface (for uart_apb)
```

## 🔧 Core Components

### 1. Baud Rate Generator (`baud_rate_generator.sv`)
Generates timing ticks for UART communication at the specified baud rate.

**Parameters:**
- `CLK_FREQ`: System clock frequency (default: 100MHz)
- `BAUD_RATE`: Desired baud rate (default: 115200)
- `OVERSAMPLE`: Oversampling factor (default: 16)
- `SIMULATION`: Simulation mode flag (1=fast sim, 0=real hardware)

**Ports:**
- `clk`: System clock input
- `rst_n`: Active-low reset
- `tick`: Baud rate tick output

**Features:**
- Configurable for simulation speed vs. real hardware timing
- Automatic counter calculation based on clock frequency and baud rate
- Reset-safe operation

### 2. FIFO Module (`fifo.sv`)
First-In-First-Out buffer for storing UART data.

**Parameters:**
- `width`: Data width in bits (default: 8)
- `depth`: FIFO depth (default: 16)

**Ports:**
- `clk`: Clock input
- `rst_n`: Active-low reset
- `wr_en`: Write enable
- `rd_en`: Read enable
- `din`: Data input
- `dout`: Data output
- `full`: FIFO full flag
- `empty`: FIFO empty flag

**Features:**
- Circular buffer implementation
- Full/empty status flags
- Synchronous read/write operations
- Configurable width and depth

### 3. UART Top Module (`uart_top.sv`)
Top-level module that integrates all UART components.

**Parameters:**
- `DATA_BITS`: Number of data bits (default: 8)
- `PAR_TYP`: Parity type (0=even, 1=odd, 2=none)
- `SB_TICK`: Stop bit ticks (default: 16)
- `FIFO_DEPTH`: FIFO depth (default: 16)
- `CLK_FREQ`: Clock frequency (default: 100MHz)
- `BAUD_RATE`: Baud rate (default: 115200)

**Ports:**
- `clk`: System clock
- `rst_n`: Active-low reset
- `rx`: UART receive input
- `tx`: UART transmit output
- `tx_fifo_wr_en`: TX FIFO write enable
- `tx_fifo_din`: TX FIFO data input
- `tx_fifo_full`: TX FIFO full flag
- `rx_fifo_rd_en`: RX FIFO read enable
- `rx_fifo_dout`: RX FIFO data output
- `rx_fifo_empty`: RX FIFO empty flag
- `rx_error`: Receive error flag

**Features:**
- Integrated baud rate generator
- TX and RX FIFO buffers
- Automatic TX transmission when data available
- Error detection and reporting
- Interface-based connections for modularity

## 🧪 Testbench (`tb_uart_top.sv`)

The testbench demonstrates the complete UART system functionality:

**Test Features:**
- Generates random test data
- Writes data to TX FIFO
- Monitors UART transmission and reception
- Reads data from RX FIFO
- Verifies data integrity through the system

**Test Flow:**
1. Reset the system
2. Write 5 random bytes to TX FIFO
3. Monitor TX transmission
4. Wait for RX reception
5. Read all data from RX FIFO
6. Verify data matches original

## 🚀 Usage

### Compilation and Simulation

1. **Set up ModelSim environment:**
   ```bash
   export PATH=/path/to/modelsim/bin:$PATH
   ```

2. **Compile and run:**
   ```bash
   vsim -do compile_and_run.do
   ```

3. **Or compile manually:**
   ```bash
   vlib work
   vlog -sv uart_rx_if.sv uart_tx_if.sv fifo_if.sv fifo.sv UartRx.sv UartTx.sv baud_rate_generator.sv uart_top.sv tb_uart_top.sv
   vsim -novopt work.tb_uart_top
   ```

### Expected Output
```
=== Starting UART Top Test ===
Time 300: Clock frequency: 100000000 Hz
Time 300: Baud rate: 115200
Time 305: Writing data fe to TX FIFO
Time 315: [UART TX] Starting transmission with data fe
Time 10415: [UART RX] Received data fe
...
=== Reading Received Data ===
Time 100865: Read data fe from RX FIFO
Time 100975: Read data 1d from RX FIFO
...
=== Test Results ===
UART top test completed successfully
```

## 🔧 Configuration

### For Simulation
- Set `SIMULATION = 1` in baud rate generator
- Uses fast timing for quick simulation results

### For Hardware
- Set `SIMULATION = 0` in baud rate generator
- Uses real baud rate timing
- Configure `CLK_FREQ` and `BAUD_RATE` for your system

### Customization
- Modify `FIFO_DEPTH` for different buffer sizes
- Adjust `DATA_BITS` for different data widths
- Change `PAR_TYP` for different parity settings
- Update `SB_TICK` for different stop bit configurations

## 📊 System Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   TX FIFO       │    │   UART TX       │    │   UART RX       │
│                 │    │                 │    │                 │
│  wr_en, din     │───▶│  tx_start       │    │  rx_done        │
│  rd_en, dout    │◀───│  tx_data        │    │  rx_data        │
│  full, empty    │    │  tx_done        │    │  rx_error       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   RX FIFO       │    │   Baud Rate     │    │   External      │
│                 │    │   Generator     │    │   UART Pins     │
│  wr_en, din     │◀───│  tick           │───▶│  rx, tx         │
│  rd_en, dout    │    │                 │    │                 │
│  full, empty    │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🎯 Key Features

- **Modular Design**: Uses SystemVerilog interfaces for clean connections
- **Configurable**: Parameters for different baud rates, data widths, and FIFO depths
- **Simulation Optimized**: Fast simulation mode for quick testing
- **Hardware Ready**: Real timing mode for actual hardware implementation
- **Error Detection**: Parity and framing error detection
- **FIFO Buffering**: Prevents data loss and enables burst transfers

## 🔍 Troubleshooting

### Common Issues:
1. **Slow simulation**: Check `SIMULATION` parameter in baud rate generator
2. **FIFO not working**: Verify FIFO interface connections
3. **Data corruption**: Check baud rate and clock frequency settings
4. **Compilation errors**: Ensure all dependencies are compiled in correct order

### Debug Tips:
- Use ModelSim wave viewer to monitor signals
- Check FIFO full/empty flags
- Monitor baud rate generator ticks
- Verify UART transmission timing

## 📝 License

This project is provided as-is for educational and development purposes. 