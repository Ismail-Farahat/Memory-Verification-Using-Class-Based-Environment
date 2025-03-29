//
class scoreboard;
//
mailbox monit2sb;
int errors_no = 0;
int test_no = 0;

logic [31:0] sc_mem  [16];
logic [3:0]  sc_addr [$];


//functions
function new(mailbox monit2sb);
  this.monit2sb = monit2sb;
endfunction


     
//tasks
task run();
  $display("--- Scoreboard Starts ...");
  fork
    forever begin
      transaction trans_monit;
      trans_monit = new();
      monit2sb.get(trans_monit);
      
      if(trans_monit.i_mem_wen || trans_monit.i_mem_ren) begin
        if(trans_monit.i_mem_wen) begin
          sc_mem[trans_monit.i_mem_addr] = trans_monit.i_mem_din;
          sc_addr.push_front(trans_monit.i_mem_addr);
          $display($realtime, " [SB] Write Operation!");
          //$display($realtime, " [SB] [W] Addr =%0d, DataIn =%0d", 
          //         trans_monit.i_mem_addr, trans_monit.i_mem_din);
          
        end
        else begin
          if(trans_monit.i_mem_addr inside {sc_addr} && trans_monit.o_mem_vld_out) begin
            if(sc_mem[trans_monit.i_mem_addr] == trans_monit.o_mem_dout) begin
              $display($realtime, " [SB] Test No. %0d: Passed (VALUE)!", ++test_no);
            end
            else begin
              $display($realtime, " [SB] Test No. %0d: Failed (VALUE)!", ++test_no);
              $display($realtime, " [SB] [R-VAL-Failed] Addr =%0d, OutData =%0d, OutVld=%0d, ExpectedData=%0d", 
                                    trans_monit.i_mem_addr, 
                                    trans_monit.o_mem_dout, trans_monit.o_mem_vld_out, 
                                    sc_mem[trans_monit.i_mem_addr]);
              errors_no ++;
            end
          end
          else begin
            if(!trans_monit.o_mem_dout) begin
              $display($realtime, " [SB] Test No. %0d: Passed (VALIDITY)!", ++test_no);
            end
            else begin
              $display($realtime, " [SB] Test No. %0d: Failed (VALIDITY)!", ++test_no);
              $display($realtime, " [SB] [R-VLD-Failed] Addr =%0d, OutData =%0d, OutVld=%0d, ExpectedData=%0d", 
                                    trans_monit.i_mem_addr, 
                                    trans_monit.o_mem_dout, trans_monit.o_mem_vld_out, 
                                    sc_mem[trans_monit.i_mem_addr]);
            end
          end
        end
      end
          
      /*
      $display($realtime, " [SB] [TRANS_MONIT] wr_en=%0d, rd_en=%0d, addr=%0d, din=%0d, dout=%0d, vld=%0d", 
               trans_monit.i_mem_wen, trans_monit.i_mem_ren, trans_monit.i_mem_addr, 
               trans_monit.i_mem_din, trans_monit.o_mem_dout, trans_monit.o_mem_vld_out);
      */
    end
  join_none
endtask


task display_errors_no();
  $display($realtime, " [SB] Number of Bugs = %d", errors_no);
endtask

endclass