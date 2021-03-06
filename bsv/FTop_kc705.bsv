// FTop_kc705.bsv 
// Copyright (c) 2013 Atomic Rules LLC - ALL RIGHTS RESERVED
// Shepard Siegel

import ABS            ::*;
import ARAXI4L        ::*; 
import A4LS           ::*; 
import E8023          ::*;
import GMAC           ::*;
import HCrt           ::*;
import L2HCrt         ::*;
import I2C            ::*;
import LCDController  ::*;
import L2Proc         ::*;
//import MDIO           ::*;
import XilinxCells    ::*;
import XilinxExtra    ::*;

import BRAM           ::*;
import Clocks         ::*;
import Connectable    ::*;
import DReg           ::*;
import FIFO           ::*;
import GetPut         ::*;
import Vector         ::*;

// Data format of each 32b word in the iicrom BRAM...
typedef struct {
  Bit#(8) spare;  // unused
  Bit#(8) sa;     // 7b device addr; b0 = R/^W
  Bit#(8) addr;   // 8b register address
  Bit#(8) data;   // 8b write data
} I2CInst deriving (Bits, Eq);

(* always_ready *)
interface FTop_kc705Ifc;
  method Bit#(8)      led;
  interface I2C_Pins  i2cpad;
  interface LCD       lcd;
  interface Reset     gmii_rstn;    // GMII Reset driven out to Phy
  interface Clock     rxclk_ModBnd; // GMII RX Clock (provided here for BSV module-bouds interface rules)  
  interface GMII_RS   gmii;         // The GMII link RX/TX
//interface MDIO_Pads mdio;         // The MDIO pads
endinterface

(* synthesize, no_default_clock, no_default_reset, clock_prefix="", reset_prefix="" *)
module mkFTop_kc705#(Clock sys0_clk , Reset sys0_rstn,
                     Clock sys1_clkp, Clock sys1_clkn,     // 125 MHz Ethernet XO Reference
                     Clock gmii_rx_clk)(FTop_kc705Ifc);    // 125 MHz GMII RX Clock from Marvell Phy

  Reset           sys0_rst     <- mkAsyncReset(16, sys0_rstn, sys0_clk);

  //Clock           sys1_clki    <- mkClockIBUFDS_GTE2(True, sys1_clkp, sys1_clkn);
  //Clock           sys1_clk     <- mkClockBUFG(clocked_by sys1_clki);
  //Reset           sys1_rst     <- mkAsyncReset(1, sys0_rst, sys1_clk);

  Reg#(Bit#(32))  cycleCount   <- mkReg(0 ,           clocked_by sys0_clk, reset_by sys0_rst);
  I2C             i2cC         <- mkI2C(666 ,         clocked_by sys0_clk, reset_by sys0_rst); // 200MHz/(100KHz*3) 

  Reg#(Bool)       macAddrRead  <- mkReg(False ,      clocked_by sys0_clk, reset_by sys0_rst);
  Reg#(Bool)       selEepromOK  <- mkReg(False ,      clocked_by sys0_clk, reset_by sys0_rst);
  Reg#(UInt#(11))  macAddrCnt   <- mkReg(0 ,          clocked_by sys0_clk, reset_by sys0_rst);
  Reg#(UInt#(11))  macAddrRespCnt  <- mkReg(0 ,       clocked_by sys0_clk, reset_by sys0_rst);
  Reg#(Vector#(6,Bit#(8)))  macV   <- mkRegU(         clocked_by sys0_clk, reset_by sys0_rst);             
  ReadOnly#(Bit#(48)) uAddr <- mkNullCrossingWire(noClock, pack(macV));
  Reg#(Bool)      iicTG         <- mkDReg(False ,     clocked_by sys0_clk, reset_by sys0_rst);
  Reg#(Bool)      notFF         <- mkDReg(False ,     clocked_by sys0_clk, reset_by sys0_rst);

  Reg#(Bool)      iicGo        <- mkReg(False ,       clocked_by sys0_clk, reset_by sys0_rst);
  Reg#(Bool)      iicDone      <- mkReg(False ,       clocked_by sys0_clk, reset_by sys0_rst);
  Reg#(UInt#(10)) iicPtr       <- mkReg(0 ,           clocked_by sys0_clk, reset_by sys0_rst);
  LCDController   lcd_ctrl     <- mkLCDController(    clocked_by sys0_clk, reset_by sys0_rst);
  Reg#(Bool)      lcdNeedsInit <- mkReg(True ,        clocked_by sys0_clk, reset_by sys0_rst);
  IDELAYCTRL      idc          <- mkMYIDELAYCTRL(1,   clocked_by sys0_clk, reset_by sys0_rst);


`ifdef NO_L2HCRT
  GMACIfc         gmac         <- mkGMAC(gmii_rx_clk, sys1_clk, clocked_by sys1_clk, reset_by sys1_rst);
  MDIO            mdi          <- mkMDIO(6,                     clocked_by sys1_clk, reset_by sys1_rst);
  L2ProcIfc       l2P          <- mkL2Proc(                     clocked_by sys1_clk, reset_by sys1_rst);
  HCrtCompleter2AxiIfc crt2axi <- mkHCrtCompleter2Axi(          clocked_by sys1_clk, reset_by sys1_rst);
  A4L_Em          a4lm         <- mkA4MtoEm(crt2axi.axiM0,      clocked_by sys1_clk, reset_by sys1_rst); 
  ABS2QABSIfc     l2qc         <- mkABS2QABS(                   clocked_by sys1_clk, reset_by sys1_rst);
  QABS2ABSIfc     qcl2         <- mkQABS2ABS(                   clocked_by sys1_clk, reset_by sys1_rst);
`endif
  L2HCrtIfc       l2hcrt       <- mkL2HCrt(sys0_rst,sys1_clkp,sys1_clkn,gmii_rx_clk);
  Clock           sys1_clk     = l2hcrt.m_axi_aclk;
  Reset           sys1_rst     = l2hcrt.gmii_rstn;
  A4LSIfc         a4ls         <- mkA4LS(True,                  clocked_by sys1_clk, reset_by sys1_rst);
 
  mkConnection(l2hcrt.m_axi, a4ls.s_axi);
  //mkConnection(a4lm, a4ls);


  
  //ReadOnly#(Bit#(1)) eLed <- mkNullCrossingWire(noClock, pack(swap.eoptog));
  Bit#(1) eLed = 1'b0;

  BRAM_Configure cfg = defaultValue;
    cfg.memorySize = 1024;  // Number of DWORD entries in 4KB ROM
    cfg.latency    = 1;
    //                            v- synth
    //                               v- project
    //                                  v- vivado
    //                                     v- root
    cfg.loadFormat = tagged Hex "../../../../data/hdmi_iic.hex";
  BRAM1Port#(Bit#(10), Bit#(32)) iicrom <- mkBRAM1Server(cfg, clocked_by sys0_clk, reset_by sys0_rst);

  rule cycleCountAdvance;
    cycleCount <= cycleCount + 1;
  endrule

  rule simulationTermination (cycleCount==42000);
    $finish;
  endrule

  /*
  TODO: Read KC705 MAC address correctly from IIC EEPROM...

  rule read_iiceeprom_req ((macAddrCnt<1023) && !macAddrRead);
    if (!selEepromOK) begin
      i2cC.user.request(True, truncate(8'hE8>>1), 8'h08, 8'h08); // write to E8 with 0x08 select EEPROM bus 3 on U49
      selEepromOK <= True;
    end else begin
      macAddrCnt <= (macAddrCnt==1023) ? macAddrCnt : macAddrCnt + 1;
      i2cC.user.request(False, {5'b10101,pack(macAddrCnt)[9:8]}, pack(macAddrCnt)[7:0], 8'h00);  // Read Block 0 sequential first 32 Bytes
    end
  endrule

  rule read_iiceeprom_resp (!macAddrRead);
    let b <- i2cC.user.response;
    iicTG <= (b==8'h35 || b==8'hAC || b==8'h60);
    notFF <= (b!=8'hff);
    macV <= shiftInAt0(macV, b);
    macAddrRespCnt <= (macAddrRespCnt==1023) ? macAddrRespCnt : macAddrRespCnt + 1;
    macAddrRead <= (macAddrRespCnt==1023);
  endrule

  //mkConnection(unpack(pack(macV)), l2P.macAddr);  // drive uAddre from EEPROM into l2P module
  rule assign_mac;
    l2P.macAddr(unpack(uAddr));
  endrule
  */

  // Wait for 2^28 before starting off the show...
  rule iic_go_set (unpack(cycleCount[28]) && !iicGo && !iicDone);  
    iicGo <= True;
  endrule

  Bool allowRequest = (cycleCount[17:0] == 0); // 5nS * 256K =~ 1.2 mS / inst

  // Push read requests to iicrom BRAM...
  rule request_iicrom (iicGo && allowRequest);
    iicrom.portA.request.put(BRAMRequest {write:False, responseOnWrite:False, address:pack(iicPtr), datain:0});
    iicPtr <= iicPtr + 1;
    if (iicPtr==(14+57-1)) begin
      iicGo   <= False;
      iicDone <= True;
    end
  endrule

  // As read responses return, issue write requests to the I2C controller...
  rule response_iicrom;
    let r <- iicrom.portA.response.get;
    I2CInst i = unpack(r);
    i2cC.user.request(True, truncate(i.sa>>1), i.addr, i.data);
  endrule

  // Paint the LCD when the iic sequence is done...
  rule init_lcd (lcdNeedsInit && iicDone);
    Vector#(16,Bit#(8)) text1 = lcdLine("Atomic Rules LLC");
    Vector#(16,Bit#(8)) text2 = lcdLine("HCrt 2013.03.20a");
    //Vector#(16,Bit#(8)) text1 = lcdLine("Maxim Integrated");
    //Vector#(16,Bit#(8)) text2 = lcdLine("SG02/CA31:------");
    lcd_ctrl.setLine1(text1);
    lcd_ctrl.setLine2(text2);
    lcdNeedsInit <= False;
  endrule

  method Bit#(8) led;
    Bit#(4) y = truncate(cycleCount>>28);
    //Bit#(8) z = {y, 1'b1, eLed, pack(iicDone), pack(iicGo)};
    //Bit#(8) z = {y, pack(notFF), eLed, pack(iicDone), pack(iicGo)};
    Bit#(8) z = {y, pack(notFF), pack(iicTG), pack(iicDone), pack(iicGo)};
    return z;
  endmethod
  interface I2C_Pins i2cpad = i2cC.i2c;
  interface LCD lcd = lcd_ctrl.ifc;
  interface Reset       gmii_rstn    = sys1_rst;
  interface GMII_RS     gmii         = l2hcrt.gmii;
  interface Clock       rxclk_ModBnd = l2hcrt.rxclk_ModBnd;
//interface MDIO_Pads   mdio         = l2hcrt.mdio;

endmodule

// Generate RTL for a testbench too..
//module tb_mkFTop_kc705(Empty);
//  FTop_kc705Ifc dut <- mkFTop_kc705;
//endmodule
