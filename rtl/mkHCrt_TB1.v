//
// Generated by Bluespec Compiler, version 2013.01.beta5 (build 30325, 2013-01-23)
//
// On Mon Apr 15 15:27:59 EDT 2013
//
// Method conflict info:
// (none)
//
// Ports:
// Name                         I/O  size props
// CLK                            I     1 clock
// RST_N                          I     1 reset
//
// No combinational paths from inputs to outputs
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkHCrt_TB1(CLK,
		  RST_N);
  input  CLK;
  input  RST_N;

  // register cmdCount
  reg [15 : 0] cmdCount;
  wire [15 : 0] cmdCount_D_IN;
  wire cmdCount_EN;

  // register cycleCount
  reg [15 : 0] cycleCount;
  wire [15 : 0] cycleCount_D_IN;
  wire cycleCount_EN;

  // register gcr_ptr
  reg [11 : 0] gcr_ptr;
  wire [11 : 0] gcr_ptr_D_IN;
  wire gcr_ptr_EN;

  // register rDat
  reg [31 : 0] rDat;
  wire [31 : 0] rDat_D_IN;
  wire rDat_EN;

  // register rspCount
  reg [15 : 0] rspCount;
  wire [15 : 0] rspCount_D_IN;
  wire rspCount_EN;

  // register validResp
  reg validResp;
  wire validResp_D_IN, validResp_EN;

  // ports of submodule a4ls
  wire [31 : 0] a4ls_s_axi_araddr,
		a4ls_s_axi_awaddr,
		a4ls_s_axi_rdata,
		a4ls_s_axi_wdata;
  wire [3 : 0] a4ls_s_axi_wstrb;
  wire [2 : 0] a4ls_s_axi_arprot, a4ls_s_axi_awprot;
  wire [1 : 0] a4ls_s_axi_bresp, a4ls_s_axi_rresp;
  wire a4ls_s_axi_arready,
       a4ls_s_axi_arvalid,
       a4ls_s_axi_awready,
       a4ls_s_axi_awvalid,
       a4ls_s_axi_bready,
       a4ls_s_axi_bvalid,
       a4ls_s_axi_rready,
       a4ls_s_axi_rvalid,
       a4ls_s_axi_wready,
       a4ls_s_axi_wvalid;

  // ports of submodule cmdF
  wire [31 : 0] cmdF_D_IN, cmdF_D_OUT;
  wire cmdF_CLR, cmdF_DEQ, cmdF_EMPTY_N, cmdF_ENQ, cmdF_FULL_N;

  // ports of submodule crt2axi
  wire [39 : 0] crt2axi_crtS0_response_get;
  wire [35 : 0] crt2axi_axiM0_wrData_data;
  wire [34 : 0] crt2axi_axiM0_rdAddr_data, crt2axi_axiM0_wrAddr_data;
  wire [33 : 0] crt2axi_axiM0_rdResp_data_value;
  wire [31 : 0] crt2axi_crtS0_request_put;
  wire [1 : 0] crt2axi_axiM0_wrResp_data_value;
  wire crt2axi_EN_crtS0_request_put,
       crt2axi_EN_crtS0_response_get,
       crt2axi_RDY_crtS0_request_put,
       crt2axi_RDY_crtS0_response_get,
       crt2axi_axiM0_rdAddr_ready_value,
       crt2axi_axiM0_rdAddr_valid,
       crt2axi_axiM0_rdResp_ready,
       crt2axi_axiM0_rdResp_valid_value,
       crt2axi_axiM0_wrAddr_ready_value,
       crt2axi_axiM0_wrAddr_valid,
       crt2axi_axiM0_wrData_ready_value,
       crt2axi_axiM0_wrData_valid,
       crt2axi_axiM0_wrResp_ready,
       crt2axi_axiM0_wrResp_valid_value;

  // ports of submodule gcr_cF
  wire [11 : 0] gcr_cF_D_IN;
  wire gcr_cF_CLR, gcr_cF_DEQ, gcr_cF_EMPTY_N, gcr_cF_ENQ, gcr_cF_FULL_N;

  // ports of submodule gcr_xF
  reg [31 : 0] gcr_xF_D_IN;
  wire [31 : 0] gcr_xF_D_OUT;
  wire gcr_xF_CLR, gcr_xF_DEQ, gcr_xF_EMPTY_N, gcr_xF_ENQ, gcr_xF_FULL_N;

  // ports of submodule rspF
  wire [39 : 0] rspF_D_IN, rspF_D_OUT;
  wire rspF_CLR, rspF_DEQ, rspF_EMPTY_N, rspF_ENQ, rspF_FULL_N;

  // rule scheduling signals
  wire CAN_FIRE_RL_a4lm_doAlways,
       CAN_FIRE_RL_advance_cycleCount,
       CAN_FIRE_RL_chomp_rsp,
       CAN_FIRE_RL_doAlways,
       CAN_FIRE_RL_gcr_push_cmd,
       CAN_FIRE_RL_hello,
       CAN_FIRE_RL_mkConnectionGetPut,
       CAN_FIRE_RL_mkConnectionGetPut_1,
       CAN_FIRE_RL_produce_commands,
       CAN_FIRE_RL_terminate,
       CAN_FIRE_RL_trigger_read,
       CAN_FIRE_RL_validResp__dreg_update,
       WILL_FIRE_RL_a4lm_doAlways,
       WILL_FIRE_RL_advance_cycleCount,
       WILL_FIRE_RL_chomp_rsp,
       WILL_FIRE_RL_doAlways,
       WILL_FIRE_RL_gcr_push_cmd,
       WILL_FIRE_RL_hello,
       WILL_FIRE_RL_mkConnectionGetPut,
       WILL_FIRE_RL_mkConnectionGetPut_1,
       WILL_FIRE_RL_produce_commands,
       WILL_FIRE_RL_terminate,
       WILL_FIRE_RL_trigger_read,
       WILL_FIRE_RL_validResp__dreg_update;

  // remaining internal signals
  reg [63 : 0] v__h6670, v__h6712;
  reg [1 : 0] CASE_crt2axicrtS0_response_get_BITS_19_TO_18__ETC__q3,
	      CASE_crt2axicrtS0_response_get_BITS_29_TO_28__ETC__q2,
	      CASE_crt2axicrtS0_response_get_BITS_39_TO_38__ETC__q1,
	      CASE_crt2axicrtS0_response_get_BITS_9_TO_8_0__ETC__q4;

  // submodule a4ls
  mkA4LS #(.hasDebugLogic(1'd1)) a4ls(.s_axi_aclk(CLK),
				      .s_axi_aresetn(RST_N),
				      .s_axi_araddr(a4ls_s_axi_araddr),
				      .s_axi_arprot(a4ls_s_axi_arprot),
				      .s_axi_awaddr(a4ls_s_axi_awaddr),
				      .s_axi_awprot(a4ls_s_axi_awprot),
				      .s_axi_wdata(a4ls_s_axi_wdata),
				      .s_axi_wstrb(a4ls_s_axi_wstrb),
				      .s_axi_awvalid(a4ls_s_axi_awvalid),
				      .s_axi_wvalid(a4ls_s_axi_wvalid),
				      .s_axi_bready(a4ls_s_axi_bready),
				      .s_axi_arvalid(a4ls_s_axi_arvalid),
				      .s_axi_rready(a4ls_s_axi_rready),
				      .s_axi_awready(a4ls_s_axi_awready),
				      .s_axi_wready(a4ls_s_axi_wready),
				      .s_axi_bvalid(a4ls_s_axi_bvalid),
				      .s_axi_bresp(a4ls_s_axi_bresp),
				      .s_axi_arready(a4ls_s_axi_arready),
				      .s_axi_rvalid(a4ls_s_axi_rvalid),
				      .s_axi_rdata(a4ls_s_axi_rdata),
				      .s_axi_rresp(a4ls_s_axi_rresp));

  // submodule cmdF
  FIFO2 #(.width(32'd32), .guarded(32'd1)) cmdF(.RST(RST_N),
						.CLK(CLK),
						.D_IN(cmdF_D_IN),
						.ENQ(cmdF_ENQ),
						.DEQ(cmdF_DEQ),
						.CLR(cmdF_CLR),
						.D_OUT(cmdF_D_OUT),
						.FULL_N(cmdF_FULL_N),
						.EMPTY_N(cmdF_EMPTY_N));

  // submodule crt2axi
  mkHCrtCompleter2Axi crt2axi(.CLK(CLK),
			      .RST_N(RST_N),
			      .axiM0_rdAddr_ready_value(crt2axi_axiM0_rdAddr_ready_value),
			      .axiM0_rdResp_data_value(crt2axi_axiM0_rdResp_data_value),
			      .axiM0_rdResp_valid_value(crt2axi_axiM0_rdResp_valid_value),
			      .axiM0_wrAddr_ready_value(crt2axi_axiM0_wrAddr_ready_value),
			      .axiM0_wrData_ready_value(crt2axi_axiM0_wrData_ready_value),
			      .axiM0_wrResp_data_value(crt2axi_axiM0_wrResp_data_value),
			      .axiM0_wrResp_valid_value(crt2axi_axiM0_wrResp_valid_value),
			      .crtS0_request_put(crt2axi_crtS0_request_put),
			      .EN_crtS0_request_put(crt2axi_EN_crtS0_request_put),
			      .EN_crtS0_response_get(crt2axi_EN_crtS0_response_get),
			      .RDY_crtS0_request_put(crt2axi_RDY_crtS0_request_put),
			      .crtS0_response_get(crt2axi_crtS0_response_get),
			      .RDY_crtS0_response_get(crt2axi_RDY_crtS0_response_get),
			      .axiM0_wrAddr_data(crt2axi_axiM0_wrAddr_data),
			      .axiM0_wrAddr_valid(crt2axi_axiM0_wrAddr_valid),
			      .axiM0_wrData_data(crt2axi_axiM0_wrData_data),
			      .axiM0_wrData_valid(crt2axi_axiM0_wrData_valid),
			      .axiM0_wrResp_ready(crt2axi_axiM0_wrResp_ready),
			      .axiM0_rdAddr_data(crt2axi_axiM0_rdAddr_data),
			      .axiM0_rdAddr_valid(crt2axi_axiM0_rdAddr_valid),
			      .axiM0_rdResp_ready(crt2axi_axiM0_rdResp_ready),
			      .isActive(),
			      .RDY_isActive(),
			      .isFaulted(),
			      .RDY_isFaulted());

  // submodule gcr_cF
  FIFO2 #(.width(32'd12), .guarded(32'd1)) gcr_cF(.RST(RST_N),
						  .CLK(CLK),
						  .D_IN(gcr_cF_D_IN),
						  .ENQ(gcr_cF_ENQ),
						  .DEQ(gcr_cF_DEQ),
						  .CLR(gcr_cF_CLR),
						  .D_OUT(),
						  .FULL_N(gcr_cF_FULL_N),
						  .EMPTY_N(gcr_cF_EMPTY_N));

  // submodule gcr_xF
  FIFO2 #(.width(32'd32), .guarded(32'd1)) gcr_xF(.RST(RST_N),
						  .CLK(CLK),
						  .D_IN(gcr_xF_D_IN),
						  .ENQ(gcr_xF_ENQ),
						  .DEQ(gcr_xF_DEQ),
						  .CLR(gcr_xF_CLR),
						  .D_OUT(gcr_xF_D_OUT),
						  .FULL_N(gcr_xF_FULL_N),
						  .EMPTY_N(gcr_xF_EMPTY_N));

  // submodule rspF
  FIFO2 #(.width(32'd40), .guarded(32'd1)) rspF(.RST(RST_N),
						.CLK(CLK),
						.D_IN(rspF_D_IN),
						.ENQ(rspF_ENQ),
						.DEQ(rspF_DEQ),
						.CLR(rspF_CLR),
						.D_OUT(rspF_D_OUT),
						.FULL_N(rspF_FULL_N),
						.EMPTY_N(rspF_EMPTY_N));

  // rule RL_produce_commands
  assign CAN_FIRE_RL_produce_commands = gcr_xF_EMPTY_N && cmdF_FULL_N ;
  assign WILL_FIRE_RL_produce_commands = CAN_FIRE_RL_produce_commands ;

  // rule RL_mkConnectionGetPut
  assign CAN_FIRE_RL_mkConnectionGetPut =
	     crt2axi_RDY_crtS0_request_put && cmdF_EMPTY_N ;
  assign WILL_FIRE_RL_mkConnectionGetPut = CAN_FIRE_RL_mkConnectionGetPut ;

  // rule RL_mkConnectionGetPut_1
  assign CAN_FIRE_RL_mkConnectionGetPut_1 =
	     crt2axi_RDY_crtS0_response_get && rspF_FULL_N ;
  assign WILL_FIRE_RL_mkConnectionGetPut_1 =
	     CAN_FIRE_RL_mkConnectionGetPut_1 ;

  // rule RL_chomp_rsp
  assign CAN_FIRE_RL_chomp_rsp = rspF_EMPTY_N ;
  assign WILL_FIRE_RL_chomp_rsp = rspF_EMPTY_N ;

  // rule RL_doAlways
  assign CAN_FIRE_RL_doAlways = 1'd1 ;
  assign WILL_FIRE_RL_doAlways = 1'd1 ;

  // rule RL_hello
  assign CAN_FIRE_RL_hello = cycleCount == 16'd0 ;
  assign WILL_FIRE_RL_hello = CAN_FIRE_RL_hello ;

  // rule RL_terminate
  assign CAN_FIRE_RL_terminate = cycleCount == 16'd50 ;
  assign WILL_FIRE_RL_terminate = CAN_FIRE_RL_terminate ;

  // rule RL_a4lm_doAlways
  assign CAN_FIRE_RL_a4lm_doAlways = 1'd1 ;
  assign WILL_FIRE_RL_a4lm_doAlways = 1'd1 ;

  // rule RL_validResp__dreg_update
  assign CAN_FIRE_RL_validResp__dreg_update = 1'd1 ;
  assign WILL_FIRE_RL_validResp__dreg_update = 1'd1 ;

  // rule RL_gcr_push_cmd
  assign CAN_FIRE_RL_gcr_push_cmd = gcr_xF_FULL_N && gcr_cF_EMPTY_N ;
  assign WILL_FIRE_RL_gcr_push_cmd = CAN_FIRE_RL_gcr_push_cmd ;

  // rule RL_trigger_read
  assign CAN_FIRE_RL_trigger_read =
	     cycleCount != 16'd0 && cycleCount != 16'd16 || gcr_cF_FULL_N ;
  assign WILL_FIRE_RL_trigger_read = CAN_FIRE_RL_trigger_read ;

  // rule RL_advance_cycleCount
  assign CAN_FIRE_RL_advance_cycleCount = 1'd1 ;
  assign WILL_FIRE_RL_advance_cycleCount = 1'd1 ;

  // register cmdCount
  assign cmdCount_D_IN = cmdCount + 16'd1 ;
  assign cmdCount_EN = CAN_FIRE_RL_produce_commands ;

  // register cycleCount
  assign cycleCount_D_IN = cycleCount + 16'd1 ;
  assign cycleCount_EN = 1'd1 ;

  // register gcr_ptr
  assign gcr_ptr_D_IN = (gcr_ptr == 12'd1) ? 12'd0 : gcr_ptr + 12'd1 ;
  assign gcr_ptr_EN = CAN_FIRE_RL_gcr_push_cmd ;

  // register rDat
  assign rDat_D_IN =
	     { rspF_D_OUT[37:30],
	       rspF_D_OUT[27:20],
	       rspF_D_OUT[17:10],
	       rspF_D_OUT[7:0] } ;
  assign rDat_EN = rspF_EMPTY_N ;

  // register rspCount
  assign rspCount_D_IN = rspCount + 16'd1 ;
  assign rspCount_EN = rspF_EMPTY_N ;

  // register validResp
  assign validResp_D_IN = rspF_EMPTY_N ;
  assign validResp_EN = 1'd1 ;

  // submodule a4ls
  assign a4ls_s_axi_araddr = crt2axi_axiM0_rdAddr_data[31:0] ;
  assign a4ls_s_axi_arprot = crt2axi_axiM0_rdAddr_data[34:32] ;
  assign a4ls_s_axi_awaddr = crt2axi_axiM0_wrAddr_data[31:0] ;
  assign a4ls_s_axi_awprot = crt2axi_axiM0_wrAddr_data[34:32] ;
  assign a4ls_s_axi_wdata = crt2axi_axiM0_wrData_data[31:0] ;
  assign a4ls_s_axi_wstrb = crt2axi_axiM0_wrData_data[35:32] ;
  assign a4ls_s_axi_awvalid = crt2axi_axiM0_wrAddr_valid ;
  assign a4ls_s_axi_wvalid = crt2axi_axiM0_wrData_valid ;
  assign a4ls_s_axi_bready = crt2axi_axiM0_wrResp_ready ;
  assign a4ls_s_axi_arvalid = crt2axi_axiM0_rdAddr_valid ;
  assign a4ls_s_axi_rready = crt2axi_axiM0_rdResp_ready ;

  // submodule cmdF
  assign cmdF_D_IN = gcr_xF_D_OUT ;
  assign cmdF_ENQ = CAN_FIRE_RL_produce_commands ;
  assign cmdF_DEQ = CAN_FIRE_RL_mkConnectionGetPut ;
  assign cmdF_CLR = 1'b0 ;

  // submodule crt2axi
  assign crt2axi_axiM0_rdAddr_ready_value = a4ls_s_axi_arready ;
  assign crt2axi_axiM0_rdResp_data_value =
	     { a4ls_s_axi_rresp, a4ls_s_axi_rdata } ;
  assign crt2axi_axiM0_rdResp_valid_value = a4ls_s_axi_rvalid ;
  assign crt2axi_axiM0_wrAddr_ready_value = a4ls_s_axi_awready ;
  assign crt2axi_axiM0_wrData_ready_value = a4ls_s_axi_wready ;
  assign crt2axi_axiM0_wrResp_data_value = a4ls_s_axi_bresp ;
  assign crt2axi_axiM0_wrResp_valid_value = a4ls_s_axi_bvalid ;
  assign crt2axi_crtS0_request_put = cmdF_D_OUT ;
  assign crt2axi_EN_crtS0_request_put = CAN_FIRE_RL_mkConnectionGetPut ;
  assign crt2axi_EN_crtS0_response_get = CAN_FIRE_RL_mkConnectionGetPut_1 ;

  // submodule gcr_cF
  assign gcr_cF_D_IN = 12'b101010101010 /* unspecified value */  ;
  assign gcr_cF_ENQ =
	     WILL_FIRE_RL_trigger_read &&
	     (cycleCount == 16'd0 || cycleCount == 16'd16) ;
  assign gcr_cF_DEQ = WILL_FIRE_RL_gcr_push_cmd && gcr_ptr == 12'd1 ;
  assign gcr_cF_CLR = 1'b0 ;

  // submodule gcr_xF
  always@(gcr_ptr)
  begin
    case (gcr_ptr)
      12'd0: gcr_xF_D_IN = 32'h8003FFA0;
      12'd1: gcr_xF_D_IN = 32'h00000010;
      default: gcr_xF_D_IN = 32'hAAAAAAAA /* unspecified value */ ;
    endcase
  end
  assign gcr_xF_ENQ = CAN_FIRE_RL_gcr_push_cmd ;
  assign gcr_xF_DEQ = CAN_FIRE_RL_produce_commands ;
  assign gcr_xF_CLR = 1'b0 ;

  // submodule rspF
  assign rspF_D_IN =
	     { CASE_crt2axicrtS0_response_get_BITS_39_TO_38__ETC__q1,
	       crt2axi_crtS0_response_get[37:30],
	       CASE_crt2axicrtS0_response_get_BITS_29_TO_28__ETC__q2,
	       crt2axi_crtS0_response_get[27:20],
	       CASE_crt2axicrtS0_response_get_BITS_19_TO_18__ETC__q3,
	       crt2axi_crtS0_response_get[17:10],
	       CASE_crt2axicrtS0_response_get_BITS_9_TO_8_0__ETC__q4,
	       crt2axi_crtS0_response_get[7:0] } ;
  assign rspF_ENQ = CAN_FIRE_RL_mkConnectionGetPut_1 ;
  assign rspF_DEQ = rspF_EMPTY_N ;
  assign rspF_CLR = 1'b0 ;

  // remaining internal signals
  always@(crt2axi_crtS0_response_get)
  begin
    case (crt2axi_crtS0_response_get[39:38])
      2'd0, 2'd1, 2'd2:
	  CASE_crt2axicrtS0_response_get_BITS_39_TO_38__ETC__q1 =
	      crt2axi_crtS0_response_get[39:38];
      2'd3: CASE_crt2axicrtS0_response_get_BITS_39_TO_38__ETC__q1 = 2'd3;
    endcase
  end
  always@(crt2axi_crtS0_response_get)
  begin
    case (crt2axi_crtS0_response_get[29:28])
      2'd0, 2'd1, 2'd2:
	  CASE_crt2axicrtS0_response_get_BITS_29_TO_28__ETC__q2 =
	      crt2axi_crtS0_response_get[29:28];
      2'd3: CASE_crt2axicrtS0_response_get_BITS_29_TO_28__ETC__q2 = 2'd3;
    endcase
  end
  always@(crt2axi_crtS0_response_get)
  begin
    case (crt2axi_crtS0_response_get[19:18])
      2'd0, 2'd1, 2'd2:
	  CASE_crt2axicrtS0_response_get_BITS_19_TO_18__ETC__q3 =
	      crt2axi_crtS0_response_get[19:18];
      2'd3: CASE_crt2axicrtS0_response_get_BITS_19_TO_18__ETC__q3 = 2'd3;
    endcase
  end
  always@(crt2axi_crtS0_response_get)
  begin
    case (crt2axi_crtS0_response_get[9:8])
      2'd0, 2'd1, 2'd2:
	  CASE_crt2axicrtS0_response_get_BITS_9_TO_8_0__ETC__q4 =
	      crt2axi_crtS0_response_get[9:8];
      2'd3: CASE_crt2axicrtS0_response_get_BITS_9_TO_8_0__ETC__q4 = 2'd3;
    endcase
  end

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        cmdCount <= `BSV_ASSIGNMENT_DELAY 16'd0;
	cycleCount <= `BSV_ASSIGNMENT_DELAY 16'd0;
	gcr_ptr <= `BSV_ASSIGNMENT_DELAY 12'd0;
	rspCount <= `BSV_ASSIGNMENT_DELAY 16'd0;
	validResp <= `BSV_ASSIGNMENT_DELAY 1'd0;
      end
    else
      begin
        if (cmdCount_EN) cmdCount <= `BSV_ASSIGNMENT_DELAY cmdCount_D_IN;
	if (cycleCount_EN)
	  cycleCount <= `BSV_ASSIGNMENT_DELAY cycleCount_D_IN;
	if (gcr_ptr_EN) gcr_ptr <= `BSV_ASSIGNMENT_DELAY gcr_ptr_D_IN;
	if (rspCount_EN) rspCount <= `BSV_ASSIGNMENT_DELAY rspCount_D_IN;
	if (validResp_EN) validResp <= `BSV_ASSIGNMENT_DELAY validResp_D_IN;
      end
    if (rDat_EN) rDat <= `BSV_ASSIGNMENT_DELAY rDat_D_IN;
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    cmdCount = 16'hAAAA;
    cycleCount = 16'hAAAA;
    gcr_ptr = 12'hAAA;
    rDat = 32'hAAAAAAAA;
    rspCount = 16'hAAAA;
    validResp = 1'h0;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_hello)
	begin
	  v__h6670 = $time;
	  #0;
	end
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_hello)
	$display("[%0d]: %m: Starting HCrt_TB1 Completion Logic testing in cycle:%0d",
		 v__h6670,
		 $unsigned(cycleCount));
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_terminate)
	begin
	  v__h6712 = $time;
	  #0;
	end
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_terminate)
	$display("[%0d]: %m: Terminate rule fired in cycle:%0d",
		 v__h6712,
		 $unsigned(cycleCount));
    if (RST_N != `BSV_RESET_VALUE) if (WILL_FIRE_RL_terminate) $finish(32'd1);
  end
  // synopsys translate_on
endmodule  // mkHCrt_TB1

