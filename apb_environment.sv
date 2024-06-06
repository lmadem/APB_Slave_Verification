//Environment component
class apb_environment extends uvm_env;
  //registering into factory
  `uvm_component_utils(apb_environment)
  //master agent handle
  apb_master_agent apb_magent;
  //slave agent handle
  apb_slave_agent apb_sagent;
  //scoreboard handle
  scoreboard #(apb_transaction) scb;
  
  //constructor
  function new(string name = "apb_environment", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  
endclass
    
    
//build method
function void apb_environment::build_phase(uvm_phase phase);
  super.build_phase(phase);
  apb_magent = apb_master_agent::type_id::create("apb_magent", this);
  apb_sagent = apb_slave_agent::type_id::create("apb_sagent", this);
  scb = scoreboard#(apb_transaction)::type_id::create("scb", this);
endfunction
    
  
//connect method
function void apb_environment::connect_phase(uvm_phase phase);
  apb_magent.pass_through_ap_port.connect(scb.mon_inp);
  apb_sagent.pass_through_ap_port.connect(scb.mon_outp);
endfunction

