//Output Monitor
class apb_oMonitor extends uvm_monitor;
  //registering into factory
  `uvm_component_utils(apb_oMonitor)
  //virtual interface
  virtual apb_intf.mon vif;
  
  //Analysis port
  uvm_analysis_port #(apb_transaction) ap;
  
  //constructor
  function new(string name = "apb_oMonitor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass
    
    
function void apb_oMonitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  ap = new("ap", this);
endfunction
    

task apb_oMonitor::run_phase(uvm_phase phase);
  apb_transaction tr;
  if(vif == null)
    begin
      `uvm_fatal("oMon_VIF", "Virtual Interface is not set in apb_oMonitor component");
    end
  
  forever
    begin
      @(vif.mcb.PRDATA);
      if(vif.mcb.PRDATA === 'x || vif.mcb.PRDATA === 'z) continue;
      
      tr = apb_transaction::type_id::create("tr", this);
      if(vif.mcb.PWRITE == 1'b0) //collect only read transaction
        begin
          tr.addr = vif.mcb.PADDR;
          tr.data = vif.mcb.PRDATA;
          tr.kind = (vif.mcb.PWRITE == 1'b0) ? READ : WRITE;
          `uvm_info("oMon", tr.convert2string(), UVM_MEDIUM);
          ap.write(tr);
        end
    end
endtask
