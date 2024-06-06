//Transaction Class
class apb_transaction extends uvm_sequence_item;
  rand logic [31:0] addr; //address
  rand logic [31:0] data; //data
  bit [4:0] reset_cycles; //reset cycles to be applied to DUT
  
  kind_e kind; //Transaction type
  status_e status; //Transaction status
  
  //constraint for addr & data to be in a certain range
  constraint c1{
    addr inside {[0:255]}; 
    data inside {[10:1000]};
  }
  
  //registering into factory
  `uvm_object_utils_begin(apb_transaction)
  `uvm_field_int(addr, UVM_ALL_ON)
  `uvm_field_int(data, UVM_ALL_ON)
  `uvm_field_enum(kind_e, kind, UVM_NOCOMPARE)
  `uvm_object_utils_end
  
  //constructor
  function new(string name = "apb_transaction");
    super.new(name);
  endfunction
  
  //convert2string function
  virtual function string convert2string();
    return $sformatf("APB %0s addr=%0h data=%0h", kind.name(), addr, data);
  endfunction
  
  
endclass
