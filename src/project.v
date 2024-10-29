/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_a_0_array_multiplier (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
    wire [3:0] m = ui_in[7:4];
    wire [3:0] q = ui_in[3:0];
    wire [7:0] p;

    wire [3:0] pp0, pp1, pp2, pp3;  
    
    wire s1, s2, s3, s4, s5, s6;
    wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11;

    assign pp0 = m & {4{q[0]}};  
    assign pp1 = m & {4{q[1]}};  
    assign pp2 = m & {4{q[2]}};  
    assign pp3 = m & {4{q[3]}};  

    assign p[0] = pp0[0];

    full_adder fa1 (
        .a(pp0[1]),
        .b(pp1[0]),
        .cin(1'b0),
        .sum(p[1]),
        .cout(c1)
    );
    full_adder fa2 (
        .a(pp0[2]),
        .b(pp1[1]),
        .cin(c1),
        .sum(s1),
        .cout(c2)
    );
    full_adder fa3 (
        .a(pp0[3]),
        .b(pp1[2]),
        .cin(c2),
        .sum(s2),
        .cout(c3)
    );
    full_adder fa4 (
        .a(1'b0),       
        .b(pp1[3]),
        .cin(c3),
        .sum(s3),
        .cout(c4)
    );

    full_adder fa5 (
        .a(s1),
        .b(pp2[0]),
        .cin(1'b0),
        .sum(p[2]),
        .cout(c5)
    );
    full_adder fa6 (
        .a(s2),
        .b(pp2[1]),
        .cin(c5),
        .sum(s4),
        .cout(c6)
    );
    full_adder fa7 (
        .a(s3),
        .b(pp2[2]),
        .cin(c6),
        .sum(s5),
        .cout(c7)
    );
    full_adder fa8 (
        .a(c4),
        .b(pp2[3]),
        .cin(c7),
        .sum(s6),
        .cout(c8)
    );

    full_adder fa9 (
        .a(s4),
        .b(pp3[0]),
        .cin(1'b0),
        .sum(p[3]),
        .cout(c9)
    );
    full_adder fa10 (
        .a(s5),
        .b(pp3[1]),
        .cin(c9),
        .sum(p[4]),
        .cout(c10)
    );
    full_adder fa11 (
        .a(s6),
        .b(pp3[2]),
        .cin(c10),
        .sum(p[5]),
        .cout(c11)
    );
    full_adder fa12 (
        .a(c8),
        .b(pp3[3]),
        .cin(c11),
        .sum(p[6]),
        .cout(p[7])  
    );
  

  assign uo_out = p;
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in,1'b0};

endmodule

module full_adder (
    input a, 
    input b, 
    input cin, 
    output sum, 
    output cout
);
    assign {cout, sum} = a + b  + cin;
endmodule
