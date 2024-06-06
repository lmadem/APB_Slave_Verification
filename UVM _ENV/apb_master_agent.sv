//Master agent
class apb_master_agent extends uvm_agent;
  //registering into factory
  `uvm_component_utils(apb_master_agent)
  
  //object handle
  apb_config apb_cfg;
  
  //component handles
  apb_sequencer apb_seqr;
  apb_driver apb_drv;
  apb_iMonitor apb_iMon;
  apb_coverage apb_cov;
  
  //pass through analysis port
  uvm_analysis_port #(apb_transaction) pass_through_ap_port;
  
  //constructor
  function new(string name = "apb_master_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  
endclass
    
    
//build method
function void apb_master_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  pass_through_ap_port = new("pass_through_ap_port", this);
  
  if(!uvm_config_db#(apb_config)::get(this, "", "apb_config", apb_cfg))
    begin
      `uvm_fatal("CFG_ERR", "Configuration Object is NULL in APB Master Agent");
    end
  
  if(apb_cfg.active == UVM_ACTIVE)
    begin
      apb_seqr = apb_sequencer::type_id::create("apb_seqr", this);
      apb_drv = apb_driver::type_id::create("apb_drv", this);
    end
  
  if(apb_cfg.coverage_enable)
    apb_cov = apb_coverage::type_id::create("apb_cov", this);
  
  apb_iMon = apb_iMonitor::type_id::create("apb_iMon", this);
endfunction
    
    
//connect method
function void apb_master_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(apb_cfg.active == UVM_ACTIVE)
    begin
      apb_drv.seq_item_port.connect(apb_seqr.seq_item_export);
      apb_drv.vif = apb_cfg.drv_if;
    end
  
  apb_iMon.ap.connect(pass_through_ap_port);
  apb_iMon.vif = apb_cfg.mon_if;
  
  if(apb_cfg.coverage_enable)
    apb_iMon.ap.connect(apb_cov.analysis_export);
endfunction
    

