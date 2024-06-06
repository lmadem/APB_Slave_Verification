//coverage component
class apb_coverage extends uvm_subscriber #(apb_transaction);
  //registering into factory
  `uvm_component_utils(apb_coverage);
  //coverage score variable
  real coverage_score;
  //transaction packet
  apb_transaction pkt;
  
  //covergroup
  covergroup apb_cov with function sample(apb_transaction pkt);
    option.comment = "Coverage for APB ";
    //Measure APB Coverage
    //Coverpoint on address
    addr : coverpoint pkt.addr {
      bins apb_addr[] = {[0:255]};
    }
    
    
    //Coverpoint on write & read operation
    mode : coverpoint pkt.kind {
      bins write = {WRITE};
      bins read = {READ};
    }
   
  endgroup
  
  //constructor
  function new(string name = "apb_coverage", uvm_component parent);
    super.new(name, parent);
    apb_cov = new;
  endfunction
  
  virtual function void write(T t);
    if(!$cast(pkt, t.clone))
      begin
        `uvm_fatal("COV", "Transaction object supplied is null in apb_coverage component");
      end
    apb_cov.sample(pkt);
    coverage_score = apb_cov.get_coverage();
    `uvm_info("COV", $sformatf("Coverage=%0f", coverage_score), UVM_NONE);
  endfunction
  
  virtual function void extract_phase(uvm_phase phase);
    uvm_config_db#(real)::set(null, "uvm_test_top", "cov_score", coverage_score);
  endfunction
  
  
endclass
