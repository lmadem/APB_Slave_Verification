//base test component
class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  //packet count
  bit [31:0] pkt_count;
  //matches, mis_matches count
  bit [31:0] m_matches, mis_matches;
  //coverage score
  real tot_cov_score;
  
  //virtual interface
  virtual apb_intf vif;
  //environment handle
  apb_environment apb_env;
  //configure object handle
  apb_config apb_cfg;
  
  //constructor
  function new(string name = "base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);
  extern virtual function void extract_phase(uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);
  
endclass
    
    
function void base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  if(!uvm_config_db#(virtual apb_intf)::get(this,"", "apb_if", vif))
    begin
      `uvm_fatal("VIF_ERR", "Virtual Interface is NULL in APB base_test");
    end
  pkt_count = 10;
  apb_cfg = apb_config::type_id::create("apb_cfg", this);
  apb_cfg.drv_if = vif.drv;
  apb_cfg.mon_if = vif.mon;
  apb_cfg.coverage_enable = 1;
  
  apb_env = apb_environment::type_id::create("apb_env", this);
  
  uvm_config_db#(apb_config)::set(this, "apb_env.apb_magent", "apb_config", apb_cfg);
  uvm_config_db#(apb_config)::set(this, "apb_env.apb_sagent", "apb_config", apb_cfg);
  
  uvm_config_db#(int)::set(this, "*.*", "item_count", pkt_count);
  
  uvm_config_db#(uvm_object_wrapper)::set(this, "apb_env.apb_magent.apb_seqr.reset_phase", "default_sequence", reset_sequence::get_type());
  
  uvm_config_db#(uvm_object_wrapper)::set(this, "apb_env.apb_magent.apb_seqr.main_phase", "default_sequence", apb_base_sequence::get_type());
  
endfunction
    
    
function void base_test::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
  if(uvm_report_enabled(UVM_HIGH))
    begin
      uvm_root::get().print_topology();
      uvm_factory::get().print();
    end
endfunction
    
    
task base_test::main_phase(uvm_phase phase);
  uvm_objection objection;
  super.main_phase(phase);
  objection = phase.get_objection();
  objection.set_drain_time(this, 1000ns);
endtask
    
    
function void base_test::extract_phase(uvm_phase phase);
  uvm_config_db#(real)::get(this,"","cov_score",tot_cov_score);
  uvm_config_db#(int)::get(this,"", "matches", m_matches);
  uvm_config_db#(int)::get(this,"", "mis_matches", mis_matches);
endfunction
    
    
function void base_test::report_phase(uvm_phase phase);
  bit [31:0] tot_scb_cnt;
  tot_scb_cnt = m_matches + mis_matches;
  
  if(pkt_count != tot_scb_cnt)
    begin
      `uvm_info("FAIL","******************************************",UVM_NONE);
      `uvm_info("FAIL","Test Failed due to packet count MIS_MATCH", UVM_NONE);
      `uvm_info("FAIL",$sformatf("expected_pkt_count=%0d Received_in_scb=%0d ",pkt_count,tot_scb_cnt),UVM_NONE); 
      `uvm_fatal("FAIL", "******************Test FAILED ************");
    end
  else if(mis_matches != 0) 
    begin
      `uvm_info("FAIL","******************************************",UVM_NONE);
      `uvm_info("FAIL","Test Failed due to mis_matched packets in scoreboard",UVM_NONE); 
      `uvm_info("FAIL",$sformatf("matched_pkt_count=%0d mis_matched_pkt_count=%0d ",m_matches,mis_matches),UVM_NONE); 
      `uvm_fatal("FAIL","******************Test FAILED ***************");
    end
  else 
    begin
      `uvm_info("PASS","******************Test PASSED ***************",UVM_NONE);
      `uvm_info("PASS",$sformatf("pkt_count=%0d Received_in_scb=%0d ",pkt_count,tot_scb_cnt),UVM_NONE); 
      `uvm_info("PASS",$sformatf("matched_pkt_count=%0d mis_matched_pkt_count=%0d ",m_matches,mis_matches),UVM_NONE); 
      `uvm_info("PASS",$sformatf("Coverage=%0f%%",tot_cov_score),UVM_NONE);
      `uvm_info("PASS","******************************************",UVM_NONE);
    end
endfunction
    
