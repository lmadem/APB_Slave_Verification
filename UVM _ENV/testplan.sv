//The purpose of this verification environment is to verify the APB Slave Design Which has a memory model following the APB protocol specifications

//************************************************************************

//TestCases

//wr_test : the purpose of this test is to perform a single write operation followed by read operation in the memory and cover all the address locations to acheive 100% functional coverage - PASS

//out_of_order_test : The purpose of this test is to perform a burst mode of write operation first, followed by read operation covering all the addresses in the memory to acheive 100% functional coverage. This test uses "out_of_order_sequence.sv" - PASS

//APB Slave responses with wait states & without wait states
//The DUT has a parameter WAIT_CYCLES_COUNT which defines the number of wait_cycles for the PREADY to assert

//In the top module("top.sv"), set parameter WAIT_CYCLES_COUNT = 0 to run testcases(wr_test, out_of_order_test) without wait sates & set parameter WAIT_CYCLES_COUNT = "any_random_value" to run testcases(wr_test, out_of_order_test) with wait sates

//*************************************************************************



