//
class sequencer #(parameter TransNo = 64);
//classes
rand transaction trans;

//
mailbox seq2driv;
int transactions_no = TransNo;


//functions
function new(mailbox seq2driv);
  this.seq2driv = seq2driv;
endfunction

//tasks
task run();
  $display("--- Sequencer Starts ...");
    repeat(transactions_no) begin
      trans = new();
      if(! trans.randomize())
        $fatal($realtime, " [SEQUENCER] ERROR in Randomization!");
      else
        $display($realtime, " [SEQUENCER] Randomization is DONE");
      /*
      $display($realtime, " [SEQ] [TRANS] wr_en=%0d, rd_en=%0d, addr=%0d, din=%0d, dout=%0d, vld=%0d", 
                   trans.i_mem_wen, trans.i_mem_ren, trans.i_mem_addr, 
                   trans.i_mem_din, trans.o_mem_dout, trans.o_mem_vld_out);
      */
      seq2driv.put(trans);
    end
  $display("--- Sequencer Ends ...");
endtask


endclass