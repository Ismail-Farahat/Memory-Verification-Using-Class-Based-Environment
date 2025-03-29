//
module memory16_32
  (
    mem_if top_if
  );


  logic [32 : 0]  MEM  [16];   // 32-bit for data, MSB for Valid Signal

  
  always_ff @(posedge top_if.i_mem_clk, negedge top_if.i_mem_rst_n)
  begin : proc_read_write_mem
    if(!top_if.i_mem_rst_n) begin
      for(int i=0; i<16; i++) MEM[i]            <= 'b0;  //write
      {top_if.o_mem_vld_out, top_if.o_mem_dout} <= 'b0;  //read
    end
    else if(top_if.i_mem_wen) begin
      MEM[top_if.i_mem_addr]                    <= {1'b1, top_if.i_mem_din}; //write
    end
    else if(top_if.i_mem_ren) begin
      {top_if.o_mem_vld_out, top_if.o_mem_dout} <= MEM[top_if.i_mem_addr];   //read
    end
  end



endmodule
