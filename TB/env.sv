//
class env;
//interfaces
virtual mem_if env_vif;

//classes
sequencer #() seq;
driver driv;
monitor monit;
subscriber ss;
scoreboard sb;

mailbox seq2driv;
mailbox monit2sb;
mailbox monit2ss;

//functions
function new(virtual mem_if env_vif);
  this.env_vif = env_vif;
endfunction

//tasks
task build();
  seq2driv = new();
  monit2sb = new();
  monit2ss = new();
  
  seq = new(seq2driv);
  driv = new(env_vif, seq2driv);
  monit = new(env_vif, monit2sb, monit2ss);
  sb = new(monit2sb);
  //ss = new(monit2ss); //NOT Implemented Yet
endtask

task reset();
  driv.reset();
endtask

task run_test();
  fork
    seq.run();
    driv.run();
    monit.run();
    sb.run();
    //sb.display_errors_no();
    //ss.run(); //NOT Implemented Yet
  join
endtask

task finish();
  wait(driv.transactions_no == seq.transactions_no)
  wait(seq.transactions_no == sb.test_no)
  $finish;
endtask

task run();
  reset();
  run_test();
  finish();
endtask

endclass