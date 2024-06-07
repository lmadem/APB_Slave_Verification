# APB Slave Verification in UVM Environment
Design of APB Slave Memory Model in Verilog and built a verification environment in UVM architecture. The main intension of this repository is to document the verification plan and test case implementation in UVM testbench environment and have a hands-on exercise on APB Protocol

<details>
  <Summary> APB Protocol Spec </Summary>

  #### In general, the primary goal of a simple system bus is to allow software(running on a processor) to communicate with other hardware in the SOC. The APB Interface is designed for accessing the programmable control registers of peripheral devices. APB peripherals are typically connected to the main memory system using an APB bridge. For example, bridge from AHB to APB could be used to connect a number of APB peripherals to an AHB memory system

  ![image](https://github.com/lmadem/APB_Slave_Verification/assets/93139766/01f008d7-a43c-47c7-8796-fc2198665baf)

  #### The APB is part of the AMBA(Advanced Microcontroller Bus Architecture) protocol family. It provides a low-cost interface that is optimized for minimal power consumption and reduced interface complexity. The APB interfaces to any peripherals that are low-bandwidth and do not require the high performance of a pipelined bus interface. The APB interface is not pipelined and is a simple, synchronous protocol 
  
</details>


<details>
  <summary> Defining the black box design of APB Slave Memory Model </summary>

  #### Designed a simple memory model which follows APB Synchronous protocol in Verilog. Every transfer takes at least two cycles to complete
  
  #### Prefix P denotes AMBA 3 APB Signals (ex. PCLK, PSEL ....)

  <li> Input Ports : PCLK, PRESETn, PSEL, PENABLE, PWRITE, PADDR, PWDATA </li>

  <li> Output Ports : PRDATA, PREADY </li>

  #### Input Signals Description

  <li> PCLK       : Clock </li>
  <li> PRESETn    : Asynchronous reset, active low </li>
  <li> PSEL       : APB Select Signal, active high </li>
  <li> PENABLE    : APB Enable Signal, active high </li>
  <li> PWRITE     : APB Write/read Signal, PWRITE = 1 for Write and PWRITE = 0 for Read </li>
  <li> PADDR      : APB address Signal, 32 bit wide </li>
  <li> PWDATA     : APB Write Data Signal, 32 bit wide </li>

  #### Output Signals Description

  <li> PRDATA     : APB Read Data Signal, 32 bit wide </li>
  <li> PREADY     : APB Ready Signal, Active High </li>

  #### Black Box Design

  ![image](https://github.com/lmadem/APB_Slave_Verification/assets/93139766/974a0ad8-ceb7-47d9-8048-d52e6d09bf6f)

  #### APB Operating States : It operates in two phases, setup phase and access phase

  ##### SETUP PHASE

  <li> PSEL = 1 </li>
  <li> PWRITE = 1 </li>
  <li> PADDR = PADDR </li>
  <li> PWDATA = PWDATA </li>

  ##### ACCESS PHASE

  <li> PENABLE = 1 </li>

  #### APB Write without Wait States

  ![image](https://github.com/lmadem/APB_Slave_Verification/assets/93139766/2c4d9dc6-c41b-41db-a39d-75b12614cb28)

  #### APB Write with Wait States

  ![image](https://github.com/lmadem/APB_Slave_Verification/assets/93139766/928a3d8c-f8e2-403e-9633-5b384f690891)

  #### APB Read without Wait States

  ![image](https://github.com/lmadem/APB_Slave_Verification/assets/93139766/c2e64ab8-c8c7-4d9f-910f-1a78f62a05fb)

   #### APB Read with Wait States

   ![image](https://github.com/lmadem/APB_Slave_Verification/assets/93139766/ab242e25-7362-4b28-a945-07c7d796f58f)


  <li> This is a simple APB Slave Model implemented in verilog. Please check out the file "Design.sv" for verilog code</li>
  
</details>

<details>
  <summary> Verification Plan </summary>

  #### The verification plan for APB Slave design is implemented in two phases
  <li> First phase is without wait states for the testcases </li>
  <li> Second phase is with wait states for the testcases </li>

  <details> 
    <summary> Test Plan </summary>

![image](https://github.com/lmadem/APB_Slave_Verification/assets/93139766/0dde8c50-ebd8-44db-b94a-9a93d3f8eafd)



  </details>
</details>

<details>
  <summary> Verification Results </summary>

  <details>
    <summary> UVM Environment </summary>

  <li> Implemented all the listed testcases as per the test plan in UVM architecture. The testbench environment consists of top module, interface, program block, transaction class, base sequence, reset sequence, write_read sequence, out of order sequence, config object, sequencer, driver, input monitor, coverage, master agent, output monitor, slave agent, scoreboard(out of order), environment, package, base test and other test components </li>

  <li> The UVM environment will be able to run one test case per simulation </li>

  ### Test Plan Status
  
 ![image](https://github.com/lmadem/APB_Slave_Verification/assets/93139766/7328ddb8-8eab-4b05-a475-6c878a9e115c)

 <li> Please check the folder UVM ENV for code files </li>

  </details>

  </details>

<details>
  <summary> EDA Playground Link and Simluation Steps </summary>

  #### EDA Playground Link

  ```bash
https://www.edaplayground.com/x/Xtfr
  ```

  #### Verification Standards

  <li> Implemented coverage component and acheived 100% functional coverage. Implemented out-of-order scoreboard. Built a robust & reusable components in UVM architecture </li>

  #### Simulation Steps
  <details>
    <summary> Without Wait States </summary>

##### Open "top.sv", set parameter parameter WAIT_CYCLES_COUNT_TB = 0(which overrides the parameter in design) to perform APB Slave transfer without wait states

##### To run wr_test : provide +UVM_TESTNAME=wr_test in runtime arguments

##### To run out_of_order_test : provide +UVM_TESTNAME=out_of_order_test in runtime arguments

  </details>
  
  <details>
    <summary> With Wait States </summary>

##### Open "top.sv", set parameter parameter WAIT_CYCLES_COUNT_TB = any_random_value(which overrides the parameter in design) to perform APB Slave transfer with wait states

##### To run wr_test : provide +UVM_TESTNAME=wr_test in runtime arguments

##### To run out_of_order_test : provide +UVM_TESTNAME=out_of_order_test in runtime arguments

  </details>
</details>


</details>
