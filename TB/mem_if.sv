//
interface mem_if(
  input   logic       i_mem_clk,
  input   logic       i_mem_rst_n
  );
  
  logic               i_mem_wen;
  logic               i_mem_ren;
  logic   [3  : 0]    i_mem_addr;
  logic   [31 : 0]    i_mem_din;
  logic   [31 : 0]    o_mem_dout;
  logic               o_mem_vld_out;
  
  
  
  clocking driver_ckb @(posedge i_mem_clk, negedge i_mem_rst_n);
    default input #1 output #1;
    output  i_mem_wen;
    output  i_mem_ren;
    output  i_mem_addr;
    output  i_mem_din;
    input   o_mem_dout;
    input   o_mem_vld_out;
  endclocking
  
  
  
  clocking monitor_ckb @(posedge i_mem_clk, negedge i_mem_rst_n);
    default input #1;
    input   i_mem_wen;
    input   i_mem_ren;
    input   i_mem_addr;
    input   i_mem_din;
    input   o_mem_dout;
    input   o_mem_vld_out;
  endclocking
  
  
  modport DRV (clocking driver_ckb, input i_mem_clk, input i_mem_rst_n);
  modport MONIT (clocking monitor_ckb, input i_mem_clk, input i_mem_rst_n);
    
  
endinterface
