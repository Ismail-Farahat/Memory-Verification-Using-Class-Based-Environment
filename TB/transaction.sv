//
class transaction;
//

rand logic               i_mem_wen;
rand logic               i_mem_ren;
rand logic   [3  : 0]    i_mem_addr;
rand logic   [31 : 0]    i_mem_din;

logic        [31 : 0]    o_mem_dout;
logic                    o_mem_vld_out;


constraint wr_en_constr { i_mem_wen dist{1:=1, 0:=2}; }
constraint rd_en_constr { i_mem_ren dist{1:=3, 0:=1}; }
constraint wr_rd_constr {
  if(i_mem_wen & i_mem_ren) {
    i_mem_wen == 1;
    i_mem_ren == 0;
  } else {
    i_mem_wen == i_mem_wen;
    i_mem_ren == i_mem_ren;
  }
}




endclass