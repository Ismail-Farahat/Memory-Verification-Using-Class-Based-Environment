//
class subscriber;
//classes
transaction trans;
mailbox monit2ss;

//functions
function new(mailbox monit2ss);
  this.monit2ss = monit2ss;
endfunction

//tasks
task run();
  $display("--- Subscriber Starts ...");
  trans = new();
  monit2ss.get(trans);
  $display("--- Subscriber Ends ...");
endtask

endclass