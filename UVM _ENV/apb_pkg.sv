package apb_pkg;

typedef enum {IDLE, RESET, STIMULUS, WRITE, READ} kind_e;
typedef enum {OK, NOT_OK, ERROR} status_e;

import uvm_pkg::*;
//transaction class
`include "apb_transaction.sv"
//config object
`include "apb_config.sv"

//sequences
`include "base_sequence.sv"
`include "reset_sequence.sv"
`include "rw_sequence.sv"
`include "out_of_order_sequence.sv"

//components
`include "apb_sequencer.sv"
`include "apb_driver.sv"
`include "apb_iMonitor.sv"
`include "apb_coverage.sv"
`include "apb_master_agent.sv"

`include "apb_oMonitor.sv"
`include "apb_slave_agent.sv"

`include "apb_scoreboard.sv"
`include "apb_environment.sv"

endpackage
