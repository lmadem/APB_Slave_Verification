//reset_sequence extends from apb_base_sequence
class reset_sequence extends apb_base_sequence;
  `uvm_object_utils(reset_sequence)
  
  //constructor
  function new(string name = "reset_sequence");
    super.new(name);
  endfunction
  
  task body();
    `uvm_create(req);
    req.kind = RESET;
    req.reset_cycles = 5;
    start_item(req);
    finish_item(req);
    `uvm_info("RST_SEQ", "***** RESET SEQUENCE COMPLETED ******", UVM_MEDIUM);
  endtask
 
endclass
