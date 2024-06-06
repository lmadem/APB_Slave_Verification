//Interface
interface apb_intf(input logic PCLK);
  logic  PRESETn;        //APB Reset
  logic  [31:0] PADDR;   //APB Address
  logic  [31:0] PWDATA;  //APB Write Data
  logic  [31:0] PRDATA;  //APB Read Data
  logic  PWRITE;         //PWRITE = 1 for Write; PWRITE = 0 for Read
  logic  PSEL;           //APB Select Signal
  logic  PENABLE;        //APB Enable Signal
  logic  PREADY;         //APB Ready Signal
  
  //clocking block for driver
  clocking cb@(posedge PCLK);
    //directions are w.r.t to testbench
    output PADDR;
    output PWDATA;
    output PWRITE;
    output PSEL;
    output PENABLE;
    input PRDATA;
    input PREADY;
  endclocking
  
  //clocking block for monitors
  clocking mcb@(posedge PCLK);
    input PADDR;
    input PWDATA;
    input PRDATA;
    input PREADY;
    input PSEL;
    input PENABLE;
    input PWRITE;
  endclocking
  
  //modports for specifying the directions
  modport drv(clocking cb, output PRESETn);
  modport mon(clocking mcb, input PRESETn);
  
endinterface
