package Registers_pkg;
import uvm_pkg::*;
 `include "uvm_macros.svh"

 class SYS_STATUS_REG extends uvm_reg;
   `uvm_object_utils(SYS_STATUS_REG)

    function new(string name = "SYS_STATUS_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE) ; 
    endfunction //new()

    rand uvm_reg_field SYS_FATAL_ERR;
    rand uvm_reg_field WATCHDOG_TIMEOUT;
    rand uvm_reg_field PLL_LOCK;
    rand uvm_reg_field BOOT_COMPLETE;
    rand uvm_reg_field ERROR_CODE;
    rand uvm_reg_field INT_ACTIVE;
    rand uvm_reg_field MEM_READY;
    rand uvm_reg_field DMA_BUSY;
    rand uvm_reg_field UART_READY;
         uvm_reg_field RESERVED;
    rand uvm_reg_field SYS_STATE;
    
    //it must be virtual
    virtual function void build();
    SYS_FATAL_ERR = uvm_reg_field::type_id::create("SYS_FATAL_ERR");
    WATCHDOG_TIMEOUT = uvm_reg_field::type_id::create("WATCHDOG_TIMEOUT");
    PLL_LOCK = uvm_reg_field::type_id::create("PLL_LOCK");
    BOOT_COMPLETE = uvm_reg_field::type_id::create("BOOT_COMPLETE");
    ERROR_CODE = uvm_reg_field::type_id::create("ERROR_CODE");
    INT_ACTIVE = uvm_reg_field::type_id::create("INT_ACTIVE");
    MEM_READY = uvm_reg_field::type_id::create("MEM_READY");
    DMA_BUSY = uvm_reg_field::type_id::create("DMA_BUSY");
    UART_READY = uvm_reg_field::type_id::create("UART_READY");
    RESERVED = uvm_reg_field::type_id::create("RESERVED");
    SYS_STATE = uvm_reg_field::type_id::create("SYS_STATE");

    /*  extern function void configure(uvm_reg        parent,
                                  int unsigned   size,
                                  int unsigned   lsb_pos,
                                  string         access,
                                  bit            volatile,
                                  uvm_reg_data_t reset,
                                  bit            has_reset,
                                  bit            is_rand,
                                  bit            individually_accessible);*/

    SYS_FATAL_ERR.configure(this,1 ,31 ,"RO", 0, 1'b0,1 ,1 ,1 );
    WATCHDOG_TIMEOUT.configure(this, 1 ,30 ,"RO" , 0, 1'b0 , 1, , );
    PLL_LOCK.configure(this, 1 , 29,"RO" ,0 , 1'b0, 1, , );
    BOOT_COMPLETE.configure(this, 1 ,28 ,"RO" , 0,1'b0 , 1, , );
    ERROR_CODE.configure(this, 4 ,24 , "RO", 0, , , , );
    INT_ACTIVE.configure(this, 1 ,23 ,"RO" ,0 , , , , );
    MEM_READY.configure(this, 1 ,22 , "RO",0 , , , , );
    DMA_BUSY.configure(this,1  , 21,"RO" ,0 , , , , );
    UART_READY.configure(this, 1 ,20 ,"RO" , 0, , , , );
    RESERVED.configure(this, 12 ,8 ,"RO" , 0, , , , );
    SYS_STATE.configure(this, 8 ,0 ,"RO" ,0 , , , , );

    endfunction

 endclass //className extends superClass

class INT_CTRL_REG extends uvm_reg;
   `uvm_object_utils(INT_CTRL_REG)

    function new(string name = "INT_CTRL_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE) ; 
    endfunction //new()

    rand uvm_reg_field INT_GLOBAL_EN;
    rand uvm_reg_field INT_MASK;
    rand uvm_reg_field INT_PENDING;

    //it must be virtual
    virtual function void build();
    INT_GLOBAL_EN = uvm_reg_field::type_id::create("INT_GLOBAL_EN");
    INT_MASK = uvm_reg_field::type_id::create("INT_MASK");
    INT_PENDING = uvm_reg_field::type_id::create("INT_PENDING");

    INT_GLOBAL_EN.configure(this, 1 ,31 ,"RO" , 0, , , , );
    INT_MASK.configure(this, 15 ,16 ,"RO" ,0 , , , , );
    INT_PENDING.configure(this, 16 , 0, "RO",0 , , , , );
    

    endfunction


 endclass

 class DEV_ID_REG extends uvm_reg;
   `uvm_object_utils(DEV_ID_REG)

    function new(string name = "DEV_ID_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE)  ;
    endfunction //new()

    DEVICE_FAMILY;
    REVISION_ID;
    DEVICE_ID;

    //it must be virtual
    virtual function void build();
    endfunction


 endclass

 class MEM_CTRL_REG extends uvm_reg;
   `uvm_object_utils(MEM_CTRL_REG)

    function new(string name = "MEM_CTRL_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE) ; 
    endfunction //new()

    //it must be virtual
    virtual function void build();
    endfunction


 endclass

 class TEMP_SENSOR_REG extends uvm_reg;
   `uvm_object_utils(TEMP_SENSOR_REG)

    function new(string name = "TEMP_SENSOR_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE) ; 
    endfunction //new()

    //it must be virtual
    virtual function void build();
    endfunction


 endclass

 class ADC_CTRL_REG extends uvm_reg;
   `uvm_object_utils(ADC_CTRL_REG)

    function new(string name = "ADC_CTRL_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE) ;
    endfunction //new()

    //it must be virtual
    virtual function void build();
    endfunction


 endclass

 class DBG_CTRL_REG extends uvm_reg;
   `uvm_object_utils(DBG_CTRL_REG)

    function new(string name = "DBG_CTRL_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE) ; 
    endfunction //new()

    //it must be virtual
    virtual function void build();
    endfunction


 endclass

 class GPIO_DATA_REG extends uvm_reg;
   `uvm_object_utils(GPIO_DATA_REG)

    function new(string name = "GPIO_DATA_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE) ; 
    endfunction //new()

    //it must be virtual
    virtual function void build();
    endfunction


 endclass

 class DAC_OUTPUT_REG extends uvm_reg;
   `uvm_object_utils(DAC_OUTPUT_REG)

    function new(string name = "DAC_OUTPUT_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE) ; 
    endfunction //new()

    //it must be virtual
    virtual function void build();
    endfunction


 endclass

 class VOLTAGE_CTRL_REG extends uvm_reg;
   `uvm_object_utils(VOLTAGE_CTRL_REG)

    function new(string name = "VOLTAGE_CTRL_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE);  
    endfunction //new()

    //it must be virtual
    virtual function void build();
    endfunction


 endclass

 class CLK_CONFIG_REG extends uvm_reg;
   `uvm_object_utils(CLK_CONFIG_REG)

    function new(string name = "CLK_CONFIG_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE) ; 
    endfunction //new()

    //it must be virtual
    virtual function void build();
    endfunction


 endclass

 class TIMER_COUNT_REG extends uvm_reg;
   `uvm_object_utils(TIMER_COUNT_REG)

    function new(string name = "TIMER_COUNT_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE) ; 
    endfunction //new()

    //it must be virtual
    virtual function void build();
    endfunction


 endclass

 class INPUT_DATA_REG extends uvm_reg;
   `uvm_object_utils(INPUT_DATA_REG)

    function new(string name = "INPUT_DATA_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE) ; 
    endfunction //new()

    //it must be virtual
    virtual function void build();
    endfunction


 endclass

 class OUTPUT_DATA_REG extends uvm_reg;
   `uvm_object_utils(OUTPUT_DATA_REG)

    function new(string name = "OUTPUT_DATA_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE);  
    endfunction //new()

    //it must be virtual
    virtual function void build();
    endfunction


 endclass

 class DMA_CTRL_REG extends uvm_reg;
   `uvm_object_utils(DMA_CTRL_REG)

    function new(string name = "DMA_CTRL_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE) ; 
    endfunction //new()

    //it must be virtual
    virtual function void build();
    endfunction


 endclass

 class SYS_CTRL_REG extends uvm_reg;
   `uvm_object_utils(SYS_CTRL_REG)

    function new(string name = "SYS_CTRL_REG");
      super.new(name , 32 ,UVM_NO_COVERAGE) ; 
    endfunction //new()

    //it must be virtual
    virtual function void build();
    endfunction


 endclass

 


endpackage


SYS_STATUS_REG
INT_CTRL_REG;
			 DEV_ID_REG;
				MEM_CTRL_REG;
				 TEMP_SENSOR_REG;
			 ADC_CTRL_REG;
				 DBG_CTRL_REG;
				 GPIO_DATA_REG;
				 DAC_OUTPUT_REG;
				 VOLTAGE_CTRL_REG;
				 CLK_CONFIG_REG;
				TIMER_COUNT_REG;
			 INPUT_DATA_REG;
				 OUTPUT_DATA_REG;
				DMA_CTRL_REG;
				 SYS_CTRL_REG;