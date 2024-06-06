//apb_config extends from uvm_object
//Used to pass virtual interfaces to components(driver, monitor)

class apb_config extends uvm_object;
  //registering into factory
  `uvm_object_utils(apb_config)
  
  //virtual interfaces
  virtual apb_intf.drv drv_if;
  virtual apb_intf.mon mon_if;
  
  //coverage variable
  bit coverage_enable = 0;
  
  //master agent
  uvm_active_passive_enum active = UVM_ACTIVE;
  
  //constructor
  function new(string name = "apb_config");
    super.new(name);
  endfunction
  
endclass
