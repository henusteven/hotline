//
// Generated by Bluespec Compiler, version 2013.01.beta5 (build 30325, 2013-01-23)
//
// On Sat Mar  2 13:25:55 EST 2013
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

  // register consumeCnt
  reg [15 : 0] consumeCnt;
  wire [15 : 0] consumeCnt_D_IN;
  wire consumeCnt_EN;

  // register cycleCount
  reg [15 : 0] cycleCount;
  wire [15 : 0] cycleCount_D_IN;
  wire cycleCount_EN;

  // register gpDA
  reg [47 : 0] gpDA;
  wire [47 : 0] gpDA_D_IN;
  wire gpDA_EN;

  // register gpL2Hdr
  reg gpL2Hdr;
  wire gpL2Hdr_D_IN, gpL2Hdr_EN;

  // register gpPDU
  reg gpPDU;
  wire gpPDU_D_IN, gpPDU_EN;

  // register gpPtr
  reg [3 : 0] gpPtr;
  wire [3 : 0] gpPtr_D_IN;
  wire gpPtr_EN;

  // register gpSA
  reg [47 : 0] gpSA;
  wire [47 : 0] gpSA_D_IN;
  wire gpSA_EN;

  // register gqPtr
  reg [3 : 0] gqPtr;
  wire [3 : 0] gqPtr_D_IN;
  wire gqPtr_EN;

  // register l2qc_ptr
  reg [1 : 0] l2qc_ptr;
  wire [1 : 0] l2qc_ptr_D_IN;
  wire l2qc_ptr_EN;

  // register l2qc_sr
  reg [29 : 0] l2qc_sr;
  wire [29 : 0] l2qc_sr_D_IN;
  wire l2qc_sr_EN;

  // register qcl2_ptr
  reg [1 : 0] qcl2_ptr;
  wire [1 : 0] qcl2_ptr_D_IN;
  wire qcl2_ptr_EN;

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

  // ports of submodule l2ConsumeF
  wire [9 : 0] l2ConsumeF_D_IN;
  wire l2ConsumeF_CLR,
       l2ConsumeF_DEQ,
       l2ConsumeF_EMPTY_N,
       l2ConsumeF_ENQ,
       l2ConsumeF_FULL_N;

  // ports of submodule l2GenF
  wire [9 : 0] l2GenF_D_IN, l2GenF_D_OUT;
  wire l2GenF_CLR, l2GenF_DEQ, l2GenF_EMPTY_N, l2GenF_ENQ, l2GenF_FULL_N;

  // ports of submodule l2P
  wire [47 : 0] l2P_macAddr_u;
  wire [9 : 0] l2P_client_request_get,
	       l2P_client_response_put,
	       l2P_server_request_put,
	       l2P_server_response_get;
  wire l2P_EN_client_request_get,
       l2P_EN_client_response_put,
       l2P_EN_macAddr,
       l2P_EN_server_request_put,
       l2P_EN_server_response_get,
       l2P_RDY_client_request_get,
       l2P_RDY_client_response_put,
       l2P_RDY_server_request_put,
       l2P_RDY_server_response_get;

  // ports of submodule l2qc_inF
  wire [9 : 0] l2qc_inF_D_IN, l2qc_inF_D_OUT;
  wire l2qc_inF_CLR,
       l2qc_inF_DEQ,
       l2qc_inF_EMPTY_N,
       l2qc_inF_ENQ,
       l2qc_inF_FULL_N;

  // ports of submodule l2qc_outF
  wire [39 : 0] l2qc_outF_D_IN, l2qc_outF_D_OUT;
  wire l2qc_outF_CLR,
       l2qc_outF_DEQ,
       l2qc_outF_EMPTY_N,
       l2qc_outF_ENQ,
       l2qc_outF_FULL_N;

  // ports of submodule qcl2_inF
  wire [39 : 0] qcl2_inF_D_IN, qcl2_inF_D_OUT;
  wire qcl2_inF_CLR,
       qcl2_inF_DEQ,
       qcl2_inF_EMPTY_N,
       qcl2_inF_ENQ,
       qcl2_inF_FULL_N;

  // ports of submodule qcl2_outF
  wire [9 : 0] qcl2_outF_D_IN, qcl2_outF_D_OUT;
  wire qcl2_outF_CLR,
       qcl2_outF_DEQ,
       qcl2_outF_EMPTY_N,
       qcl2_outF_ENQ,
       qcl2_outF_FULL_N;

  // rule scheduling signals
  wire CAN_FIRE_RL_a4lm_doAlways,
       CAN_FIRE_RL_advance_cycleCount,
       CAN_FIRE_RL_chomp_l2,
       CAN_FIRE_RL_doAlways,
       CAN_FIRE_RL_l2_gen_header,
       CAN_FIRE_RL_l2_gen_payload,
       CAN_FIRE_RL_l2qc_unfunnel,
       CAN_FIRE_RL_mkConnectionGetPut,
       CAN_FIRE_RL_mkConnectionGetPut_1,
       CAN_FIRE_RL_mkConnectionGetPut_2,
       CAN_FIRE_RL_mkConnectionGetPut_3,
       CAN_FIRE_RL_mkConnectionGetPut_4,
       CAN_FIRE_RL_mkConnectionGetPut_5,
       CAN_FIRE_RL_qcl2_funnel,
       CAN_FIRE_RL_terminate,
       WILL_FIRE_RL_a4lm_doAlways,
       WILL_FIRE_RL_advance_cycleCount,
       WILL_FIRE_RL_chomp_l2,
       WILL_FIRE_RL_doAlways,
       WILL_FIRE_RL_l2_gen_header,
       WILL_FIRE_RL_l2_gen_payload,
       WILL_FIRE_RL_l2qc_unfunnel,
       WILL_FIRE_RL_mkConnectionGetPut,
       WILL_FIRE_RL_mkConnectionGetPut_1,
       WILL_FIRE_RL_mkConnectionGetPut_2,
       WILL_FIRE_RL_mkConnectionGetPut_3,
       WILL_FIRE_RL_mkConnectionGetPut_4,
       WILL_FIRE_RL_mkConnectionGetPut_5,
       WILL_FIRE_RL_qcl2_funnel,
       WILL_FIRE_RL_terminate;

  // inputs to muxes for submodule ports
  reg [9 : 0] MUX_l2GenF_enq_1__VAL_1, MUX_l2GenF_enq_1__VAL_2;
  wire MUX_gpPDU_write_1__SEL_1, MUX_l2GenF_enq_1__SEL_1;

  // remaining internal signals
  reg [63 : 0] v__h16079;
  reg [7 : 0] SEL_ARR_qcl2_inF_first__64_BITS_7_TO_0_78_qcl2_ETC___d283;
  reg [1 : 0] CASE_crt2axicrtS0_response_get_BITS_19_TO_18__ETC__q15,
	      CASE_crt2axicrtS0_response_get_BITS_29_TO_28__ETC__q14,
	      CASE_crt2axicrtS0_response_get_BITS_39_TO_38__ETC__q13,
	      CASE_crt2axicrtS0_response_get_BITS_9_TO_8_0__ETC__q16,
	      CASE_l2GenFD_OUT_BITS_9_TO_8_0_l2GenFD_OUT_B_ETC__q10,
	      CASE_l2Pclient_request_get_BITS_9_TO_8_0_l2P_ETC__q11,
	      CASE_l2Pserver_response_get_BITS_9_TO_8_0_l2P_ETC__q8,
	      CASE_l2qc_inFD_OUT_BITS_9_TO_8_0_l2qc_inFD_O_ETC__q1,
	      CASE_l2qc_sr_BITS_19_TO_18_0_l2qc_sr_BITS_19_T_ETC__q3,
	      CASE_l2qc_sr_BITS_29_TO_28_0_l2qc_sr_BITS_29_T_ETC__q12,
	      CASE_l2qc_sr_BITS_9_TO_8_0_l2qc_sr_BITS_9_TO_8_ETC__q2,
	      CASE_qcl2_outFD_OUT_BITS_9_TO_8_0_qcl2_outFD_ETC__q9;
  reg CASE_gpPtr_1_l2GenFFULL_N_2_l2GenFFULL_N_3_l_ETC__q6,
      CASE_gqPtr_0_l2GenFFULL_N_1_l2GenFFULL_N_2_l_ETC__q7,
      CASE_qcl2_ptr_0_qcl2_inFD_OUT_BITS_9_TO_8_EQ__ETC__q4,
      CASE_qcl2_ptr_0_qcl2_inFD_OUT_BITS_9_TO_8_EQ__ETC__q5,
      SEL_ARR_qcl2_inF_first__64_BITS_9_TO_8_65_EQ_0_ETC___d275;
  wire [9 : 0] IF_SEL_ARR_qcl2_inF_first__64_BITS_9_TO_8_65_E_ETC___d299,
	       IF_SEL_ARR_qcl2_inF_first__64_BITS_9_TO_8_65_E_ETC___d300,
	       IF_l2qc_inF_first__60_BITS_9_TO_8_61_EQ_0_62_O_ETC___d198,
	       IF_l2qc_sr_67_BITS_19_TO_18_68_EQ_0_69_OR_l2qc_ETC___d178,
	       IF_l2qc_sr_67_BITS_9_TO_8_79_EQ_0_80_OR_l2qc_s_ETC___d189;

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

  // submodule l2ConsumeF
  FIFO2 #(.width(32'd10), .guarded(32'd1)) l2ConsumeF(.RST(RST_N),
						      .CLK(CLK),
						      .D_IN(l2ConsumeF_D_IN),
						      .ENQ(l2ConsumeF_ENQ),
						      .DEQ(l2ConsumeF_DEQ),
						      .CLR(l2ConsumeF_CLR),
						      .D_OUT(),
						      .FULL_N(l2ConsumeF_FULL_N),
						      .EMPTY_N(l2ConsumeF_EMPTY_N));

  // submodule l2GenF
  FIFO2 #(.width(32'd10), .guarded(32'd1)) l2GenF(.RST(RST_N),
						  .CLK(CLK),
						  .D_IN(l2GenF_D_IN),
						  .ENQ(l2GenF_ENQ),
						  .DEQ(l2GenF_DEQ),
						  .CLR(l2GenF_CLR),
						  .D_OUT(l2GenF_D_OUT),
						  .FULL_N(l2GenF_FULL_N),
						  .EMPTY_N(l2GenF_EMPTY_N));

  // submodule l2P
  mkL2Proc l2P(.CLK(CLK),
	       .RST_N(RST_N),
	       .client_response_put(l2P_client_response_put),
	       .macAddr_u(l2P_macAddr_u),
	       .server_request_put(l2P_server_request_put),
	       .EN_server_request_put(l2P_EN_server_request_put),
	       .EN_server_response_get(l2P_EN_server_response_get),
	       .EN_client_request_get(l2P_EN_client_request_get),
	       .EN_client_response_put(l2P_EN_client_response_put),
	       .EN_macAddr(l2P_EN_macAddr),
	       .RDY_server_request_put(l2P_RDY_server_request_put),
	       .server_response_get(l2P_server_response_get),
	       .RDY_server_response_get(l2P_RDY_server_response_get),
	       .client_request_get(l2P_client_request_get),
	       .RDY_client_request_get(l2P_RDY_client_request_get),
	       .RDY_client_response_put(l2P_RDY_client_response_put),
	       .RDY_macAddr(),
	       .l2Rx(),
	       .RDY_l2Rx(),
	       .l2Tx(),
	       .RDY_l2Tx());

  // submodule l2qc_inF
  FIFO2 #(.width(32'd10), .guarded(32'd1)) l2qc_inF(.RST(RST_N),
						    .CLK(CLK),
						    .D_IN(l2qc_inF_D_IN),
						    .ENQ(l2qc_inF_ENQ),
						    .DEQ(l2qc_inF_DEQ),
						    .CLR(l2qc_inF_CLR),
						    .D_OUT(l2qc_inF_D_OUT),
						    .FULL_N(l2qc_inF_FULL_N),
						    .EMPTY_N(l2qc_inF_EMPTY_N));

  // submodule l2qc_outF
  FIFO2 #(.width(32'd40), .guarded(32'd1)) l2qc_outF(.RST(RST_N),
						     .CLK(CLK),
						     .D_IN(l2qc_outF_D_IN),
						     .ENQ(l2qc_outF_ENQ),
						     .DEQ(l2qc_outF_DEQ),
						     .CLR(l2qc_outF_CLR),
						     .D_OUT(l2qc_outF_D_OUT),
						     .FULL_N(l2qc_outF_FULL_N),
						     .EMPTY_N(l2qc_outF_EMPTY_N));

  // submodule qcl2_inF
  FIFO2 #(.width(32'd40), .guarded(32'd1)) qcl2_inF(.RST(RST_N),
						    .CLK(CLK),
						    .D_IN(qcl2_inF_D_IN),
						    .ENQ(qcl2_inF_ENQ),
						    .DEQ(qcl2_inF_DEQ),
						    .CLR(qcl2_inF_CLR),
						    .D_OUT(qcl2_inF_D_OUT),
						    .FULL_N(qcl2_inF_FULL_N),
						    .EMPTY_N(qcl2_inF_EMPTY_N));

  // submodule qcl2_outF
  FIFO2 #(.width(32'd10), .guarded(32'd1)) qcl2_outF(.RST(RST_N),
						     .CLK(CLK),
						     .D_IN(qcl2_outF_D_IN),
						     .ENQ(qcl2_outF_ENQ),
						     .DEQ(qcl2_outF_DEQ),
						     .CLR(qcl2_outF_CLR),
						     .D_OUT(qcl2_outF_D_OUT),
						     .FULL_N(qcl2_outF_FULL_N),
						     .EMPTY_N(qcl2_outF_EMPTY_N));

  // rule RL_l2_gen_header
  assign CAN_FIRE_RL_l2_gen_header =
	     (gpPtr != 4'd13 || l2GenF_FULL_N) &&
	     CASE_gpPtr_1_l2GenFFULL_N_2_l2GenFFULL_N_3_l_ETC__q6 &&
	     gpPtr != 4'd15 &&
	     !gpPDU ;
  assign WILL_FIRE_RL_l2_gen_header = CAN_FIRE_RL_l2_gen_header ;

  // rule RL_l2_gen_payload
  assign CAN_FIRE_RL_l2_gen_payload =
	     CASE_gqPtr_0_l2GenFFULL_N_1_l2GenFFULL_N_2_l_ETC__q7 &&
	     gqPtr != 4'd15 &&
	     gpPDU ;
  assign WILL_FIRE_RL_l2_gen_payload = CAN_FIRE_RL_l2_gen_payload ;

  // rule RL_mkConnectionGetPut
  assign CAN_FIRE_RL_mkConnectionGetPut =
	     l2P_RDY_server_request_put && l2GenF_EMPTY_N ;
  assign WILL_FIRE_RL_mkConnectionGetPut = CAN_FIRE_RL_mkConnectionGetPut ;

  // rule RL_mkConnectionGetPut_1
  assign CAN_FIRE_RL_mkConnectionGetPut_1 =
	     l2P_RDY_client_request_get && l2qc_inF_FULL_N ;
  assign WILL_FIRE_RL_mkConnectionGetPut_1 =
	     CAN_FIRE_RL_mkConnectionGetPut_1 ;

  // rule RL_mkConnectionGetPut_2
  assign CAN_FIRE_RL_mkConnectionGetPut_2 =
	     crt2axi_RDY_crtS0_request_put && l2qc_outF_EMPTY_N ;
  assign WILL_FIRE_RL_mkConnectionGetPut_2 =
	     CAN_FIRE_RL_mkConnectionGetPut_2 ;

  // rule RL_mkConnectionGetPut_3
  assign CAN_FIRE_RL_mkConnectionGetPut_3 =
	     crt2axi_RDY_crtS0_response_get && qcl2_inF_FULL_N ;
  assign WILL_FIRE_RL_mkConnectionGetPut_3 =
	     CAN_FIRE_RL_mkConnectionGetPut_3 ;

  // rule RL_mkConnectionGetPut_4
  assign CAN_FIRE_RL_mkConnectionGetPut_4 =
	     l2P_RDY_client_response_put && qcl2_outF_EMPTY_N ;
  assign WILL_FIRE_RL_mkConnectionGetPut_4 =
	     CAN_FIRE_RL_mkConnectionGetPut_4 ;

  // rule RL_mkConnectionGetPut_5
  assign CAN_FIRE_RL_mkConnectionGetPut_5 =
	     l2P_RDY_server_response_get && l2ConsumeF_FULL_N ;
  assign WILL_FIRE_RL_mkConnectionGetPut_5 =
	     CAN_FIRE_RL_mkConnectionGetPut_5 ;

  // rule RL_chomp_l2
  assign CAN_FIRE_RL_chomp_l2 = l2ConsumeF_EMPTY_N ;
  assign WILL_FIRE_RL_chomp_l2 = l2ConsumeF_EMPTY_N ;

  // rule RL_doAlways
  assign CAN_FIRE_RL_doAlways = 1'd1 ;
  assign WILL_FIRE_RL_doAlways = 1'd1 ;

  // rule RL_terminate
  assign CAN_FIRE_RL_terminate = cycleCount == 16'd400 ;
  assign WILL_FIRE_RL_terminate = CAN_FIRE_RL_terminate ;

  // rule RL_advance_cycleCount
  assign CAN_FIRE_RL_advance_cycleCount = 1'd1 ;
  assign WILL_FIRE_RL_advance_cycleCount = 1'd1 ;

  // rule RL_a4lm_doAlways
  assign CAN_FIRE_RL_a4lm_doAlways = 1'd1 ;
  assign WILL_FIRE_RL_a4lm_doAlways = 1'd1 ;

  // rule RL_l2qc_unfunnel
  assign CAN_FIRE_RL_l2qc_unfunnel =
	     l2qc_inF_EMPTY_N &&
	     (l2qc_ptr != 2'd3 && l2qc_inF_D_OUT[9:8] == 2'd0 ||
	      l2qc_outF_FULL_N) ;
  assign WILL_FIRE_RL_l2qc_unfunnel = CAN_FIRE_RL_l2qc_unfunnel ;

  // rule RL_qcl2_funnel
  assign CAN_FIRE_RL_qcl2_funnel = qcl2_inF_EMPTY_N && qcl2_outF_FULL_N ;
  assign WILL_FIRE_RL_qcl2_funnel = CAN_FIRE_RL_qcl2_funnel ;

  // inputs to muxes for submodule ports
  assign MUX_gpPDU_write_1__SEL_1 =
	     WILL_FIRE_RL_l2_gen_header && gpPtr == 4'd14 ;
  assign MUX_l2GenF_enq_1__SEL_1 =
	     WILL_FIRE_RL_l2_gen_header &&
	     (gpPtr == 4'd1 || gpPtr == 4'd2 || gpPtr == 4'd3 ||
	      gpPtr == 4'd4 ||
	      gpPtr == 4'd5 ||
	      gpPtr == 4'd6 ||
	      gpPtr == 4'd7 ||
	      gpPtr == 4'd8 ||
	      gpPtr == 4'd9 ||
	      gpPtr == 4'd10 ||
	      gpPtr == 4'd11 ||
	      gpPtr == 4'd12 ||
	      gpPtr == 4'd13 ||
	      gpPtr == 4'd14) ;
  always@(gpPtr or gpDA or gpSA)
  begin
    case (gpPtr)
      4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6:
	  MUX_l2GenF_enq_1__VAL_1 = { 2'd0, gpDA[47:40] };
      4'd7, 4'd8, 4'd9, 4'd10, 4'd11, 4'd12:
	  MUX_l2GenF_enq_1__VAL_1 = { 2'd0, gpSA[47:40] };
      4'd13: MUX_l2GenF_enq_1__VAL_1 = 10'd240;
      default: MUX_l2GenF_enq_1__VAL_1 = 10'd82;
    endcase
  end
  always@(gqPtr)
  begin
    case (gqPtr)
      4'd0: MUX_l2GenF_enq_1__VAL_2 = 10'd160;
      4'd1: MUX_l2GenF_enq_1__VAL_2 = 10'd255;
      4'd2: MUX_l2GenF_enq_1__VAL_2 = 10'd1;
      4'd3: MUX_l2GenF_enq_1__VAL_2 = 10'd128;
      4'd4: MUX_l2GenF_enq_1__VAL_2 = 10'd16;
      4'd5, 4'd6: MUX_l2GenF_enq_1__VAL_2 = 10'd0;
      default: MUX_l2GenF_enq_1__VAL_2 = 10'd256;
    endcase
  end

  // register consumeCnt
  assign consumeCnt_D_IN = consumeCnt + 16'd1 ;
  assign consumeCnt_EN = l2ConsumeF_EMPTY_N ;

  // register cycleCount
  assign cycleCount_D_IN = cycleCount + 16'd1 ;
  assign cycleCount_EN = 1'd1 ;

  // register gpDA
  assign gpDA_D_IN =
	     (gpPtr == 4'd0) ?
	       48'h000A35026080 :
	       { gpDA[39:0], gpDA[47:40] } ;
  assign gpDA_EN =
	     WILL_FIRE_RL_l2_gen_header &&
	     (gpPtr == 4'd0 || gpPtr == 4'd1 || gpPtr == 4'd2 ||
	      gpPtr == 4'd3 ||
	      gpPtr == 4'd4 ||
	      gpPtr == 4'd5 ||
	      gpPtr == 4'd6) ;

  // register gpL2Hdr
  assign gpL2Hdr_D_IN = 1'b0 ;
  assign gpL2Hdr_EN = 1'b0 ;

  // register gpPDU
  assign gpPDU_D_IN = MUX_gpPDU_write_1__SEL_1 ;
  assign gpPDU_EN =
	     WILL_FIRE_RL_l2_gen_header && gpPtr == 4'd14 ||
	     WILL_FIRE_RL_l2_gen_payload && gqPtr == 4'd14 ;

  // register gpPtr
  assign gpPtr_D_IN = (gpPtr == 4'd14) ? 4'd0 : gpPtr + 4'd1 ;
  assign gpPtr_EN = CAN_FIRE_RL_l2_gen_header ;

  // register gpSA
  assign gpSA_D_IN =
	     (gpPtr == 4'd0) ?
	       48'hA036FA253EA5 :
	       { gpSA[39:0], gpSA[47:40] } ;
  assign gpSA_EN =
	     WILL_FIRE_RL_l2_gen_header &&
	     (gpPtr == 4'd0 || gpPtr == 4'd7 || gpPtr == 4'd8 ||
	      gpPtr == 4'd9 ||
	      gpPtr == 4'd10 ||
	      gpPtr == 4'd11 ||
	      gpPtr == 4'd12) ;

  // register gqPtr
  assign gqPtr_D_IN = (gqPtr == 4'd14) ? 4'd0 : gqPtr + 4'd1 ;
  assign gqPtr_EN = CAN_FIRE_RL_l2_gen_payload ;

  // register l2qc_ptr
  assign l2qc_ptr_D_IN =
	     (l2qc_inF_D_OUT[9:8] == 2'd0) ? l2qc_ptr + 2'd1 : 2'd0 ;
  assign l2qc_ptr_EN = CAN_FIRE_RL_l2qc_unfunnel ;

  // register l2qc_sr
  assign l2qc_sr_D_IN =
	     { IF_l2qc_sr_67_BITS_19_TO_18_68_EQ_0_69_OR_l2qc_ETC___d178,
	       IF_l2qc_sr_67_BITS_9_TO_8_79_EQ_0_80_OR_l2qc_s_ETC___d189,
	       IF_l2qc_inF_first__60_BITS_9_TO_8_61_EQ_0_62_O_ETC___d198 } ;
  assign l2qc_sr_EN = CAN_FIRE_RL_l2qc_unfunnel ;

  // register qcl2_ptr
  assign qcl2_ptr_D_IN =
	     SEL_ARR_qcl2_inF_first__64_BITS_9_TO_8_65_EQ_0_ETC___d275 ?
	       qcl2_ptr + 2'd1 :
	       2'd0 ;
  assign qcl2_ptr_EN = CAN_FIRE_RL_qcl2_funnel ;

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

  // submodule crt2axi
  assign crt2axi_axiM0_rdAddr_ready_value = a4ls_s_axi_arready ;
  assign crt2axi_axiM0_rdResp_data_value =
	     { a4ls_s_axi_rresp, a4ls_s_axi_rdata } ;
  assign crt2axi_axiM0_rdResp_valid_value = a4ls_s_axi_rvalid ;
  assign crt2axi_axiM0_wrAddr_ready_value = a4ls_s_axi_awready ;
  assign crt2axi_axiM0_wrData_ready_value = a4ls_s_axi_wready ;
  assign crt2axi_axiM0_wrResp_data_value = a4ls_s_axi_bresp ;
  assign crt2axi_axiM0_wrResp_valid_value = a4ls_s_axi_bvalid ;
  assign crt2axi_crtS0_request_put =
	     { l2qc_outF_D_OUT[37:30],
	       l2qc_outF_D_OUT[27:20],
	       l2qc_outF_D_OUT[17:10],
	       l2qc_outF_D_OUT[7:0] } ;
  assign crt2axi_EN_crtS0_request_put = CAN_FIRE_RL_mkConnectionGetPut_2 ;
  assign crt2axi_EN_crtS0_response_get = CAN_FIRE_RL_mkConnectionGetPut_3 ;

  // submodule l2ConsumeF
  assign l2ConsumeF_D_IN =
	     { CASE_l2Pserver_response_get_BITS_9_TO_8_0_l2P_ETC__q8,
	       l2P_server_response_get[7:0] } ;
  assign l2ConsumeF_ENQ = CAN_FIRE_RL_mkConnectionGetPut_5 ;
  assign l2ConsumeF_DEQ = l2ConsumeF_EMPTY_N ;
  assign l2ConsumeF_CLR = 1'b0 ;

  // submodule l2GenF
  assign l2GenF_D_IN =
	     MUX_l2GenF_enq_1__SEL_1 ?
	       MUX_l2GenF_enq_1__VAL_1 :
	       MUX_l2GenF_enq_1__VAL_2 ;
  assign l2GenF_ENQ =
	     WILL_FIRE_RL_l2_gen_header &&
	     (gpPtr == 4'd1 || gpPtr == 4'd2 || gpPtr == 4'd3 ||
	      gpPtr == 4'd4 ||
	      gpPtr == 4'd5 ||
	      gpPtr == 4'd6 ||
	      gpPtr == 4'd7 ||
	      gpPtr == 4'd8 ||
	      gpPtr == 4'd9 ||
	      gpPtr == 4'd10 ||
	      gpPtr == 4'd11 ||
	      gpPtr == 4'd12 ||
	      gpPtr == 4'd13 ||
	      gpPtr == 4'd14) ||
	     WILL_FIRE_RL_l2_gen_payload &&
	     (gqPtr == 4'd0 || gqPtr == 4'd1 || gqPtr == 4'd2 ||
	      gqPtr == 4'd3 ||
	      gqPtr == 4'd4 ||
	      gqPtr == 4'd5 ||
	      gqPtr == 4'd6 ||
	      gqPtr == 4'd7) ;
  assign l2GenF_DEQ = CAN_FIRE_RL_mkConnectionGetPut ;
  assign l2GenF_CLR = 1'b0 ;

  // submodule l2P
  assign l2P_client_response_put =
	     { CASE_qcl2_outFD_OUT_BITS_9_TO_8_0_qcl2_outFD_ETC__q9,
	       qcl2_outF_D_OUT[7:0] } ;
  assign l2P_macAddr_u = 48'h0 ;
  assign l2P_server_request_put =
	     { CASE_l2GenFD_OUT_BITS_9_TO_8_0_l2GenFD_OUT_B_ETC__q10,
	       l2GenF_D_OUT[7:0] } ;
  assign l2P_EN_server_request_put = CAN_FIRE_RL_mkConnectionGetPut ;
  assign l2P_EN_server_response_get = CAN_FIRE_RL_mkConnectionGetPut_5 ;
  assign l2P_EN_client_request_get = CAN_FIRE_RL_mkConnectionGetPut_1 ;
  assign l2P_EN_client_response_put = CAN_FIRE_RL_mkConnectionGetPut_4 ;
  assign l2P_EN_macAddr = 1'b0 ;

  // submodule l2qc_inF
  assign l2qc_inF_D_IN =
	     { CASE_l2Pclient_request_get_BITS_9_TO_8_0_l2P_ETC__q11,
	       l2P_client_request_get[7:0] } ;
  assign l2qc_inF_ENQ = CAN_FIRE_RL_mkConnectionGetPut_1 ;
  assign l2qc_inF_DEQ = CAN_FIRE_RL_l2qc_unfunnel ;
  assign l2qc_inF_CLR = 1'b0 ;

  // submodule l2qc_outF
  assign l2qc_outF_D_IN =
	     { IF_l2qc_inF_first__60_BITS_9_TO_8_61_EQ_0_62_O_ETC___d198,
	       IF_l2qc_sr_67_BITS_9_TO_8_79_EQ_0_80_OR_l2qc_s_ETC___d189,
	       IF_l2qc_sr_67_BITS_19_TO_18_68_EQ_0_69_OR_l2qc_ETC___d178,
	       CASE_l2qc_sr_BITS_29_TO_28_0_l2qc_sr_BITS_29_T_ETC__q12,
	       l2qc_sr[27:20] } ;
  assign l2qc_outF_ENQ =
	     WILL_FIRE_RL_l2qc_unfunnel &&
	     (l2qc_ptr == 2'd3 || l2qc_inF_D_OUT[9:8] != 2'd0) ;
  assign l2qc_outF_DEQ = CAN_FIRE_RL_mkConnectionGetPut_2 ;
  assign l2qc_outF_CLR = 1'b0 ;

  // submodule qcl2_inF
  assign qcl2_inF_D_IN =
	     { CASE_crt2axicrtS0_response_get_BITS_39_TO_38__ETC__q13,
	       crt2axi_crtS0_response_get[37:30],
	       CASE_crt2axicrtS0_response_get_BITS_29_TO_28__ETC__q14,
	       crt2axi_crtS0_response_get[27:20],
	       CASE_crt2axicrtS0_response_get_BITS_19_TO_18__ETC__q15,
	       crt2axi_crtS0_response_get[17:10],
	       CASE_crt2axicrtS0_response_get_BITS_9_TO_8_0__ETC__q16,
	       crt2axi_crtS0_response_get[7:0] } ;
  assign qcl2_inF_ENQ = CAN_FIRE_RL_mkConnectionGetPut_3 ;
  assign qcl2_inF_DEQ =
	     WILL_FIRE_RL_qcl2_funnel &&
	     (qcl2_ptr == 2'd3 ||
	      !SEL_ARR_qcl2_inF_first__64_BITS_9_TO_8_65_EQ_0_ETC___d275) ;
  assign qcl2_inF_CLR = 1'b0 ;

  // submodule qcl2_outF
  assign qcl2_outF_D_IN =
	     SEL_ARR_qcl2_inF_first__64_BITS_9_TO_8_65_EQ_0_ETC___d275 ?
	       { 2'd0,
		 SEL_ARR_qcl2_inF_first__64_BITS_7_TO_0_78_qcl2_ETC___d283 } :
	       IF_SEL_ARR_qcl2_inF_first__64_BITS_9_TO_8_65_E_ETC___d300 ;
  assign qcl2_outF_ENQ = CAN_FIRE_RL_qcl2_funnel ;
  assign qcl2_outF_DEQ = CAN_FIRE_RL_mkConnectionGetPut_4 ;
  assign qcl2_outF_CLR = 1'b0 ;

  // remaining internal signals
  assign IF_SEL_ARR_qcl2_inF_first__64_BITS_9_TO_8_65_E_ETC___d299 =
	     { CASE_qcl2_ptr_0_qcl2_inFD_OUT_BITS_9_TO_8_EQ__ETC__q4 ?
		 2'd2 :
		 2'd3,
	       SEL_ARR_qcl2_inF_first__64_BITS_7_TO_0_78_qcl2_ETC___d283 } ;
  assign IF_SEL_ARR_qcl2_inF_first__64_BITS_9_TO_8_65_E_ETC___d300 =
	     CASE_qcl2_ptr_0_qcl2_inFD_OUT_BITS_9_TO_8_EQ__ETC__q5 ?
	       { 2'd1,
		 SEL_ARR_qcl2_inF_first__64_BITS_7_TO_0_78_qcl2_ETC___d283 } :
	       IF_SEL_ARR_qcl2_inF_first__64_BITS_9_TO_8_65_E_ETC___d299 ;
  assign IF_l2qc_inF_first__60_BITS_9_TO_8_61_EQ_0_62_O_ETC___d198 =
	     { CASE_l2qc_inFD_OUT_BITS_9_TO_8_0_l2qc_inFD_O_ETC__q1,
	       l2qc_inF_D_OUT[7:0] } ;
  assign IF_l2qc_sr_67_BITS_19_TO_18_68_EQ_0_69_OR_l2qc_ETC___d178 =
	     { CASE_l2qc_sr_BITS_19_TO_18_0_l2qc_sr_BITS_19_T_ETC__q3,
	       l2qc_sr[17:10] } ;
  assign IF_l2qc_sr_67_BITS_9_TO_8_79_EQ_0_80_OR_l2qc_s_ETC___d189 =
	     { CASE_l2qc_sr_BITS_9_TO_8_0_l2qc_sr_BITS_9_TO_8_ETC__q2,
	       l2qc_sr[7:0] } ;
  always@(qcl2_ptr or qcl2_inF_D_OUT)
  begin
    case (qcl2_ptr)
      2'd0:
	  SEL_ARR_qcl2_inF_first__64_BITS_9_TO_8_65_EQ_0_ETC___d275 =
	      qcl2_inF_D_OUT[9:8] == 2'd0;
      2'd1:
	  SEL_ARR_qcl2_inF_first__64_BITS_9_TO_8_65_EQ_0_ETC___d275 =
	      qcl2_inF_D_OUT[19:18] == 2'd0;
      2'd2:
	  SEL_ARR_qcl2_inF_first__64_BITS_9_TO_8_65_EQ_0_ETC___d275 =
	      qcl2_inF_D_OUT[29:28] == 2'd0;
      2'd3:
	  SEL_ARR_qcl2_inF_first__64_BITS_9_TO_8_65_EQ_0_ETC___d275 =
	      qcl2_inF_D_OUT[39:38] == 2'd0;
    endcase
  end
  always@(qcl2_ptr or qcl2_inF_D_OUT)
  begin
    case (qcl2_ptr)
      2'd0:
	  SEL_ARR_qcl2_inF_first__64_BITS_7_TO_0_78_qcl2_ETC___d283 =
	      qcl2_inF_D_OUT[7:0];
      2'd1:
	  SEL_ARR_qcl2_inF_first__64_BITS_7_TO_0_78_qcl2_ETC___d283 =
	      qcl2_inF_D_OUT[17:10];
      2'd2:
	  SEL_ARR_qcl2_inF_first__64_BITS_7_TO_0_78_qcl2_ETC___d283 =
	      qcl2_inF_D_OUT[27:20];
      2'd3:
	  SEL_ARR_qcl2_inF_first__64_BITS_7_TO_0_78_qcl2_ETC___d283 =
	      qcl2_inF_D_OUT[37:30];
    endcase
  end
  always@(l2qc_inF_D_OUT)
  begin
    case (l2qc_inF_D_OUT[9:8])
      2'd0, 2'd1, 2'd2:
	  CASE_l2qc_inFD_OUT_BITS_9_TO_8_0_l2qc_inFD_O_ETC__q1 =
	      l2qc_inF_D_OUT[9:8];
      2'd3: CASE_l2qc_inFD_OUT_BITS_9_TO_8_0_l2qc_inFD_O_ETC__q1 = 2'd3;
    endcase
  end
  always@(l2qc_sr)
  begin
    case (l2qc_sr[9:8])
      2'd0, 2'd1, 2'd2:
	  CASE_l2qc_sr_BITS_9_TO_8_0_l2qc_sr_BITS_9_TO_8_ETC__q2 =
	      l2qc_sr[9:8];
      2'd3: CASE_l2qc_sr_BITS_9_TO_8_0_l2qc_sr_BITS_9_TO_8_ETC__q2 = 2'd3;
    endcase
  end
  always@(l2qc_sr)
  begin
    case (l2qc_sr[19:18])
      2'd0, 2'd1, 2'd2:
	  CASE_l2qc_sr_BITS_19_TO_18_0_l2qc_sr_BITS_19_T_ETC__q3 =
	      l2qc_sr[19:18];
      2'd3: CASE_l2qc_sr_BITS_19_TO_18_0_l2qc_sr_BITS_19_T_ETC__q3 = 2'd3;
    endcase
  end
  always@(qcl2_ptr or qcl2_inF_D_OUT)
  begin
    case (qcl2_ptr)
      2'd0:
	  CASE_qcl2_ptr_0_qcl2_inFD_OUT_BITS_9_TO_8_EQ__ETC__q4 =
	      qcl2_inF_D_OUT[9:8] == 2'd2;
      2'd1:
	  CASE_qcl2_ptr_0_qcl2_inFD_OUT_BITS_9_TO_8_EQ__ETC__q4 =
	      qcl2_inF_D_OUT[19:18] == 2'd2;
      2'd2:
	  CASE_qcl2_ptr_0_qcl2_inFD_OUT_BITS_9_TO_8_EQ__ETC__q4 =
	      qcl2_inF_D_OUT[29:28] == 2'd2;
      2'd3:
	  CASE_qcl2_ptr_0_qcl2_inFD_OUT_BITS_9_TO_8_EQ__ETC__q4 =
	      qcl2_inF_D_OUT[39:38] == 2'd2;
    endcase
  end
  always@(qcl2_ptr or qcl2_inF_D_OUT)
  begin
    case (qcl2_ptr)
      2'd0:
	  CASE_qcl2_ptr_0_qcl2_inFD_OUT_BITS_9_TO_8_EQ__ETC__q5 =
	      qcl2_inF_D_OUT[9:8] == 2'd1;
      2'd1:
	  CASE_qcl2_ptr_0_qcl2_inFD_OUT_BITS_9_TO_8_EQ__ETC__q5 =
	      qcl2_inF_D_OUT[19:18] == 2'd1;
      2'd2:
	  CASE_qcl2_ptr_0_qcl2_inFD_OUT_BITS_9_TO_8_EQ__ETC__q5 =
	      qcl2_inF_D_OUT[29:28] == 2'd1;
      2'd3:
	  CASE_qcl2_ptr_0_qcl2_inFD_OUT_BITS_9_TO_8_EQ__ETC__q5 =
	      qcl2_inF_D_OUT[39:38] == 2'd1;
    endcase
  end
  always@(gpPtr or l2GenF_FULL_N)
  begin
    case (gpPtr)
      4'd1,
      4'd2,
      4'd3,
      4'd4,
      4'd5,
      4'd6,
      4'd7,
      4'd8,
      4'd9,
      4'd10,
      4'd11,
      4'd12:
	  CASE_gpPtr_1_l2GenFFULL_N_2_l2GenFFULL_N_3_l_ETC__q6 =
	      l2GenF_FULL_N;
      default: CASE_gpPtr_1_l2GenFFULL_N_2_l2GenFFULL_N_3_l_ETC__q6 =
		   gpPtr != 4'd14 || l2GenF_FULL_N;
    endcase
  end
  always@(gqPtr or l2GenF_FULL_N)
  begin
    case (gqPtr)
      4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6:
	  CASE_gqPtr_0_l2GenFFULL_N_1_l2GenFFULL_N_2_l_ETC__q7 =
	      l2GenF_FULL_N;
      default: CASE_gqPtr_0_l2GenFFULL_N_1_l2GenFFULL_N_2_l_ETC__q7 =
		   gqPtr != 4'd7 || l2GenF_FULL_N;
    endcase
  end
  always@(l2P_server_response_get)
  begin
    case (l2P_server_response_get[9:8])
      2'd0, 2'd1, 2'd2:
	  CASE_l2Pserver_response_get_BITS_9_TO_8_0_l2P_ETC__q8 =
	      l2P_server_response_get[9:8];
      2'd3: CASE_l2Pserver_response_get_BITS_9_TO_8_0_l2P_ETC__q8 = 2'd3;
    endcase
  end
  always@(qcl2_outF_D_OUT)
  begin
    case (qcl2_outF_D_OUT[9:8])
      2'd0, 2'd1, 2'd2:
	  CASE_qcl2_outFD_OUT_BITS_9_TO_8_0_qcl2_outFD_ETC__q9 =
	      qcl2_outF_D_OUT[9:8];
      2'd3: CASE_qcl2_outFD_OUT_BITS_9_TO_8_0_qcl2_outFD_ETC__q9 = 2'd3;
    endcase
  end
  always@(l2GenF_D_OUT)
  begin
    case (l2GenF_D_OUT[9:8])
      2'd0, 2'd1, 2'd2:
	  CASE_l2GenFD_OUT_BITS_9_TO_8_0_l2GenFD_OUT_B_ETC__q10 =
	      l2GenF_D_OUT[9:8];
      2'd3: CASE_l2GenFD_OUT_BITS_9_TO_8_0_l2GenFD_OUT_B_ETC__q10 = 2'd3;
    endcase
  end
  always@(l2P_client_request_get)
  begin
    case (l2P_client_request_get[9:8])
      2'd0, 2'd1, 2'd2:
	  CASE_l2Pclient_request_get_BITS_9_TO_8_0_l2P_ETC__q11 =
	      l2P_client_request_get[9:8];
      2'd3: CASE_l2Pclient_request_get_BITS_9_TO_8_0_l2P_ETC__q11 = 2'd3;
    endcase
  end
  always@(l2qc_sr)
  begin
    case (l2qc_sr[29:28])
      2'd0, 2'd1, 2'd2:
	  CASE_l2qc_sr_BITS_29_TO_28_0_l2qc_sr_BITS_29_T_ETC__q12 =
	      l2qc_sr[29:28];
      2'd3: CASE_l2qc_sr_BITS_29_TO_28_0_l2qc_sr_BITS_29_T_ETC__q12 = 2'd3;
    endcase
  end
  always@(crt2axi_crtS0_response_get)
  begin
    case (crt2axi_crtS0_response_get[39:38])
      2'd0, 2'd1, 2'd2:
	  CASE_crt2axicrtS0_response_get_BITS_39_TO_38__ETC__q13 =
	      crt2axi_crtS0_response_get[39:38];
      2'd3: CASE_crt2axicrtS0_response_get_BITS_39_TO_38__ETC__q13 = 2'd3;
    endcase
  end
  always@(crt2axi_crtS0_response_get)
  begin
    case (crt2axi_crtS0_response_get[29:28])
      2'd0, 2'd1, 2'd2:
	  CASE_crt2axicrtS0_response_get_BITS_29_TO_28__ETC__q14 =
	      crt2axi_crtS0_response_get[29:28];
      2'd3: CASE_crt2axicrtS0_response_get_BITS_29_TO_28__ETC__q14 = 2'd3;
    endcase
  end
  always@(crt2axi_crtS0_response_get)
  begin
    case (crt2axi_crtS0_response_get[19:18])
      2'd0, 2'd1, 2'd2:
	  CASE_crt2axicrtS0_response_get_BITS_19_TO_18__ETC__q15 =
	      crt2axi_crtS0_response_get[19:18];
      2'd3: CASE_crt2axicrtS0_response_get_BITS_19_TO_18__ETC__q15 = 2'd3;
    endcase
  end
  always@(crt2axi_crtS0_response_get)
  begin
    case (crt2axi_crtS0_response_get[9:8])
      2'd0, 2'd1, 2'd2:
	  CASE_crt2axicrtS0_response_get_BITS_9_TO_8_0__ETC__q16 =
	      crt2axi_crtS0_response_get[9:8];
      2'd3: CASE_crt2axicrtS0_response_get_BITS_9_TO_8_0__ETC__q16 = 2'd3;
    endcase
  end

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        consumeCnt <= `BSV_ASSIGNMENT_DELAY 16'd0;
	cycleCount <= `BSV_ASSIGNMENT_DELAY 16'd0;
	gpL2Hdr <= `BSV_ASSIGNMENT_DELAY 1'd1;
	gpPDU <= `BSV_ASSIGNMENT_DELAY 1'd0;
	gpPtr <= `BSV_ASSIGNMENT_DELAY 4'd0;
	gqPtr <= `BSV_ASSIGNMENT_DELAY 4'd0;
	l2qc_ptr <= `BSV_ASSIGNMENT_DELAY 2'd0;
	qcl2_ptr <= `BSV_ASSIGNMENT_DELAY 2'd0;
      end
    else
      begin
        if (consumeCnt_EN)
	  consumeCnt <= `BSV_ASSIGNMENT_DELAY consumeCnt_D_IN;
	if (cycleCount_EN)
	  cycleCount <= `BSV_ASSIGNMENT_DELAY cycleCount_D_IN;
	if (gpL2Hdr_EN) gpL2Hdr <= `BSV_ASSIGNMENT_DELAY gpL2Hdr_D_IN;
	if (gpPDU_EN) gpPDU <= `BSV_ASSIGNMENT_DELAY gpPDU_D_IN;
	if (gpPtr_EN) gpPtr <= `BSV_ASSIGNMENT_DELAY gpPtr_D_IN;
	if (gqPtr_EN) gqPtr <= `BSV_ASSIGNMENT_DELAY gqPtr_D_IN;
	if (l2qc_ptr_EN) l2qc_ptr <= `BSV_ASSIGNMENT_DELAY l2qc_ptr_D_IN;
	if (qcl2_ptr_EN) qcl2_ptr <= `BSV_ASSIGNMENT_DELAY qcl2_ptr_D_IN;
      end
    if (gpDA_EN) gpDA <= `BSV_ASSIGNMENT_DELAY gpDA_D_IN;
    if (gpSA_EN) gpSA <= `BSV_ASSIGNMENT_DELAY gpSA_D_IN;
    if (l2qc_sr_EN) l2qc_sr <= `BSV_ASSIGNMENT_DELAY l2qc_sr_D_IN;
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    consumeCnt = 16'hAAAA;
    cycleCount = 16'hAAAA;
    gpDA = 48'hAAAAAAAAAAAA;
    gpL2Hdr = 1'h0;
    gpPDU = 1'h0;
    gpPtr = 4'hA;
    gpSA = 48'hAAAAAAAAAAAA;
    gqPtr = 4'hA;
    l2qc_ptr = 2'h2;
    l2qc_sr = 30'h2AAAAAAA;
    qcl2_ptr = 2'h2;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_terminate)
	begin
	  v__h16079 = $time;
	  #0;
	end
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_terminate)
	$display("[%0d]: %m: Terminate rule fired in cycle:%0d",
		 v__h16079,
		 $unsigned(cycleCount));
    if (RST_N != `BSV_RESET_VALUE) if (WILL_FIRE_RL_terminate) $finish(32'd1);
  end
  // synopsys translate_on
endmodule  // mkHCrt_TB1

