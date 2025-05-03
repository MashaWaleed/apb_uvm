# Create work library
vlib work

# Compile UVM package
vlog -sv +incdir+$env(UVM_HOME)/src $env(UVM_HOME)/src/uvm_pkg.sv

# Compile testbench files
vlog -sv tb/uvm/*.sv
vlog -sv tb/top.sv

# Run simulation
vsim -c work.top
run -all
quit 