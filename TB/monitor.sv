//
class monitor;
//interface
virtual mem_if monit_vif;

//
mailbox monit2sb;
mailbox monit2ss;

//functions
function new(virtual mem_if monit_vif, mailbox monit2sb, mailbox monit2ss);
  this.monit_vif = monit_vif;
  this.monit2sb = monit2sb;
  this.monit2ss = monit2ss;
endfunction

//tasks
task run();
  $display("--- Monitor Starts ...");
fork
    forever @(posedge monit_vif.MONIT.i_mem_clk) begin
      transaction trans;
      trans = new();
      if(monit_vif.MONIT.monitor_ckb.i_mem_wen || monit_vif.MONIT.monitor_ckb.i_mem_ren) begin
        if(monit_vif.MONIT.monitor_ckb.i_mem_wen) begin
          trans.i_mem_ren     = monit_vif.MONIT.monitor_ckb.i_mem_ren;
          trans.i_mem_wen     = monit_vif.MONIT.monitor_ckb.i_mem_wen;
          trans.i_mem_addr    = monit_vif.MONIT.monitor_ckb.i_mem_addr;
          trans.i_mem_din     = monit_vif.MONIT.monitor_ckb.i_mem_din;
        end
        else begin
          trans.i_mem_ren     = monit_vif.MONIT.monitor_ckb.i_mem_ren;
          trans.i_mem_wen     = monit_vif.MONIT.monitor_ckb.i_mem_wen;
          trans.i_mem_addr    = monit_vif.MONIT.monitor_ckb.i_mem_addr;
          if(monit_vif.MONIT.monitor_ckb.o_mem_vld_out) begin
            @(posedge monit_vif.MONIT.i_mem_clk)
            trans.o_mem_dout    = monit_vif.MONIT.monitor_ckb.o_mem_dout;
            trans.o_mem_vld_out = monit_vif.MONIT.monitor_ckb.o_mem_vld_out;
          end
          else begin
            trans.o_mem_dout    = 'b0;
            trans.o_mem_vld_out = 0;
          end
        end
      end
      
      /*
      $display($realtime, " [MONITOR] [VIF] wr_en=%0d, rd_en=%0d, addr=%0d, din=%0d, dout=%0d, vld=%0d", 
               monit_vif.MONIT.monitor_ckb.i_mem_wen, 
               monit_vif.MONIT.monitor_ckb.i_mem_ren, 
               monit_vif.MONIT.monitor_ckb.i_mem_addr, 
               monit_vif.MONIT.monitor_ckb.i_mem_din, 
               monit_vif.MONIT.monitor_ckb.o_mem_dout,
               monit_vif.MONIT.monitor_ckb.o_mem_vld_out);
      */
      monit2sb.put(trans);
      //monit2ss.put(trans);
    end
  join_none
endtask

endclass