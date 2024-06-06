//scorebord component : out of order
class scoreboard #(type T = apb_transaction) extends uvm_scoreboard;
  typedef scoreboard #(T) scb_type;
  `uvm_component_param_utils(scb_type);
  
  const static string type_name = $sformatf("Scoreboard#(%0s)", $typename(T));
  
  virtual function string get_type_name();
    return type_name;
  endfunction
  
  `uvm_analysis_imp_decl(_inp)
  `uvm_analysis_imp_decl(_outp)
  
  uvm_analysis_imp_inp #(T, scb_type) mon_inp;
  uvm_analysis_imp_outp #(T, scb_type) mon_outp;
  
  //queue to store addresses
  T q_inp[$];
  bit [31:0] m_matches, m_mismatches;
  bit [31:0] no_of_pkts_recvd;
  
  //constructor
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_inp = new("mon_inp", this);
    mon_outp = new("mon_outp", this);
  endfunction
  
  virtual task write_inp(T pkt);
    T pkt_in;
    $cast(pkt_in, pkt.clone());
    q_inp.push_back(pkt_in);
  endtask
  
  virtual task write_outp(T recvd_pkt);
    T ref_pkt;
    int get_index[$];
    int index;
    bit done;
    no_of_pkts_recvd++;
    get_index = q_inp.find_index() with (item.addr == recvd_pkt.addr);
    foreach(get_index[i])
      begin
        index = get_index[i];
        ref_pkt = q_inp[index];
        if(ref_pkt.compare(recvd_pkt))
          begin
            m_matches++;
            q_inp.delete(index);
            `uvm_info("SCB_MATCH", $sformatf("Packet %0d Matched", no_of_pkts_recvd), UVM_NONE);
            done = 1;
          end
        else
          done = 0;
        
      if(!done)
        begin
          m_mismatches++;
          `uvm_error("SCB_NO_MATCH", $sformatf("***Matching packet not found for the pkt_id=%0d******", no_of_pkts_recvd));
          `uvm_info("SCB_NO_MATCH", $sformatf("Expected : %0s", ref_pkt.convert2string()), UVM_NONE);
          `uvm_info("SCB_NO_MATCH", $sformatf("Actual : %0s", recvd_pkt.convert2string()), UVM_NONE);
          done = 0;
        end
      end
    

  endtask
  
  
  virtual function void extract_phase(uvm_phase phase);
    uvm_config_db#(int)::set(null, "uvm_test_top", "matches", m_matches);
    uvm_config_db#(int)::set(null, "uvm_test_top", "mis_matches", m_mismatches); 
  endfunction
  
  function void report_phase(uvm_phase phase);
    `uvm_info("SCB", $sformatf("Scoreboard completed with matches=%0d mismatches=%0d", m_matches, m_mismatches), UVM_NONE);
  endfunction
  
endclass
