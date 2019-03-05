//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: meisq                                                               //
//          msq@qq.com                                                          //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.cn/                                                //
//     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//2017/8/20                    1.0          Original
//*******************************************************************************/
module osd_display(
	input                       rst_n,   
	input                       pclk,
	input[15:0]                 number,
	input                       i_hs,    
	input                       i_vs,    
	input                       i_de,	
	input[23:0]                 i_data,  
	output                      o_hs,    
	output                      o_vs,    
	output                      o_de,    
	output[23:0]                o_data
);
parameter OSD_WIDTH   =  12'd64;
parameter OSD_HEGIHT  =  12'd32;
parameter OSD_ZONE1   =  12'd16;
parameter OSD_ZONE2   =  12'd32;
parameter OSD_ZONE3   =  12'd48;
parameter OSD_ZONE4   =  12'd64;

wire[11:0] pos_x;
wire[11:0] pos_y;
wire       pos_hs;
wire       pos_vs;
wire       pos_de;
wire[23:0] pos_data;
reg[23:0]  v_data0;
reg[23:0]  v_data1;
reg[23:0]  v_data2;
reg[23:0]  v_data3;
reg[23:0]  v_data4;
reg[23:0]  v_data5;
reg[23:0]  v_data6;
reg[23:0]  v_data7;
reg[23:0]  v_data8;
reg[23:0]  v_data9;
reg[23:0]  v_dataa;
reg[23:0]  v_datab;
reg[23:0]  v_datac;
reg[23:0]  v_datad;
reg[23:0]  v_datae;
reg[23:0]  v_dataf;
wire[3:0]  zone1_data = number[15:12];
wire[3:0]  zone2_data = number[11:8]; 
wire[3:0]  zone3_data = number[7:4];
wire[3:0]  zone4_data = number[3:0];
reg[11:0]  osd_x;
reg[11:0]  osd_y;
reg[15:0]  osd_ram_addr;
wire[7:0]  q0;
wire[7:0]  q1;
wire[7:0]  q2;
wire[7:0]  q3;
wire[7:0]  q4;
wire[7:0]  q5;
wire[7:0]  q6;
wire[7:0]  q7;
wire[7:0]  q8;
wire[7:0]  q9;
wire[7:0]  qa;
wire[7:0]  qb;
wire[7:0]  qc;
wire[7:0]  qd;
wire[7:0]  qe;
wire[7:0]  qf;
reg        region_active;
reg        region_active_d0;
reg        region_active_d1;
reg        region_active_d2;

reg        zone1_active;
reg        zone2_active;
reg        zone3_active;
reg        zone4_active;
reg        pos_vs_d0;
reg        pos_vs_d1;

wire[23:0]  z1_data = zone1_data==4'h0 ? v_data0 :
	              zone1_data==4'h1 ? v_data1 :
	              zone1_data==4'h2 ? v_data2 :
	              zone1_data==4'h3 ? v_data3 :
	              zone1_data==4'h4 ? v_data4 :
	              zone1_data==4'h5 ? v_data5 :
	              zone1_data==4'h6 ? v_data6 :
	              zone1_data==4'h7 ? v_data7 :
	              zone1_data==4'h8 ? v_data8 :
	              zone1_data==4'h9 ? v_data9 :
	              zone1_data==4'ha ? v_dataa :
	              zone1_data==4'hb ? v_datab :
	              zone1_data==4'hc ? v_datac :
	              zone1_data==4'hd ? v_datad :
	              zone1_data==4'he ? v_datae : v_dataf;

wire[23:0]  z2_data = zone2_data==4'h0 ? v_data0 :
	              zone2_data==4'h1 ? v_data1 :
	              zone2_data==4'h2 ? v_data2 :
	              zone2_data==4'h3 ? v_data3 :
	              zone2_data==4'h4 ? v_data4 :
	              zone2_data==4'h5 ? v_data5 :
	              zone2_data==4'h6 ? v_data6 :
	              zone2_data==4'h7 ? v_data7 :
	              zone2_data==4'h8 ? v_data8 :
	              zone2_data==4'h9 ? v_data9 :
	              zone2_data==4'ha ? v_dataa :
	              zone2_data==4'hb ? v_datab :
	              zone2_data==4'hc ? v_datac :
	              zone2_data==4'hd ? v_datad :
	              zone2_data==4'he ? v_datae : v_dataf;

wire[23:0]  z3_data = zone3_data==4'h0 ? v_data0 :
	              zone3_data==4'h1 ? v_data1 :
	              zone3_data==4'h2 ? v_data2 :
	              zone3_data==4'h3 ? v_data3 :
	              zone3_data==4'h4 ? v_data4 :
	              zone3_data==4'h5 ? v_data5 :
	              zone3_data==4'h6 ? v_data6 :
	              zone3_data==4'h7 ? v_data7 :
	              zone3_data==4'h8 ? v_data8 :
	              zone3_data==4'h9 ? v_data9 :
	              zone3_data==4'ha ? v_dataa :
	              zone3_data==4'hb ? v_datab :
	              zone3_data==4'hc ? v_datac :
	              zone3_data==4'hd ? v_datad :
	              zone3_data==4'he ? v_datae : v_dataf;

wire[23:0]  z4_data = zone4_data==4'h0 ? v_data0 :
	              zone4_data==4'h1 ? v_data1 :
	              zone4_data==4'h2 ? v_data2 :
	              zone4_data==4'h3 ? v_data3 :
	              zone4_data==4'h4 ? v_data4 :
	              zone4_data==4'h5 ? v_data5 :
	              zone4_data==4'h6 ? v_data6 :
	              zone4_data==4'h7 ? v_data7 :
	              zone4_data==4'h8 ? v_data8 :
	              zone4_data==4'h9 ? v_data9 :
	              zone4_data==4'ha ? v_dataa :
	              zone4_data==4'hb ? v_datab :
	              zone4_data==4'hc ? v_datac :
	              zone4_data==4'hd ? v_datad :
	              zone4_data==4'he ? v_datae : v_dataf;

wire [23:0] v_data = zone1_active ? z1_data :
	             zone2_active ? z2_data :
		     zone3_active ? z3_data : z4_data;

assign o_data = v_data;
assign o_hs = pos_hs;
assign o_vs = pos_vs;
assign o_de = pos_de;
//delay 1 clock 
always@(posedge pclk)
begin
	if(pos_y >= 12'd9 && pos_y <= 12'd9 + OSD_HEGIHT - 12'd1 && pos_x >= 12'd9 && pos_x  <= 12'd9 + OSD_WIDTH - 12'd1)
		region_active <= 1'b1;
	else
		region_active <= 1'b0;
end

always@(posedge pclk)
begin
	if(pos_y >= 12'd9 && pos_y <= 12'd9 + OSD_HEGIHT - 12'd1 && pos_x >= 12'd9 && pos_x  <= 12'd9 + OSD_ZONE1 - 12'd1)
		zone1_active <= 1'b1;
	else
		zone1_active <= 1'b0;
end

always@(posedge pclk)
begin
	if(pos_y >= 12'd9 && pos_y <= 12'd9 + OSD_HEGIHT - 12'd1 && pos_x >= 12'd9 && pos_x  <= 12'd9 + OSD_ZONE2 - 12'd1)
		zone2_active <= 1'b1;
	else
		zone2_active <= 1'b0;
end

always@(posedge pclk)
begin
	if(pos_y >= 12'd9 && pos_y <= 12'd9 + OSD_HEGIHT - 12'd1 && pos_x >= 12'd9 && pos_x  <= 12'd9 + OSD_ZONE3 - 12'd1)
		zone3_active <= 1'b1;
	else
		zone3_active <= 1'b0;
end

always@(posedge pclk)
begin
	if(pos_y >= 12'd9 && pos_y <= 12'd9 + OSD_HEGIHT - 12'd1 && pos_x >= 12'd9 && pos_x  <= 12'd9 + OSD_ZONE4 - 12'd1)
		zone4_active <= 1'b1;
	else
		zone4_active <= 1'b0;
end

always@(posedge pclk)
begin
	region_active_d0 <= region_active;
	region_active_d1 <= region_active_d0;
	region_active_d2 <= region_active_d1;
end

always@(posedge pclk)
begin
	pos_vs_d0 <= pos_vs;
	pos_vs_d1 <= pos_vs_d0;
end

//delay 2 clock
//region_active_d0
always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		osd_x <= osd_x + 12'd1;
	else
		osd_x <= 12'd0;
end

always@(posedge pclk)
begin
	if(pos_vs_d1 == 1'b1 && pos_vs_d0 == 1'b0)
		osd_ram_addr <= 16'd0;
	else if(region_active == 1'b1)
		osd_ram_addr <= osd_ram_addr + 16'd1;
end


always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(q0[osd_x[2:0]] == 1'b1)
			v_data0 <= 24'hff0000;
		else
			v_data0 <= pos_data;
	else
		v_data0 <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(q1[osd_x[2:0]] == 1'b1)
			v_data1 <= 24'hff0000;
		else
			v_data1 <= pos_data;
	else
		v_data1 <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(q2[osd_x[2:0]] == 1'b1)
			v_data2 <= 24'hff0000;
		else
			v_data2 <= pos_data;
	else
		v_data2 <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(q3[osd_x[2:0]] == 1'b1)
			v_data3 <= 24'hff0000;
		else
			v_data3 <= pos_data;
	else
		v_data3 <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(q4[osd_x[2:0]] == 1'b1)
			v_data4 <= 24'hff0000;
		else
			v_data4 <= pos_data;
	else
		v_data4 <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(q5[osd_x[2:0]] == 1'b1)
			v_data5 <= 24'hff0000;
		else
			v_data5 <= pos_data;
	else
		v_data5 <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(q6[osd_x[2:0]] == 1'b1)
			v_data6 <= 24'hff0000;
		else
			v_data6 <= pos_data;
	else
		v_data6 <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(q7[osd_x[2:0]] == 1'b1)
			v_data7 <= 24'hff0000;
		else
			v_data7 <= pos_data;
	else
		v_data7 <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(q8[osd_x[2:0]] == 1'b1)
			v_data8 <= 24'hff0000;
		else
			v_data8 <= pos_data;
	else
		v_data8 <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(q9[osd_x[2:0]] == 1'b1)
			v_data9 <= 24'hff0000;
		else
			v_data9 <= pos_data;
	else
		v_data9 <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(qa[osd_x[2:0]] == 1'b1)
			v_dataa <= 24'hff0000;
		else
			v_dataa <= pos_data;
	else
		v_dataa <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(qb[osd_x[2:0]] == 1'b1)
			v_datab <= 24'hff0000;
		else
			v_datab <= pos_data;
	else
		v_datab <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(qc[osd_x[2:0]] == 1'b1)
			v_datac <= 24'hff0000;
		else
			v_datac <= pos_data;
	else
		v_datac <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(qd[osd_x[2:0]] == 1'b1)
			v_datad <= 24'hff0000;
		else
			v_datad <= pos_data;
	else
		v_datad <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(qe[osd_x[2:0]] == 1'b1)
			v_datae <= 24'hff0000;
		else
			v_datae <= pos_data;
	else
		v_datae <= pos_data;
end

always@(posedge pclk)
begin
	if(region_active_d0 == 1'b1)
		if(qf[osd_x[2:0]] == 1'b1)
			v_dataf <= 24'hff0000;
		else
			v_dataf <= pos_data;
	else
		v_dataf <= pos_data;
end

rom0 osd_rom_m0
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(q0)
);
rom1 osd_rom_m1
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(q1)
);
rom2 osd_rom_m2
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(q2)
);
rom3 osd_rom_m3
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(q3)
);
rom4 osd_rom_m4
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(q4)
);
rom5 osd_rom_m5
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(q5)
);
rom6 osd_rom_m6
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(q6)
);
rom7 osd_rom_m7
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(q7)
);
rom8 osd_rom_m8
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(q8)
);
rom9 osd_rom_m9
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(q9)
);
roma osd_rom_ma
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(qa)
);
romb osd_rom_mb
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(qb)
);
romc osd_rom_mc
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(qc)
);
romd osd_rom_md
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(qd)
);
rome osd_rom_me
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(qe)
);
romf osd_rom_mf
(
	.address(osd_ram_addr[15:3]),
	.clock(pclk),
	.q(qf)
);
timing_gen_xy timing_gen_xy_u0(
	.rst_n    (rst_n    ),
	.clk      (pclk     ),
	.i_hs     (i_hs     ),
	.i_vs     (i_vs     ),
	.i_de     (i_de     ),
	.i_data   (i_data   ),
	.o_hs     (pos_hs   ),
	.o_vs     (pos_vs   ),
	.o_de     (pos_de   ),
	.o_data   (pos_data ),
	.x        (pos_x    ),
	.y        (pos_y    )
);
endmodule
