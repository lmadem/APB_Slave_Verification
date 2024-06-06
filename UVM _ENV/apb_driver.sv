//driver class
class apb_driver extends uvm_driver #(apb_transaction);
  //registering into the factory
  `uvm_component_utils(apb_driver);
  //virtual interface
  virtual apb_intf.drv vif;
  bit [15:0] pkt_id;
  
  //constructor
  function new(string name = "apb_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern tasks
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task drive(apb_transaction tr);
  extern virtual task reset(apb_transaction tr);
  extern virtual task write(apb_transaction tr);
  extern virtual task read(apb_transaction tr);
  extern virtual task drive_stimulus(apb_transaction tr);
endclass
    
//run task
task apb_driver::run_phase(uvm_phase phase);
  if(vif == null)
    begin
      `uvm_fatal("VIF_FAIL", "Virtual Interface in apb_driver component is NULL");
    end
  forever
    begin
      seq_item_port.get_next_item(req);
      pkt_id++;
      `uvm_info("DRVR", $sformatf("Received %0s Transaction", req.kind.name()), UVM_HIGH);
      
      drive(req);
      
      seq_item_port.item_done();
      
      `uvm_info("DRVR", $sformatf("Transaction %0d Completed", pkt_id), UVM_MEDIUM);
      
    end
endtask
    

//drive method
task apb_driver::drive(apb_transaction tr);
  case(tr.kind)
    RESET    : reset(tr);
    STIMULUS : drive_stimulus(tr);
    WRITE    : write(tr);
    READ     : read(tr);
    default  : begin
      `uvm_warning("DRVR", "Unknown Transaction Received in apb_driver component");
    end
  endcase
endtask


//reset method
task apb_driver::reset(apb_transaction tr);
  `uvm_info("DRV_RST", "Applying Reset to APB", UVM_MEDIUM);
  vif.cb.PSEL <= 0;
  vif.cb.PENABLE <= 0;
  vif.cb.PADDR <= '0;
  vif.cb.PWDATA <= '0;
  vif.PRESETn <= 0;
  repeat(tr.reset_cycles) @(vif.cb);
  vif.PRESETn <= 1;
  repeat(2) @(vif.cb);
  `uvm_info("DRV_RST", "APB Out of Reset", UVM_MEDIUM);
endtask
    
//drive_stimulus method
task apb_driver::drive_stimulus(apb_transaction tr);
  write(tr);
  read(tr);
endtask
    
//write method
task apb_driver::write(apb_transaction tr);
  `uvm_info("DRV_WR", "APB Write Transaction Started", UVM_HIGH);
  //SETUP phase
  @(vif.cb);
  vif.cb.PSEL <= 1'b1;
  vif.cb.PWRITE <= 1'b1;
  vif.cb.PADDR <= tr.addr;
  vif.cb.PWDATA <= tr.data;
  @(vif.cb);
  //ACCESS phase
  vif.cb.PENABLE <= 1'b1;
  //wait for PREADY from slave
  do @(vif.cb);
  while(!vif.cb.PREADY);
  vif.cb.PSEL <= 1'b0;
  vif.cb.PENABLE <= 1'b0;
  vif.cb.PWDATA <= '0;
  vif.cb.PADDR <= '0;
  `uvm_info("DRV_WR", tr.convert2string(), UVM_HIGH);
endtask
    
//read method
task apb_driver::read(apb_transaction tr);
  `uvm_info("DRV_RD", "APB Read Transaction Started", UVM_HIGH);
  //SETUP Phase
  @(vif.cb);
  vif.cb.PSEL <= 1'b1;
  vif.cb.PWRITE <= 1'b0;
  vif.cb.PADDR <= tr.addr;
  @(vif.cb);
  //ACCESS Phase
  vif.cb.PENABLE <= 1'b1;
  //wait for PREADY
  do @(vif.cb); while(!vif.cb.PREADY);
  vif.cb.PSEL <= 1'b0;
  vif.cb.PENABLE <= 1'b0;
  vif.cb.PADDR <= '0;
  @(vif.cb);
  tr.data <= vif.cb.PRDATA;
  `uvm_info("DRV_RD", $sformatf("APB Read Data=%0h addr=%0h", tr.data, tr.addr), UVM_HIGH);
endtask
            
       
