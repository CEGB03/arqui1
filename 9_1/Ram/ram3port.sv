module ram3port #(parameter N = 2, M = 4)
                  (input logic clk,
                  input logic we3,
                  input logic [N-1:0] a1, a2, a3,
                  output logic [M-1:0] d1, d2,
                  input logic [M-1:0] d3);
  
  logic [M-1:0] mem[2**N-1:0];

  always @(posedge clk)
    if (we3) mem[a3] <= d3;

  assign d1 = mem[a1];
  assign d2 = mem[a2];
endmodule
