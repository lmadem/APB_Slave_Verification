//base_sequence
class apb_base_sequence extends uvm_sequence#(apb_transaction);
  //registering into the factory
  `uvm_object_utils(apb_base_sequence)
  //packet count
  int unsigned pkt_count;
  
  //constructor
  function new(string name = "apb_base_sequence");
    super.new(name);
    set_automatic_phase_objection(1); //UVM-1.2
  endfunction
  
  virtual task pre_start();
    if(!uvm_config_db#(int)::get(m_sequencer,"","item_count", pkt_count))
      begin
        `uvm_warning("BASE_SEQ", "Item count is not set in sequence");
        pkt_count = 2;
      end
  endtask
  
  task body();
    int unsigned pkt_id;
    repeat(pkt_count)
      begin
        `uvm_create(req);
        void'(req.randomize());
        req.kind = STIMULUS;
        start_item(req);
        finish_item(req);
        pkt_id++;
        `uvm_info("BASE_SEQ", $sformatf("Transaction %0d Generated", pkt_id), UVM_MEDIUM);
      end
  endtask
endclass

