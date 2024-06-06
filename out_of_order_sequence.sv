//out_of_order_sequence extends from apb_base_sequence
class out_of_order_sequence extends apb_base_sequence;
  //registering into factory
  `uvm_object_utils(out_of_order_sequence)
  
  rand bit [7:0] addr;
  bit [7:0] qu_addr[$];
  bit [15:0] count;
  bit [15:0] pkt_id;
  REQ rand_pkt;
  
  //constructor
  function new(string name = "out_of_order_sequence");
    super.new(name);
  endfunction
  
  task body();
    rand_pkt = apb_transaction::type_id::create("rand_pkt",,get_full_name());
    if(pkt_count >= 257)
      begin
        for(int i=0; i<=(pkt_count/256); i++)
          begin
            count = (i == (pkt_count / 256)) ? (pkt_count % 256) : 256;
            write_and_read(count);
          end
      end
    else
      write_and_read(pkt_count);
  endtask
  
  
  task write_and_read(input bit [15:0] cnt);
    repeat(cnt)
      begin
        `uvm_create(req);
        void'(rand_pkt.randomize());
        req.copy(rand_pkt);
        void'(this.randomize() with {!(addr inside {qu_addr});});
        qu_addr.push_back(addr);
        req.addr = addr;
        req.kind = WRITE;
        start_item(req);
        finish_item(req);
        pkt_id++;
        `uvm_info("RAND_SEQ", $sformatf("Write Transaction %0d Completed with addr=%0d", pkt_id, req.addr), UVM_MEDIUM);
      end
    
    qu_addr.shuffle();
    pkt_id = 0;
    
    repeat(cnt)
      begin
        `uvm_create(req);
        req.addr = qu_addr.pop_back();
        req.kind = READ;
        start_item(req);
        finish_item(req);
        pkt_id++;
        `uvm_info("RW_SEQ", $sformatf("Read Transaction %0d Completed with addr=%0d", pkt_id, req.addr), UVM_MEDIUM);
      end
  endtask
  
  
endclass
