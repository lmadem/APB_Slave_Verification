//Input Monitor Component
class apb_iMonitor extends uvm_monitor;
  //registering into factory
  `uvm_component_utils(apb_iMonitor)
  //virtual interface
  virtual apb_intf.mon vif;
  
  //Analysis Port
  uvm_analysis_port #(apb_transaction) ap;
  
  //constructor
  function new(string name = "apb_iMonitor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass
    
//build method
function void apb_iMonitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  ap = new("ap", this);
endfunction
   
//run method
task apb_iMonitor::run_phase(uvm_phase phase);
  apb_transaction tr;
  if(vif == null)
    begin
      `uvm_fatal("iMON_VIF", "Virtual Interface is not set in iMonitor Component");
    end
  forever
    begin
      do //Wait for setup phase
        @(vif.mcb);
      while(vif.mcb.PSEL === 1'b0 || vif.mcb.PSEL === 'x);
      
      @(vif.mcb); //wait for access phase
      if(vif.mcb.PENABLE !== 1) 
        begin
          `uvm_fatal("iMON_ERR", "APB Protocol Violation : Setup is not followed by Access Phase");
        end
      
      tr = apb_transaction::type_id::create("tr", this);
      
      while(!vif.mcb.PREADY) //Wait for PREADY from Slave
        @(vif.mcb);
      if(vif.mcb.PWRITE == 1'b1) //collect only write transaction
        begin
          tr.data = vif.mcb.PWDATA;
          tr.addr = vif.mcb.PADDR;
          tr.kind = (vif.mcb.PWRITE == 1'b1) ? WRITE : READ;
          `uvm_info("iMon", tr.convert2string(), UVM_MEDIUM);
          ap.write(tr);
        end
      //while(!vif.mcb.PREADY) @(vif.mcb); //Wait for slave to de-assert PREADY
        
    end
endtask
