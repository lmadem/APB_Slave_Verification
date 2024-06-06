//writeread_test
class wr_test extends base_test;
  //registering into factory
  `uvm_component_utils(wr_test);
  
  //constructor
  function new(string name = "wr_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pkt_count = 256;
    uvm_config_db#(int)::set(this,"*.*","item_count",pkt_count);
    uvm_config_db#(uvm_object_wrapper)::set(this,"apb_env.apb_magent.apb_seqr.main_phase","default_sequence",rw_sequence::get_type());
  endfunction
endclass
