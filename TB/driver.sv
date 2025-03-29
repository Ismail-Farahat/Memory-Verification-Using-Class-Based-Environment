//
class driver;
//interface
virtual mem_if drv_vif;

//
mailbox seq2driv;
int transactions_no = 0;

//functions
function new(virtual mem_if drv_vif, mailbox seq2driv);
  this.drv_vif = drv_vif;
  this.seq2driv = seq2driv;
endfunction

//tasks
task reset();
  if(!drv_vif.i_mem_rst_n)
    $display("[DRIVER] RESET Mode Activated");
  wait(drv_vif.i_mem_rst_n) 
    $display("[DRIVER] RESET Mode Deactivated");
endtask

task run();
  $display("--- Driver Starts ...");
  fork
    forever @(posedge drv_vif.DRV.i_mem_clk) begin
      transaction trans;
      trans = new();
      seq2driv.get(trans);
      
      /*
      $display($realtime, " [DRIVER] [TRANS] wr_en=%0d, rd_en=%0d, addr=%0d, din=%0d, dout=%0d, vld=%0d", 
                   trans.i_mem_wen, trans.i_mem_ren, trans.i_mem_addr, 
                   trans.i_mem_din, trans.o_mem_dout, trans.o_mem_vld_out);
      */
     
      if(trans.i_mem_wen || trans.i_mem_ren) begin
        if(trans.i_mem_wen) begin
          drv_vif.DRV.driver_ckb.i_mem_ren  <= trans.i_mem_ren;
          drv_vif.DRV.driver_ckb.i_mem_wen  <= trans.i_mem_wen;
          drv_vif.DRV.driver_ckb.i_mem_addr <= trans.i_mem_addr;
          drv_vif.DRV.driver_ckb.i_mem_din  <= trans.i_mem_din;
        end
        else begin
          drv_vif.DRV.driver_ckb.i_mem_ren  <= trans.i_mem_ren;
          drv_vif.DRV.driver_ckb.i_mem_wen  <= trans.i_mem_wen;
          drv_vif.DRV.driver_ckb.i_mem_addr <= trans.i_mem_addr;
        end
      end
      transactions_no ++;
      //$display("[DRIVER] Number of Transactions = %0d", transactions_no);
    end
  join_none
endtask

endclass