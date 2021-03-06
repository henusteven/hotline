// GMAC.bsv - 1Gb Ethernet MAC 
// Copyright (c) 2012,2013 Atomic Rules LLC - ALL RIGHTS RESERVED

// See IEEE 802.3-2008 section 35 Reconciliation Sublayer (RS) and Gigabit Media Independent Interface (GMII)

//  Use `define SPARTAN to target the Ettus N210 or similar platform
//  Use `define NO_IOB to remove MAC/RS TX and RX IOB features such as DDR or IOELAY (use with ext GMII, RGMII, SGMII)
`define NO_IOB

package GMAC;

import ABS               ::*;
import E8023             ::*;
import CounterM          ::*;

import Clocks            ::*;
import Connectable       ::*;
import CRC               ::*;
import DReg              ::*;
import FIFO              ::*;
import FIFOF             ::*;
import GetPut            ::*;
import Vector            ::*;

import XilinxCells       ::*;
import XilinxExtra       ::*;


// Interfaces...

(* always_enabled, always_ready *)
interface GMII_RX_RS;                            // FPGA provides to PHY
  (* prefix="" *) method    Action      rxd  ((* port="rxd"   *) Bit#(8) i);
  (* prefix="" *) method    Action      rx_dv((* port="rx_dv" *) Bit#(1) i);
  (* prefix="" *) method    Action      rx_er((* port="rx_er" *) Bit#(1) i);
endinterface: GMII_RX_RS

(* always_enabled, always_ready *)
interface GMII_RX_PCS;                           // PHY provides to FPGA
  method    Bit#(8)     rxd;
  method    Bit#(1)     rx_dv;
  method    Bit#(1)     rx_er;
endinterface: GMII_RX_PCS

(* always_enabled, always_ready *)
interface GMII_TX_RS;                            // FPGA provides to PHY
  interface Clock       gtx_clk;
  method    Bit#(8)     txd;
  (* result="tx_en" *) method    Bit#(1)     tx_en;
  (* result="tx_er" *) method    Bit#(1)     tx_er;
endinterface: GMII_TX_RS

(* always_enabled, always_ready *)
interface GMII_TX_PCS;                           // PHY provides to FPGA
  method    Action      txd  (Bit#(8) i);
  method    Action      tx_en(Bit#(1) i);
  method    Action      tx_er(Bit#(1) i);
endinterface :GMII_TX_PCS

(* always_enabled, always_ready *)
interface GMII_RS;  // GMII_RS is the bottom of the MAC facing the top of the PHY...
  (* prefix="" *) interface GMII_RX_RS  rx;
  (* prefix="" *) interface GMII_TX_RS  tx;
  (* prefix="" *) method    Action      col   ((* port="col" *) Bit#(1) i);
  (* prefix="" *) method    Action      crs   ((* port="crs" *) Bit#(1) i);
  (* prefix="" *) method    Action      intr  ((* port="int" *) Bit#(1) i);
  (* prefix="" *) method    Bit#(1)     led;
endinterface: GMII_RS

(* always_enabled, always_ready *)
interface GMII_PCS; // GMII_PCS is the top of the PHY facing the MAC...
  (* prefix="" *) interface GMII_RX_PCS rx;
  (* prefix="" *) interface GMII_TX_PCS tx;
  method    Bit#(1)     col;
  method    Bit#(1)     crs;
  method    Bit#(1)     intr;
  method    Action      led  (Bit#(1) i);
endinterface: GMII_PCS

interface RxRSIfc;
  interface GMII_RX_RS  gmii;
  method    Action      rxOperate;
  method    Bool        rxOverFlow;
  interface Get#(ABS)   rx;
endinterface

interface TxRSIfc;
  interface Put#(ABS)   tx;
  method    Action      txOperate;
  method    Bool        txUnderFlow;
  interface GMII_TX_RS  gmii;
endinterface

interface GMACIfc;
  interface GMII_RS     gmii;
  interface Clock       rxclk_ModBnd; 
  //interface Reset       gmii_rstn;
  interface Get#(ABS)   rx;
  interface Put#(ABS)   tx;
  method Action         rxOperate;
  method Action         txOperate;
  method Bool           rxOverFlow;
  method Bool           txUnderFlow;
  method Bool           phyInterrupt;
endinterface: GMACIfc

(* synthesize *)
module mkGMAC#(Clock rxClk, Clock txClk)(GMACIfc);

// GMAC Clocking: In general there are three Clocks used by the GMAC. It can be simplified to two
// in a special case. Those three clocks are:
// i)   The GMII PHY RX Clock. The rxClk is generated by the PHY and is the source-synchronous clock for
//      the GMII_RX signals. This is 125 MHz is recovered from the wire by the PHY. path: wire->PHY->FPGA RX
// ii)  The GMII PHY GTX Clock. The txClk is generated by the FPGA and sent to the PHY. The source for this
//      is a on-card XO that provides a stable 125 MHz to transmit symbols by GMII to the PHY. Note that
//      although logically the "tx" clock, the FPGA XO provides this by GMII to the PHY on the pin "GTX_CLK".
//      Inside the PHY TX symbols are capured from the FPGA with the GTX clock, passed through a FIFO, and
//      then sent out on the 1Gb wire by a crystal XO connected to the PHY.
//      The PHY has an output pin "TX_CLK" which is unused in 1Gb operation that this MAC ignores in all cases.
//      path: board 125 MHz source-> FPGA sys1 input -> FPGA TX logic -> PHY GTX_CLK pin -> wire
// iii) There is the Current Clock (CC) default module clock of this mkGMAC module. This can be any frequency
//      equal to or greater than 125 MHz. Buffer sizes and interfame gaps allow a tolerance between the CC 
//      frequency and (i) and (ii) above. At frequencies above 125 MHz TX underrun and RX overrun can only be
//      caused by some external agent (e.g. non-continious WSI on TX, or mid-packet backpressure on RX).
// In some scenarios, the CC can be the same as the (G)TX clk (ii), elliminating the need for a third clock
// Each tx/rx Resolution Sublayer (RS) block handles the clock domain crossing from their tx/rx domain, back to CC

`ifdef SPARTAN
  Clock         rxClk_BUFR       = rxClk;
`elsif NO_IOB
  Clock         rxClk_BUFR       = rxClk; 
`else
  ClockIODELAY  gmii_rxc_dly     <-  vClockIODELAY("FIXED", 0, "I", clocked_by rxClk);
  Clock         gmii_rx_clk_dly  =   gmii_rxc_dly.delayed;
  Clock         gmii_rx_clk      <-  mkClockBUFIO(clocked_by gmii_rx_clk_dly);
  //TODO: Use gmii_rx_clk to capture rxd,dv,err in IOB FFs
  //TODO: Use txClk to register tx gmii signals in IOB FFs
  Clock         rxClk_BUFR       <-  mkClockBUFR(BUFRParams{bufr_divide:"BYPASS"}, clocked_by gmii_rx_clk_dly);
`endif
  Clock         clk              <-  exposeCurrentClock;  // User-Facing CC for the rx/tx methods
  Reset         rst              <-  exposeCurrentReset;
  Reset         phyReset         <-  mkAsyncReset(8, rst, clk); // Hold PHY in reset for 8 *additional* cycles
  RxRSIfc       rxRS             <-  mkRxRSAsync(rxClk_BUFR);
  TxRSIfc       txRS             <-  mkTxRSAsync(txClk);
  Reg#(Bool)    gmacLED          <-  mkReg(False);
  SyncBitIfc#(Bit#(1))  col_cc   <-  mkSyncBitToCC(clk,phyReset);
  SyncBitIfc#(Bit#(1))  crs_cc   <-  mkSyncBitToCC(clk,phyReset);
  SyncBitIfc#(Bit#(1))  intr_cc  <-  mkSyncBitToCC(clk,phyReset);

  Bool crsOK =   unpack(crs_cc.read);
  Bool noCOL =  !unpack(col_cc.read);

  interface Get rx = rxRS.rx;
  interface Put tx = txRS.tx;

  //method Action rxOperate if (crsOK && noCOL);  // Don't allow RX until we see CRS True and COL False
  method Action rxOperate;  // Don't allow RX until we see CRS True and COL False
    rxRS.rxOperate;
    gmacLED <= True;
  endmethod

  method Action txOperate   = txRS.txOperate;
  method Bool   rxOverFlow  = rxRS.rxOverFlow;
  method Bool   txUnderFlow = txRS.txUnderFlow;

  interface GMII_RS gmii;                  // PHY-facing GMII Interface to FPGA Pins
    interface GMII_RX_RS  rx = rxRS.gmii;
    interface GMII_TX_RS  tx = txRS.gmii;
    method Action col  (Bit#(1) i) = col_cc.send(i);
    method Action crs  (Bit#(1) i) = crs_cc.send(i);
    method Action intr (Bit#(1) i) = intr_cc.send(i);
    method Bit#(1) led = pack(gmacLED);
  endinterface
  interface Clock rxclk_ModBnd  = rxClk_BUFR;  // Need to provide this clock at the BSV module bounds (not physically used)
  //interface Reset gmii_rstn = phyReset;    // Active-Low reset passed up and out to PHY
  method Bool phyInterrupt = !unpack(intr_cc.read);  // Make Interrupt active-high
endmodule: mkGMAC 

// Receive (Rx) Reconciliation Sublayer (RS)
// This module accepts the RX data from the PHY and segments it into ABS frames
// It removes the preamble and SFD; it passes frames starting with the Destination Address (DA)
// It ends frames with either a ValidEOP (if the FCS matches) or an AbortEOP (if it doesnt)
// By adding 5 cycles of latency, this module alligns the fcsMatch with the last payload rxF.enq
// Thus downstream RX logic doesn't have to cope with the waiting to know of good vs. bad.
// This is 40 nS of rcv data latency we could take back someday; but we would still not know fcsMatch any earlier.
module mkRxRSAsync#(Clock rxClk) (RxRSIfc);
  Reset                    rxRst        <- mkAsyncResetFromCR(2, rxClk);
  Reg#(Bool)               rxOperateD   <- mkDReg(False);
  SyncBitIfc#(Bit#(1))     rxOperateS   <- mkSyncBitFromCC(rxClk);
  Reg#(Bit#(8))            rxData       <- mkRegU(          clocked_by rxClk, reset_by rxRst);
  Reg#(Bool)               rxDV         <- mkReg(False,     clocked_by rxClk, reset_by rxRst);
  Reg#(Bool)               rxDVD        <- mkReg(False,     clocked_by rxClk, reset_by rxRst);
  Reg#(Bool)               rxDVD2       <- mkReg(False,     clocked_by rxClk, reset_by rxRst);
  Reg#(Bool)               rxER         <- mkReg(False,     clocked_by rxClk, reset_by rxRst);
  CounterSat#(UInt#(4))    preambleCnt  <- mkCounterSat(    clocked_by rxClk, reset_by rxRst);
  Reg#(Bool)               rxActive     <- mkReg(False,     clocked_by rxClk, reset_by rxRst);
  Reg#(Vector#(6,Bit#(8))) rxPipe       <- mkRegU(          clocked_by rxClk, reset_by rxRst);
  Reg#(Vector#(6,Bool))    rxAPipe      <- mkReg(unpack(0), clocked_by rxClk, reset_by rxRst);
  CRC#(32)                 crc          <- mkCRC32(         clocked_by rxClk, reset_by rxRst);
  CounterSat#(UInt#(12))   crcDbgCnt    <- mkCounterSat(    clocked_by rxClk, reset_by rxRst);
  Reg#(Bool)               isSOF        <- mkReg(True,      clocked_by rxClk, reset_by rxRst);
  Reg#(Bool)               crcEnd       <- mkReg(False,     clocked_by rxClk, reset_by rxRst);
  Reg#(Bool)               fullD        <- mkReg(False,     clocked_by rxClk, reset_by rxRst);
  SyncFIFOIfc#(ABS)        rxF          <- mkSyncFIFOToCC(8, rxClk, rxRst); // ~6 cycle fallthrough
  SyncBitIfc#(Bit#(1))     ovfBit       <- mkSyncBitToCC(rxClk, rxRst);

  rule operate_condition; rxOperateS.send(pack(rxOperateD)); endrule // send the operate DReg from CC to rxClk domain
  Bool rxEnable = unpack(rxOperateS.read);
  rule dv_reg (rxEnable); rxDVD <= rxDV; rxDVD2 <= rxDVD; endrule
  rule full_stretch; fullD <= rxEnable && !rxF.notFull; endrule
  Bool rxOverflow = rxEnable && (!rxF.notFull || fullD);  // Stretch full detection so SyncBit sees at least one cycle
  rule overflow_detect (rxEnable); ovfBit.send(pack(rxOverflow)); endrule  // Feed Synchronizer

  rule ingress_advance (rxEnable && rxDV && !rxER);
     rxPipe  <= shiftInAt0(rxPipe, rxData);                     // Build up our 32b FCS candidate
     rxAPipe <= shiftInAt0(rxAPipe,rxActive);                   // Mark where Active data starts (after SFD)
     if (rxData == pack(PREAMBLE))  preambleCnt.inc;            // Count preamble octets
     if (preambleCnt>6 && rxData==pack(SFD)) rxActive <= True;  // Detect Start of Frame Delimiter
  endrule

  rule ingress_noadvance (rxEnable && !rxDVD && rxAPipe==unpack(6'h3F) && !crcEnd);  // !rxDV is indication we have FCS
    let fcs <- crc.complete;
    $display("[%0d]: %m: RX FCS:%08x from %d elements", $time, fcs, crcDbgCnt);
    crcDbgCnt.load(0);
    if (rxActive) begin
      Bool fcsMatch = (fcs == unpack(pack(reverse(takeAt(0,rxPipe)))));
      rxF.enq( (fcsMatch) ? tagged ValidEOP rxPipe[4] : tagged AbortEOP);  // Either ValidEOP or AbortEOP
    end
    crcEnd   <= True;
  endrule

  rule end_frame (rxEnable && (crcEnd || rxER));
    preambleCnt.load(0);   // Reset the preamble counter
    rxActive <= False;     // Clear rxActive
    isSOF    <= True;      // For next frame
    rxAPipe  <= unpack(0); // Clear shift register
    crcEnd   <= False;
  endrule

  rule crc_capture (rxEnable && rxDV && rxAPipe[3]);
    crc.add(rxPipe[3]); // Update CRC starting with DA (after SFD)
    crcDbgCnt.inc;
  endrule

  rule egress_data  (rxEnable && rxDVD && rxAPipe[5]);
    rxF.enq(rxER ? tagged AbortEOP : tagged ValidNotEOP rxPipe[5]); 
    isSOF <= False;    
  endrule

  interface GMII_RX_RS gmii;
    method Action rxd   (x) = rxData._write(x);
    method Action rx_dv (x) = rxDV._write(unpack(x));
    method Action rx_er (x) = rxER._write(unpack(x));
  endinterface: gmii

  interface Get rx = toGet(rxF);
  method    Action  rxOperate = rxOperateD._write(True);
  method    Bool    rxOverFlow = unpack(ovfBit.read);
endmodule: mkRxRSAsync

// Transmit (Tx) Reconciliation Sublayer (RS)
// This module accepts the TX data from a higher sublevel of the MAC; frames start at the Destination Address (DA)
// It will insert the preamble and SFD, pass the incident frame, and generate and insert the FCS
// If the txF starves in the middle of a frame; that is a TX UNDERFLOW error (txUnderflow)
module mkTxRSAsync#(Clock txClk) (TxRSIfc);
  Reset                    txRst        <- mkAsyncResetFromCR(2, txClk);
  Reg#(Bool)               txOperateD   <- mkDReg(False);
  SyncBitIfc#(Bit#(1))     txOperateS   <- mkSyncBitFromCC(txClk);
  Reg#(Bit#(8))            txData       <- mkDReg(0,        clocked_by txClk, reset_by txRst);
  Reg#(Bool)               txDV         <- mkDReg(False,    clocked_by txClk, reset_by txRst);
  Reg#(Bool)               txER         <- mkDReg(False,    clocked_by txClk, reset_by txRst);
  CounterSat#(UInt#(5))    preambleCnt  <- mkCounterSat(    clocked_by txClk, reset_by txRst);
  CounterSat#(UInt#(5))    ifgCnt       <- mkCounterSat(    clocked_by txClk, reset_by txRst);
  CounterSat#(UInt#(12))   lenCnt       <- mkCounterSat(    clocked_by txClk, reset_by txRst);
  Reg#(Bool)               txActive     <- mkReg(False,     clocked_by txClk, reset_by txRst);
  CRC#(32)                 crc          <- mkCRC32(         clocked_by txClk, reset_by txRst);
  CounterSat#(UInt#(12))   crcDbgCnt    <- mkCounterSat(    clocked_by txClk, reset_by txRst);
  Reg#(Bool)               underflow    <- mkDReg(False,    clocked_by txClk, reset_by txRst);
  Reg#(UInt#(3))           emitFCS      <- mkReg(0,         clocked_by txClk, reset_by txRst);
  Reg#(Bool)               doPad        <- mkReg(False,     clocked_by txClk, reset_by txRst);
  Reg#(Bool)               isSOF        <- mkReg(True,      clocked_by txClk, reset_by txRst);
  Reg#(Bool)               unfD         <- mkReg(False,     clocked_by txClk, reset_by txRst);
  SyncFIFOIfc#(ABS)        txF          <- mkSyncFIFOFromCC(16, txClk);  // ~6 cycle fallthrough; sls 2012-08-28 from 8 to 16
  SyncBitIfc#(Bit#(1))     unfBit       <- mkSyncBitToCC(txClk, txRst);

  rule operate_condition; txOperateS.send(pack(txOperateD)); endrule // send the operate DReg from CC to txClk domain
  Bool txEnable = unpack(txOperateS.read);
  Bool txUnd = txEnable && (!txF.notEmpty && txActive && !doPad);
  rule unf_stretch ; unfD <= txUnd; endrule
  rule undeflow_detect (txEnable); unfBit.send(pack(txUnd || unfD)); endrule

  //(* descending_urgency = "egress_FCS, egress_PAD, egress_EOF, egress_Body, egress_SOF" *)
  (* descending_urgency = "egress_FCS, egress_EOF, egress_Body, egress_SOF" *)

  rule egress_SOF(txEnable && isSOF &&& ifgCnt==0 &&& txF.first matches tagged ValidNotEOP .d);
    if (preambleCnt<7) begin
      txData <= pack(PREAMBLE);    // 7 Preamble cycles - 8'h55
    end else if (preambleCnt==7) begin
      txData <= pack(SFD);         // 1 SFD cycle - 8'hD5
    end else begin
      txData <= d;                 // 1st Byte of Destination Address
      crc.add(d);
      crcDbgCnt.inc;
      txF.deq;
      lenCnt.inc;
      isSOF <= False;
    end
    preambleCnt.inc();
    txDV     <= True;
    txActive <= True;
  endrule

  rule egress_Body(txEnable && txActive &&& !isSOF &&& txF.first matches tagged ValidNotEOP .d);
    txData <= d;
    crc.add(d);
    crcDbgCnt.inc;
    txF.deq;
    lenCnt.inc;
    txDV <= True;
  endrule

  rule egress_EOF(txEnable && txActive &&& txF.first matches tagged ValidEOP .z);
    //Bool padData = (lenCnt<59);
    let d = doPad ? pack(PAD) : z;  // doPad will be false the first time fired; so we get ValidEOP data
    txData <= d;
    crc.add(d);
    crcDbgCnt.inc;
    lenCnt.inc;
    txDV <= True;
    if (lenCnt>=59) begin // if no padding needed, pop txF and advance to emitFCS
      txActive <= False;
      emitFCS <= 4;
      txF.deq;
      doPad <= False;
    end else doPad <= True;
  endrule

  rule egress_FCS(txEnable && emitFCS!=0);
    Vector#(4,Bit#(8)) fcsV = reverse(unpack(crc.result));
    if (emitFCS==4) begin
      $display("[%0d]: %m: TX FCS:%08x from %d elements", $time, pack(fcsV), crcDbgCnt);
      crcDbgCnt.load(0);
    end
    txData <= fcsV[emitFCS-1];
    lenCnt.inc;
    txDV  <= True;
    emitFCS <= emitFCS - 1;
    if (emitFCS==1) begin
      ifgCnt.load(12);
      preambleCnt.load(0);
      lenCnt.load(0);
      crc.clear;
      isSOF <= True;
    end
  endrule

  rule ifg_decrementer (txEnable && ifgCnt!=0);
    ifgCnt.dec;
  endrule

  // Output source-syncronous clocking; Clock output is 180 degress out-of-phase for 4 nS SU + 4 nS Hold...

`ifdef SPARTAN

  (* doc = "iobTxClk output is 180 degress out-of-phase for 4 nS SU + 4 nS Hold" *)
  Clock            iobTxClk  <- mkClockODDR2(ODDR2Prms {ddr_alignment:"NONE", init:0, srtype:"SYNC"}, 0, 1, clocked_by txClk, reset_by txRst);
  ODDR2#(Bit#(8))  iobTxData <- mkODDR2(     ODDR2Prms {ddr_alignment:"NONE", init:0, srtype:"SYNC"},       clocked_by txClk, reset_by txRst);
  ODDR2#(Bit#(1))  iobTxEna  <- mkODDR2(     ODDR2Prms {ddr_alignment:"NONE", init:0, srtype:"SYNC"},       clocked_by txClk, reset_by txRst);
  ODDR2#(Bit#(1))  iobTxErr  <- mkODDR2(     ODDR2Prms {ddr_alignment:"NONE", init:0, srtype:"SYNC"},       clocked_by txClk, reset_by txRst);
  (* fire_when_enabled, no_implicit_conditions *)
  rule tx_output_flops;
    iobTxData.d0(txData);    iobTxData.d1(txData);     iobTxData.ce(True);  iobTxData.s(False);
    iobTxEna.d0(pack(txDV)); iobTxEna.d1(pack(txDV));  iobTxEna.ce(True);   iobTxEna.s(False);
    iobTxErr.d0(pack(txER)); iobTxErr.d1(pack(txER));  iobTxErr.ce(True);   iobTxErr.s(False);
  endrule

`elsif NO_IOB

  Reg#(Bit#(8)) txDataReg <- mkRegU(  clocked_by txClk, reset_by txRst);
  Reg#(Bit#(1)) txEnaReg  <- mkReg(0, clocked_by txClk, reset_by txRst);
  Reg#(Bit#(1)) txErrReg  <- mkReg(0, clocked_by txClk, reset_by txRst);
  (* fire_when_enabled, no_implicit_conditions *)
  rule tx_output_flops;
    txDataReg <= txData;
    txEnaReg  <= pack(txDV);
    txErrReg  <= pack(txER);
  endrule

`else

  (* doc = "iobTxClk output is 180 degress out-of-phase for 4 nS SU + 4 nS Hold" *)
  Clock             iobTxClk  <- mkClockODDR(ODDRParams {ddr_clk_edge:"SAME_EDGE", init:0, srtype:"SYNC"}, 0, 1, clocked_by txClk, reset_by txRst);
  ODDRar#(Bit#(8))  iobTxData <- mkODDRar(   ODDRParams {ddr_clk_edge:"SAME_EDGE", init:0, srtype:"SYNC"},       clocked_by txClk, reset_by txRst);
  ODDRar#(Bit#(1))  iobTxEna  <- mkODDRar(   ODDRParams {ddr_clk_edge:"SAME_EDGE", init:0, srtype:"SYNC"},       clocked_by txClk, reset_by txRst);
  ODDRar#(Bit#(1))  iobTxErr  <- mkODDRar(   ODDRParams {ddr_clk_edge:"SAME_EDGE", init:0, srtype:"SYNC"},       clocked_by txClk, reset_by txRst);
  (* fire_when_enabled, no_implicit_conditions *)
  rule tx_output_flops;
    iobTxData.d1(txData);    iobTxData.d2(txData);     iobTxData.ce(True);  iobTxData.s(False);
    iobTxEna.d1(pack(txDV)); iobTxEna.d2(pack(txDV));  iobTxEna.ce(True);   iobTxEna.s(False);
    iobTxErr.d1(pack(txER)); iobTxErr.d2(pack(txER));  iobTxErr.ce(True);   iobTxErr.s(False);
  endrule


`endif


  interface Put tx = toPut(txF);
  method  Action  txOperate = txOperateD._write(True);
  method  Bool txUnderFlow = unpack(unfBit.read);
`ifdef NO_IOB
  interface GMII_TX_RS gmii;
    interface Clock   gtx_clk = txClk;      // This clock needs to be inverted for GMII, or used as is for SGMII bridge
    method    Bit#(8) txd     = txDataReg;
    method    Bit#(1) tx_en   = txEnaReg;
    method    Bit#(1) tx_er   = txErrReg;
`else
  interface GMII_TX_RS gmii;
    interface Clock   gtx_clk = iobTxClk;    // The 1GbE TX clock FPGA->PHY is called "GTX_CLK"
    method    Bit#(8) txd     = iobTxData.q;
    method    Bit#(1) tx_en   = iobTxEna.q;
    method    Bit#(1) tx_er   = iobTxErr.q;
`endif
  endinterface: gmii
endmodule: mkTxRSAsync



//
// Connectable Instances...

instance Connectable#(GMII_TX_RS, GMII_RX_RS); // Loopback TX to RX at RS
  module mkConnection#(GMII_TX_RS t, GMII_RX_RS r)(Empty);
    rule connect_1;
       r.rxd(t.txd);
       r.rx_dv(t.tx_en);
       r.rx_er(t.tx_er);
    endrule
  endmodule
endinstance

endpackage: GMAC
