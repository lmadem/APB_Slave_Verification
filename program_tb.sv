`include "apb_pkg.sv"

program program_tb(apb_intf apb_pif);

import uvm_pkg::*;
import apb_pkg::*;

`include "base_test.sv"
`include "wr_test.sv"
`include "out_of_order_test.sv"

initial
  begin
    uvm_config_db#(virtual apb_intf)::set(null,"uvm_test_top","apb_if",apb_pif);
    run_test();
  end

endprogram

