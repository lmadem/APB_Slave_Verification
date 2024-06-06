//rw_sequence extends from apb_base_sequence
class rw_sequence extends apb_base_sequence;
  //registering into factory
  `uvm_object_utils(rw_sequence)
  
  //constructor
  function new(string name = "rw_sequence");
    super.new(name);
  endfunction
  
  task body();
    int unsigned pkt_id;
    REQ ref_pkt;
    int qu_addr[$];
    ref_pkt = apb_transaction::type_id::create("ref_pkt");
    repeat(pkt_count)
      begin
        `uvm_create(req);
        if(qu_addr.size() == 256) 
          begin
            qu_addr.delete();
          end
        void'(ref_pkt.randomize() with {!(addr inside {qu_addr});});
        qu_addr.push_back(ref_pkt.addr);
        req.copy(ref_pkt);
        req.kind = STIMULUS;
        start_item(req);
        finish_item(req);
        pkt_id++;
        `uvm_info("RW_SEQ", $sformatf("Transaction %0d Completed", pkt_id), UVM_MEDIUM);
      end
  endtask
endclass
