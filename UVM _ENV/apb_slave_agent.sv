//slave agent
class apb_slave_agent extends uvm_agent;
  //registering into factory
  `uvm_component_utils(apb_slave_agent)
  //object handle
  apb_config apb_cfg;
  //component handle
  apb_oMonitor apb_oMon;
  apb_coverage apb_cov;
  
  //pass through analysis port
  uvm_analysis_port #(apb_transaction) pass_through_ap_port;
  
  //constructor
  function new(string name = "apb_slave_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
    
endclass
    

//build method
function void apb_slave_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  pass_through_ap_port = new("pass_through_ap_port", this);
  
  if(!uvm_config_db#(apb_config)::get(this, "", "apb_config", apb_cfg))
    begin
      `uvm_fatal("CFG_ERR", "Configuration is not set in APB Slave Agent");
    end
  
  apb_oMon = apb_oMonitor::type_id::create("apb_oMon", this);
  if(apb_cfg.coverage_enable)
    apb_cov = apb_coverage::type_id::create("apb_cov", this);
endfunction
    

//connect method
function void apb_slave_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  apb_oMon.ap.connect(pass_through_ap_port);
  apb_oMon.vif = apb_cfg.mon_if;
  if(apb_cfg.coverage_enable)
    apb_oMon.ap.connect(apb_cov.analysis_export);
endfunction
