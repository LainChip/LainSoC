`ifndef __DEBUG_VH
`define __DEBUG_VH

`define DEBUG_W(IN) (*mark_debug="true"*) wire [$bits(IN) - 1:0] _``IN``_DBG = IN;

`endif