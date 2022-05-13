module boundFlasher_tb;
  
  parameter HALF_CYCLE = 5;
  parameter CYCLE = HALF_CYCLE * 2;
  
  reg flick, clk, rst;
  wire [15:0] led;
  
  boundFlasher BF(.flick(flick), .clk(clk), .rst(rst), .led_output(led));
    
  //generate clock
  always begin
    clk = 1'b0;
    #HALF_CYCLE clk = 1'b1;
    #HALF_CYCLE;
  end
  
  initial begin
    rst = 0;
    flick = 0;
    #2 rst = 1;

    // Test case :
    #5 flick = 1;	// Normal flow
    #3 flick = 0;	

    #173 flick = 1; // Flick signal at L5 in state 3
    #3 flick = 0;
    
    #179 flick = 1; // Flick signal at L10 in state 4
    #3 flick = 0;
    
    #266 flick = 1; // Flick signal at L5 in state 5
    #3 flick = 0; 
    
    #580 flick = 1; // restart process
    #3 flick = 0;
    
    #85 flick = 1; // Flick at any time and no change 
    #3 flick = 0;

    #137 flick = 1; // Flick = 1 at L10 in state 4
    #3 flick = 0;

    #197 rst = 1; flick = 1; // Flick and rst at the same time
    #3 flick = 0; rst = 1;

    #22 rst = 0;      // rst and restart process
    #3 rst = 1;
    #5 flick = 1;
    #3 flick = 0;

    #(CYCLE*45) $finish;
  end

initial begin
    $recordfile("waves");
    $recordvars("depth=0", boundFlasher_tb);
end

endmodule