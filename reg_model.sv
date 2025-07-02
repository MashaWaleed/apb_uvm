package reg_model_pkg;

import Registers_pkg::*;
import uvm_pkg::*;
 `include "uvm_macros.svh"

class reg_model extends uvm_reg_block;
   `uvm_object_utils(reg_model)

    function new(string name = "reg_model");
      super.new(name ,UVM_NO_COVERAGE) ;
    endfunction //new()

    rand SYS_STATUS_REG sysStatus;
    rand INT_CTRL_REG intCtrl;
		rand DEV_ID_REG devId;
		rand MEM_CTRL_REG memCtrl;
		rand TEMP_SENSOR_REG tempSensor;
		rand ADC_CTRL_REG adcCtrl;
		rand DBG_CTRL_REG dbgCtrl;
		rand GPIO_DATA_REG gpioData;
		rand DAC_OUTPUT_REG dacOut;
		rand VOLTAGE_CTRL_REG voltCtrl;
		rand CLK_CONFIG_REG clkConfig;
		rand TIMER_COUNT_REG timerCount;
		rand INPUT_DATA_REG inputData;
		rand OUTPUT_DATA_REG outputData;
		rand DMA_CTRL_REG dmaCtrl;
		rand SYS_CTRL_REG sysCtrl;

    uvm_reg_map my_map;

    /* extern function void add_hdl_path (uvm_hdl_path_slice slices[],
                                      string kind = "RTL");
      extern function void add_hdl_path_slice(string name,
                                           int offset,
                                           int size,
                                           bit first = 0,
                                           string kind = "RTL");
      extern function void configure (uvm_reg_block blk_parent,
                                   uvm_reg_file regfile_parent = null,
                                   string hdl_path = "");
                                           */

    virtual function void build();
       sysStatus = SYS_STATUS_REG::type_id::create("sysStatus");
       sysStatus.configure(this,null,"");
       sysStatus.build();
       sysStatus.add_hdl_path_slice("sysStatus",0,32);//what offset

       intCtrl = INT_CTRL_REG::type_id::create("intCtrl");
       intCtrl.configure(this,null,"");
       intCtrl.build();
       intCtrl.add_hdl_path_slice("intCtrl",0,32);



       my_map = create_map("my_map" ,16'h0000 ,4 ,UVM_LITTLE_ENDIAN ,1 );//baseaddress  n_bytes  endian  byteaddressing

       my_map.add_reg(sysStatus , 16'h0000);//offset
       my_map.add_reg(intCtrl , 16'h00004);

       add_hdl_path("top." , "RTL");
       lock_model();
      
    endfunction

endclass //reg_model extends superClass
    
endpackage