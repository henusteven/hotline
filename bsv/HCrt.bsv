// HCrt.bsv - Hotline Command-Response Transaction (HCrt)
// Copyright (c) 2012,2013 Atomic Rules LLC - ALL RIGHTS RESERVED

package HCrt;

import ABS          ::*;
import ARAXI4L      ::*; 
import A4LS         ::*;   // for TB

import BRAMFIFO     ::*;
import ClientServer ::*; 
import Clocks       ::*;
import Connectable  ::*;
import DReg         ::*;
import FIFO         ::*;	
import GetPut       ::*;
import Vector       ::*;

typedef enum {
  NOP      = 2'h0,
  Write    = 2'h1,
  Read     = 2'h2,
  Response = 2'h3
} HCrtMesgType deriving (Bits, Eq);

typedef enum {
  OK       = 4'h0,
  Timeout  = 4'h1,
  Error    = 4'h2,
  RSVD     = 4'hF
} HCrtRespCode deriving (Bits, Eq);

typedef struct {  // CRH0 is Byte 0 of the 4B CRH and common to all CRH Types
  Bool          isDO;
  Bool          isAM64;
  HCrtMesgType  mesgt;
  Bit#(4)       tag;
} CRH0 deriving (Bits, Eq);

typedef struct {  // CRHNOP - NOP CR-Header
  Bool          isLast;
  Bit#(3)       rsvd28; // 3b unused in NOP
  UInt#(12)     adl;
  Bit#(8)       rsvd8;  // 8b unused in NOP
  CRH0          c0;
} CRHNOP deriving (Bits, Eq);

typedef struct {  // CRHWrite - Write CR-Header
  Bool          isLast;
  Bit#(3)       rsvd28; // 3b unused in Write
  UInt#(12)     adl;
  Bit#(4)       lastBE;
  Bit#(4)       firstBE;
  CRH0          c0;
} CRHWrite deriving (Bits, Eq);

typedef struct {  // CRHRead - Read CR-Header
  Bool          isLast;
  Bit#(3)       rsvd28; // 3b unused in Write
  UInt#(12)     adl;
  Bit#(4)       lastBE;
  Bit#(4)       firstBE;
  CRH0          c0;
} CRHRead deriving (Bits, Eq);

typedef struct {  // CRHResp - Reponse CR-Header
  Bool          isLast;
  Bit#(3)       rsvd28; // 3b unused in Resp
  UInt#(12)     adl;
  Bit#(4)       rsvd12;
  HCrtRespCode  respt;
  CRH0          c0;
} CRHResp deriving (Bits, Eq);

typedef union tagged {
  CRHNOP    NOP;
  CRHWrite  Write;
  CRHRead   Read;
  CRHResp   RespNOP;
  CRHResp   RespWrite;
  CRHResp   RespRead;
  void      Invalid;
} TagCRH deriving (Bits, Eq); 

typedef union tagged {
  void      Invalid;
  UInt#(32) A32;
  UInt#(64) A64;
} CmdAddr deriving (Bits, Eq);


// HctrCompleter2Axi - Hotline HCrt Completer to AXI4-L Master Bridge IP
// HCrt commands are received on crtS0.request; HCrt responses are sent back on crtS0.response
// And A4LMIfc is provided directly

// This implementation processes 32b (1 DWORD) per cycle. It has no explict notion of HCrt framing.
// Commands arriving are assumed correct to the protocol. 
// Certain datagram layers, such as Ethernet L2, may pad the inbound command requets with extra octets.
// This layer, not the datagram layer, can best understand how to consume excess input that is appended
// to messages. (e.g. Ethernet 64B minimum frame size). We have added logic to consume these extra cells
// added to the end of a compliant HCrt command request.

// TODO: Retransmittimg response when tag match received; Need a solution that works well
// for bulk reads. Perhaps consider a "Recyle Buffer"?
/*
interface RecycleBufferIfc;
  method Bool clear;        // reset buffer state to empty
  method Action enq(t arg)  // enq responses in buffer
  method Action commit(Bool)  //etc
endinterface
*/

interface HCrtCompleter2AxiIfc;
  interface Server#(Bit#(32),QABS)  crtS0; 
  interface A4LMIfc                 axiM0;
  (*always_ready*) method Bool      isActive;
  (*always_ready*) method Bool      isFaulted;
endinterface 

(* synthesize *)
module mkHCrtCompleter2Axi (HCrtCompleter2AxiIfc);

  Integer respBufSizeDW = 1024;  // 1024 DWORDs = 4KB

  // HCrt Command/Response FIFOs...
  FIFO#(Bit#(32))           crtCmdF       <- mkFIFO;        // Inbound  HCrt Commands
  FIFO#(QABS)               crtRespF      <- mkFIFO;        // Outbound HCrt Responses
  A4LMasterIfc              a4l           <- mkA4LMaster;   // The AXI4-Lite Master Interface
  // The internal state of the HCrt module...
  Reg#(Bool)                modActive     <- mkDReg(False); // Pulse indication of module activity
  Reg#(Bool)                modFaulted    <- mkDReg(False); // Pulse indication of module fault
  Reg#(TagCRH)              cmdCRH        <- mkReg(tagged Invalid);
  Reg#(Bool)                cmdIsLast     <- mkReg(False);  // Indicates LAST command of message
  Reg#(Bool)                cmdIsAM64     <- mkReg(False);  // True when command is a AM64 operation
  Reg#(Bool)                cmdIsDO       <- mkReg(False);  // True when command is a Discovery Operation (DO) 
  Reg#(Bool)                cmdIsRW       <- mkReg(False);  // True when command is a Read or Write Cycle

  Reg#(UInt#(12))           cmdAdlRemain  <- mkReg(0);      // Number of DWORDs, not incl CRH or Addr, that remain
  Reg#(UInt#(12))           rspAdlRemain  <- mkReg(0);
  Reg#(UInt#(12))           lclRspRemain  <- mkReg(0);      // Number of local responses remaining (used for aggregation)
  Reg#(Maybe#(Bit#(4)))     lastTag       <- mkReg(tagged Invalid);  // The last tag captured (valid or not)

  FIFO#(QABS)               respBufF      <- mkSizedBRAMFIFO(respBufSizeDW+1);
  Reg#(UInt#(12))           respBufCnt    <- mkReg(0);
  Reg#(Bool)                respBufTrig   <- mkReg(False);

  Reg#(TagCRH)              rspCRH        <- mkReg(tagged Invalid);
  Reg#(Bool)                rspActive     <- mkReg(False); 
  Reg#(UInt#(32))           sizInitRespB  <- mkReg(0);      // Size in Bytes of the Initiator Resposne Buffer

  Reg#(CmdAddr)             addrAccu      <- mkReg(tagged Invalid);  // The target read or write address
  Reg#(Bit#(32))            addrTmp       <- mkRegU;        // Temp storage for loading AM64 to addrAccu
  Reg#(UInt#(2))            addrCaptCnt   <- mkRegU;        // Number of address word captured this command
  Reg#(Bool)                addrCaptOK    <- mkReg(False);  // True when OK to take inF words for Address

  Reg#(Bool)                crtBusy       <- mkReg(False);  // Used to enforce sequential command-response w/o overlap

  Reg#(Bool)                cmdRdHead     <- mkReg(True);
  Reg#(Bit#(32))            cmdAddrAccu   <- mkRegU;

  Bit#(32) targAdvert = fromInteger(respBufSizeDW*4);

  // Fire and take a new CRH DWORD...
  rule cmd_crh (cmdCRH matches tagged Invalid .crh &&& !crtBusy);
    let x = crtCmdF.first; crtCmdF.deq;   // Dequeue the new CRH Dword
    if (x!=0) begin                       // CRH DWORDs are never 0; chomp until non-zero
      HCrtMesgType cmt = unpack(x[5:4]);  // Decide what kind of message this is
      TagCRH t = ?;
      case (cmt)
        NOP:      action t = (tagged NOP      unpack(x)); cmdAdlRemain<=unpack(x[27:16]); endaction
        Write:    action t = (tagged Write    unpack(x)); cmdAdlRemain<=unpack(x[27:16]); lclRspRemain<=unpack(x[27:16]); cmdIsRW<=True; endaction
        Read:     action t = (tagged Read     unpack(x)); cmdAdlRemain<=unpack(x[27:16]); lclRspRemain<=unpack(x[27:16]); cmdIsRW<=True; endaction
        Response: action modFaulted<=True; endaction // Completer does not expect a Response
      endcase
      cmdCRH <= t; // update state variable
      cmdIsAM64    <= unpack(x[6]); 
      cmdIsDO      <= unpack(x[7]); 
      addrCaptCnt  <= 0;
      cmdIsLast    <= unpack(x[31]);
      modActive    <= True;
      crtBusy      <= True;
      addrCaptOK   <= True;
    end
  endrule

  // Rule to process NOP Command Requests, consume ADL DWORDs of Initiator Advertisement
  rule cmd_nop (cmdCRH matches tagged NOP .n &&& rspCRH matches tagged Invalid &&& !cmdIsRW);
    let x = crtCmdF.first; crtCmdF.deq;
    cmdAdlRemain <= (cmdAdlRemain>0) ? cmdAdlRemain-1 : 0;
    if (cmdAdlRemain==2) sizInitRespB <= unpack(x);
    if (cmdAdlRemain==1) begin
      cmdCRH <= tagged Invalid;
      rspCRH <= tagged RespNOP CRHResp {isLast:True,rsvd28:0,adl:n.adl,rsvd12:0,respt:OK,
                               c0:CRH0{isDO:n.c0.isDO, isAM64:False, mesgt:Response, tag:n.c0.tag}};
    end
    if ( n.c0.isDO) cmdIsDO <= True;
    if (!n.c0.isDO) lastTag <= (tagged Invalid);  // non-DO NOPs Invalidate the lastTag so next command is always accepted
    $display("[%0d]: %m: Hcrt cmd_nop cmdAdlRemain:%0d data:%0x", $time, cmdAdlRemain, x);
    //if (True) respBufF.clear;  // Clear the response buffer before performing NOP
    modActive <= True;
  endrule

  // Rule to respond to NOP Command Requests...
  rule rsp_nop (rspCRH matches tagged RespNOP .n &&& crtBusy);
    Bool isEOM = rspActive && rspAdlRemain==1;
    rspActive    <= isEOM ? False : (rspAdlRemain!=1);
    rspAdlRemain <= (rspActive) ? rspAdlRemain-1 : n.adl;
    Bit#(32) advert = (rspAdlRemain==2) ? 32'h0000_0052 : 0;
    $display("[%0d]: %m: Hcrt rsp_nop rspAdlRemain:%0d advert:%0x", $time, rspAdlRemain, advert);
    Bit#(32) data = rspActive ? advert : pack(n); // Send Resp CRH in first, non-rspActive cycle
    QABS resp = qabsFromDword(data, isEOM);
    crtRespF.enq(resp);
    //if (!cmdIsDO) respBufF.enq(resp);
      if (isEOM) begin 
        rspCRH    <= tagged Invalid;
        cmdIsDO   <= False;
        cmdIsLast <= False;
        crtBusy   <= False;
      end
    modActive <= True;
  endrule

  // Load Address Accumulator with either A32 or A64 starting address
  // Rule to consume the one or two DWORDs of address that follow the CRH for Write and Read Commands
  // The cmd_write and cmd_read rules need only concern themsleves with incrementing the address and doing the accesses
  rule cmd_addr(addrAccu==tagged Invalid && cmdIsRW &&& crtBusy &&& addrCaptOK);
    let x = crtCmdF.first; crtCmdF.deq;  // Take a DWORD from the HCrt stream in any case...
    addrTmp <= x; 
    if (cmdIsAM64) begin
      if (addrCaptCnt==1) begin
        addrAccu <= tagged A64 unpack({addrTmp,x});
        addrCaptOK <= False;
      end
    end else begin
      addrAccu <= tagged A32 unpack(x);
      addrCaptOK <= False;
    end
    addrCaptCnt <= addrCaptCnt + 1;
  endrule

 
  // Rule to process Write Command Requests, it fires ADL times, one for each write data DWORD beat...
  rule cmd_write (cmdCRH matches tagged Write .n &&& addrAccu matches tagged A32 .a);
    let x = crtCmdF.first; crtCmdF.deq; // Get this DWORD of write data

    // Write ADL Sequencing...
    cmdAdlRemain <=  (cmdAdlRemain>0) ? cmdAdlRemain-1 : 0;
    Bool doneWithWrite = (cmdAdlRemain==1);

    // commitWrite if the lastTag is Valid and the tags dont match OR if the lastTag is Invalid OR a Discovery Op...
    Bool commitWrite = ((isValid(lastTag) && n.c0.tag!=fromMaybe(?,lastTag)) || !isValid(lastTag) || n.c0.isDO);
    if (True) begin
      if (commitWrite) a4l.f.wrAddr.enq(A4LAddrCmd{addr:pack(a), prot:aProtDflt});
      if (commitWrite) a4l.f.wrData.enq(A4LWrData {strb:n.firstBE,  data:x});
      if (doneWithWrite) cmdCRH   <= tagged Invalid; // Finalize this rule
      addrAccu <= (doneWithWrite)  ? tagged Invalid : tagged A32 (a+4); // Write address processing
      // Blind ACK the Write regardless if tag match or not...
      //TODO: When write responses are non-blind (from non-posted requests), make write machine use lastResp like Read
      //
      // Make the response as soon as we can, even though it will not be issued until after N OK responses return
      // Having rspCRH tagged RespWrite will enable agg_write and rsp_write
      rspCRH <= tagged RespWrite CRHResp {isLast:True,rsvd28:0,adl:0,rsvd12:0,respt:OK,
                                 c0:CRH0{isDO:False,isAM64:False,mesgt:Response,tag:n.c0.tag}};
      $display("[%0d]: %m: Hcrt cmd_write address:%0x data:%0x", $time, a, x);
    end
    if ( n.c0.isDO) cmdIsDO <= True;
    if (commitWrite && !n.c0.isDO) lastTag <= (tagged Valid n.c0.tag); // Capture the tag into lastTag
    //if (commitWrite) respBufferF.clear;  // Clear the response buffer before performing Write
    modActive <= True;
  endrule


  // Rule to aggregate local Write Command Completions, prior to issuing a response
  // Used to dequeue write responses from AXI until all have arrived
  rule agg_write (rspCRH matches tagged RespWrite .n &&& crtBusy &&& lclRspRemain>0);
    let awr = a4l.f.wrResp.first; //TODO: look at AXI write response code (assume OKAY for now)
    a4l.f.wrResp.deq;             // Implicit condition of read blocks until resp
    $display("[%0d]: %m: Hcrt agg_write, lclRspRemain:%0d", $time, lclRspRemain);
    lclRspRemain <= lclRspRemain-1;
    modActive <= True;
  endrule

  // Write Response does Acknowledge Aggregation
  // Do not make a Write Response until all the Writes have been posted
  // Make ONLY ONE Write Response for a write of N DWORDs

  // Rule to respond to Write Command Requests...
  rule rsp_write (rspCRH matches tagged RespWrite .n &&& crtBusy &&& lclRspRemain==0);
   QABS resp = qabsFromDword(pack(n), True);
   crtRespF.enq(resp);
   rspCRH <= tagged Invalid;
   cmdIsDO   <= False;
   cmdIsLast <= False;
   crtBusy   <= False;
   modActive <= True;
   $display("[%0d]: %m: Hcrt rsp_write sending aggregated write response", $time);
  endrule


  // Rule to process Read Command Requests
  // On a Read Command, this will fire ADL times
  rule cmd_read (cmdCRH matches tagged Read .n &&& addrAccu matches tagged A32 .a);
    // No Data to Consume, just read requests to issue...

    // Read ADL Sequencing...
    cmdAdlRemain <= (cmdAdlRemain>0) ? cmdAdlRemain-1 : 0;
    Bool doneWithRead = (cmdAdlRemain==1);

    // commitRead if the lastTag is Valid and the tags dont match OR if the lastTag is Invalid OR a Discovery Op
    Bool commitRead = ((isValid(lastTag) && n.c0.tag!=fromMaybe(?,lastTag)) || !isValid(lastTag) || n.c0.isDO);
    if (True) begin // FIXME : cmdAdr Dec
      if (commitRead) a4l.f.rdAddr.enq(A4LAddrCmd{addr:pack(a), prot:aProtDflt});
      if (doneWithRead) cmdCRH   <= tagged Invalid;
      addrAccu <= (doneWithRead)  ? tagged Invalid : tagged A32 (a+4); // Read address processing
      if (commitRead) begin
        rspCRH <= tagged RespRead CRHResp {isLast:True,rsvd28:0,adl:n.adl,rsvd12:0,respt:OK,
                                  c0:CRH0{isDO:False,isAM64:False,mesgt:Response,tag:n.c0.tag}};
        $display("[%0d]: %m: Hcrt cmd_read address:%0x", $time, a);
      end else begin
        $display("[%0d]: %m: Hcrt cmd_read *TAGS MATCH *address:%0x", $time, a);
        // TODO: Implement correct retransmission
        //crtRespF.enq(lastResp);   // Retransmit the lastResp since tags match
      end
    end
    if ( n.c0.isDO) cmdIsDO <= True;
    if (commitRead && !n.c0.isDO) lastTag <= (tagged Valid n.c0.tag); // Capture the tag into lastTag
    //if (commitRead) respBufferF.clear;  // Clear the response buffer before performing Read
    modActive <= True;
  endrule

  // Rule to respond to Read Command Requests...
  // Reads can come back slowly, causing underrun of lower-layer datagram TX (e.g. Ethernet)
  // if we depost word into the read reponse datagram more slowly than the media needs it.
  rule rsp_read (rspCRH matches tagged RespRead .n &&& crtBusy);
    Bool isEOM = rspActive && rspAdlRemain==1;
    rspActive    <= isEOM ? False : (rspAdlRemain!=1);
    rspAdlRemain <= (rspActive) ? rspAdlRemain-1 : n.adl;
    let ar = a4l.f.rdResp.first; //TODO: look at AXI read response code (assume OKAY for now)
    if (rspActive) begin
      a4l.f.rdResp.deq;             // Implicit condition of read blocks until resp
    end
    Bit#(32) data = rspActive ? ar.data : pack(n); // Send Resp CRH in first, non-rspActive cycle
    QABS resp = qabsFromDword(data, isEOM);
    //crtRespF.enq(resp);
    respBufF.enq(resp);
    respBufCnt <= respBufCnt+1;

    //if (!cmdIsDO) respBufferF.enq(resp);
      if (isEOM) begin
        $display("[%0d]: %m: Hcrt rsp_read got data:%0x", $time, data);
        rspCRH      <= tagged Invalid;
        cmdIsDO     <= False;
        cmdIsLast   <= False;
        crtBusy     <= False;
        respBufTrig <= True;
      end
    modActive <= True;
  endrule

  // When crt ends, push everything in respBufferF to crtRespF at once
  rule drain_rsp_read(respBufTrig);
    let x = respBufF.first;
    respBufF.deq;
    crtRespF.enq(x);
    respBufCnt <= respBufCnt - 1;
    respBufTrig <= !(respBufCnt==1);
  endrule

  interface Server crtS0;  // Facing the HCrt Packet Side
    interface request  = toPut(crtCmdF);
    interface response = toGet(crtRespF);
  endinterface
  interface A4LMIfc axiM0 = a4l.a4lm;
  method Bool isActive  = modActive;
  method Bool isFaulted = modFaulted;
endmodule

endpackage: HCrt
