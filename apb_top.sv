//top module
`include "apb_interface.sv"
`include "program_tb.sv"
module top;
  //parameter to override wait_cycles_count in design
  parameter WAIT_CYCLES_COUNT_TB = 0;
  
  //clock declaration
  bit PCLK;
  
  //clock generation
  always #5 PCLK = ~PCLK;
  
  //Interface Instantiation
  apb_intf apb_intf_inst(PCLK);
  
  //DUT Instantiation
  apb_slave_ip #(.WAIT_CYCLES_COUNT(WAIT_CYCLES_COUNT_TB))
               apb_slave_ip_inst (.PCLK(PCLK),
                                  .PRESETn(apb_intf_inst.PRESETn),
                                  .PADDR(apb_intf_inst.PADDR),
                                  .PWDATA(apb_intf_inst.PWDATA),
                                  .PRDATA(apb_intf_inst.PRDATA),
                                  .PWRITE(apb_intf_inst.PWRITE),
                                  .PSEL(apb_intf_inst.PSEL),
                                  .PENABLE(apb_intf_inst.PENABLE),
                                  .PREADY(apb_intf_inst.PREADY)
                                );
  
  //Program Block Instantiation
  program_tb program_tb_inst(apb_intf_inst);
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, top);
    end
  
endmodule
