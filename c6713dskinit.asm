;******************************************************************************
;* TMS320C6x C/C++ Codegen                                    PC Version 4.32 *
;* Date/Time created: Tue Apr 27 12:33:18 2004                                *
;******************************************************************************

;******************************************************************************
;* GLOBAL FILE PARAMETERS                                                     *
;*                                                                            *
;*   Architecture      : TMS320C671x                                          *
;*   Optimization      : Disabled                                             *
;*   Optimizing for    : Compile time, Ease of Development                    *
;*                       Based on options: no -o, no -ms                      *
;*   Endian            : Little                                               *
;*   Interrupt Thrshld : Disabled                                             *
;*   Memory Model      : Small                                                *
;*   Calls to RTS      : Near                                                 *
;*   Pipelining        : Disabled                                             *
;*   Memory Aliases    : Presume are aliases (pessimistic)                    *
;*   Debug Info        : COFF Debug                                           *
;*                                                                            *
;******************************************************************************

	.asg	A15, FP
	.asg	B14, DP
	.asg	B15, SP
	.global	$bss

	.file	"c6713dskinit.c"
	.global	_AIC_data
	.bss	_AIC_data,4,4
	.sym	_AIC_data,_AIC_data, 9, 2, 32, $$fake2
	.bss	_CODECEventId,4,4
	.sym	_CODECEventId,_CODECEventId, 14, 3, 32
	.bss	_poll,4,4
	.sym	_poll,_poll, 14, 3, 32

	.sect	".cinit"
	.align	8
	.field  	IR_1,32
	.field  	_AIC23CfgData+0,32
	.field  	0,32			; _AIC23CfgData._spcr @ 0
	.field  	160,32			; _AIC23CfgData._rcr @ 32
	.field  	160,32			; _AIC23CfgData._xcr @ 64
	.field  	536870913,32			; _AIC23CfgData._srgr @ 96
	.field  	0,32			; _AIC23CfgData._mcr @ 128
	.field  	0,32			; _AIC23CfgData._rcer @ 160
	.field  	0,32			; _AIC23CfgData._xcer @ 192
	.field  	3,32			; _AIC23CfgData._pcr @ 224
IR_1:	.set	32

	.sect	".text"
	.global	_AIC23CfgData
	.bss	_AIC23CfgData,32,4
	.sym	_AIC23CfgData,_AIC23CfgData, 8, 2, 256, $$fake1

	.sect	".cinit"
	.align	8
	.field  	IR_2,32
	.field  	_config+0,32
	.field  	23,32			; _config._regs[0] @ 0
	.field  	23,32			; _config._regs[1] @ 32
	.field  	505,32			; _config._regs[2] @ 64
	.field  	505,32			; _config._regs[3] @ 96
	.field  	17,32			; _config._regs[4] @ 128
	.field  	0,32			; _config._regs[5] @ 160
	.field  	0,32			; _config._regs[6] @ 192
	.field  	67,32			; _config._regs[7] @ 224
	.field  	129,32			; _config._regs[8] @ 256
	.field  	1,32			; _config._regs[9] @ 288
IR_2:	.set	40

	.sect	".text"
	.global	_config
	.bss	_config,40,4
	.sym	_config,_config, 8, 2, 320, _DSK6713_AIC23_Config
	.global	_hAIC23_handle
	.bss	_hAIC23_handle,4,4
	.sym	_hAIC23_handle,_hAIC23_handle, 4, 2, 32
;	C:\C6713\C6000\CGTOOLS\BIN\acp6x.exe -DCHIP_6713 --version=6710 -Ic:/c6713/c6000/bios/include -Ic:/c6713/C6000/dsk6713/include -Ic:/c6713/c6000/rtdx/include -Ic:/c6713/c6000/cgtools/include -q --keep_unneeded_types -m --i_output_file C:\WINDOWS\TEMP\TI727275_2 --template_info_file C:\WINDOWS\TEMP\TI727275_3 --object_file C:/c6713/myprojects/PSK/transmitter/Debug/c6713dskinit.obj --opt_shell 11 c6713dskinit.c -g -q -s -frC:/c6713/myprojects/PSK/transmitter/Debug -dCHIP_6713 -mv6710 

	.sect	".text"
	.global	_c6713_dsk_init
	.sym	_c6713_dsk_init,_c6713_dsk_init, 32, 2, 0
	.func	7
;----------------------------------------------------------------------
;   7 | void c6713_dsk_init()                           //dsp-peripheral initia
;     | lization                                                               
;----------------------------------------------------------------------

;******************************************************************************
;* FUNCTION NAME: _c6713_dsk_init                                             *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,SP                                      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP                                   *
;*   Local Frame Size  : 0 Args + 0 Auto + 4 Save = 4 byte                    *
;******************************************************************************
_c6713_dsk_init:
;** --------------------------------------------------------------------------*
	.line	2
           STW     .D2T2   B3,*SP--(8)       ; |8| 
           NOP             2
	.line	3
;----------------------------------------------------------------------
;   9 | DSK6713_init();                         //call BSL to init DSK-EMIF,PLL
;     | )                                                                      
;----------------------------------------------------------------------
           CALL    .S1     _DSK6713_init     ; |9| 
           MVKL    .S2     RL0,B3            ; |9| 
           MVKH    .S2     RL0,B3            ; |9| 
           NOP             3
RL0:       ; CALL OCCURS                     ; |9| 
	.line	5
;----------------------------------------------------------------------
;  11 | hAIC23_handle=DSK6713_AIC23_openCodec(0, &config);//handle(pointer) to
;     | codec                                                                  
;----------------------------------------------------------------------
           CALL    .S1     _DSK6713_AIC23_openCodec ; |11| 
           MVK     .S2     (_config-$bss),B4 ; |11| 
           MVKL    .S2     RL1,B3            ; |11| 
           ADD     .D2     DP,B4,B4          ; |11| 
           MVKH    .S2     RL1,B3            ; |11| 
           ZERO    .D1     A4                ; |11| 
RL1:       ; CALL OCCURS                     ; |11| 
           STW     .D2T1   A4,*+DP(_hAIC23_handle) ; |11| 
           NOP             2
	.line	6
;----------------------------------------------------------------------
;  12 | DSK6713_AIC23_setFreq(hAIC23_handle, fs);  //set sample rate           
;----------------------------------------------------------------------
           CALL    .S1     _DSK6713_AIC23_setFreq ; |12| 
           LDW     .D2T2   *+DP(_fs),B4      ; |12| 
           MVKL    .S2     RL2,B3            ; |12| 
           MVKH    .S2     RL2,B3            ; |12| 
           NOP             2
RL2:       ; CALL OCCURS                     ; |12| 
	.line	7
;----------------------------------------------------------------------
;  13 | MCBSP_config(DSK6713_AIC23_DATAHANDLE,&AIC23CfgData);//interface 32 bit
;     | s toAIC23                                                              
;----------------------------------------------------------------------
           MVKL    .S2     _MCBSP_config,B5  ; |13| 
           MVKH    .S2     _MCBSP_config,B5  ; |13| 
           CALL    .S2     B5                ; |13| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |13| 
           MVKL    .S2     RL3,B3            ; |13| 
           MVK     .S1     (_AIC23CfgData-$bss),A0 ; |13| 
           ADD     .L2X    DP,A0,B4          ; |13| 
           MVKH    .S2     RL3,B3            ; |13| 
RL3:       ; CALL OCCURS                     ; |13| 
	.line	9
;----------------------------------------------------------------------
;  15 | MCBSP_start(DSK6713_AIC23_DATAHANDLE, MCBSP_XMIT_START | MCBSP_RCV_STAR
;     | T |                                                                    
;  16 | MCBSP_SRGR_START | MCBSP_SRGR_FRAMESYNC, 220);//start data channel agai
;     | n                                                                      
;----------------------------------------------------------------------
           MVKL    .S1     _MCBSP_start,A0   ; |15| 
           MVKH    .S1     _MCBSP_start,A0   ; |15| 
           CALL    .S2X    A0                ; |15| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |15| 
           MVKL    .S2     RL4,B3            ; |15| 
           MVK     .S2     0xf,B4            ; |15| 
           MVKH    .S2     RL4,B3            ; |15| 
           MVK     .S1     0xdc,A6           ; |15| 
RL4:       ; CALL OCCURS                     ; |15| 
	.line	11
           LDW     .D2T2   *++SP(8),B3       ; |17| 
           NOP             4
           RET     .S2     B3                ; |17| 
           NOP             5
           ; BRANCH OCCURS                   ; |17| 
	.endfunc	17,000080000h,8



	.sect	".text"
	.global	_comm_poll
	.sym	_comm_poll,_comm_poll, 32, 2, 0
	.func	19
;----------------------------------------------------------------------
;  19 | void comm_poll()
;     |  //added for communication/init using polling                          
;----------------------------------------------------------------------

;******************************************************************************
;* FUNCTION NAME: _comm_poll                                                  *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,SP                                      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP                                   *
;*   Local Frame Size  : 0 Args + 0 Auto + 4 Save = 4 byte                    *
;******************************************************************************
_comm_poll:
;** --------------------------------------------------------------------------*
	.line	2
           STW     .D2T2   B3,*SP--(8)       ; |20| 
           NOP             2
	.line	3
;----------------------------------------------------------------------
;  21 | poll=1;                                         //1 if using polling   
;----------------------------------------------------------------------
           MVK     .S1     1,A0              ; |21| 
           STW     .D2T1   A0,*+DP(_poll)    ; |21| 
           NOP             2
	.line	4
;----------------------------------------------------------------------
;  22 | c6713_dsk_init();                                    //init DSP and cod
;     | ec                                                                     
;----------------------------------------------------------------------
           CALL    .S1     _c6713_dsk_init   ; |22| 
           MVKL    .S2     RL5,B3            ; |22| 
           MVKH    .S2     RL5,B3            ; |22| 
           NOP             3
RL5:       ; CALL OCCURS                     ; |22| 
	.line	5
           LDW     .D2T2   *++SP(8),B3       ; |23| 
           NOP             4
           RET     .S2     B3                ; |23| 
           NOP             5
           ; BRANCH OCCURS                   ; |23| 
	.endfunc	23,000080000h,8



	.sect	".text"
	.global	_comm_intr
	.sym	_comm_intr,_comm_intr, 32, 2, 0
	.func	25
;----------------------------------------------------------------------
;  25 | void comm_intr()
;     |  //for communication/init using interrupt                              
;----------------------------------------------------------------------

;******************************************************************************
;* FUNCTION NAME: _comm_intr                                                  *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,SP                                      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP                                   *
;*   Local Frame Size  : 0 Args + 0 Auto + 4 Save = 4 byte                    *
;******************************************************************************
_comm_intr:
;** --------------------------------------------------------------------------*
	.line	2
           STW     .D2T2   B3,*SP--(8)       ; |26| 
           NOP             2
	.line	3
;----------------------------------------------------------------------
;  27 | poll=0;                         //0 since not polling                  
;----------------------------------------------------------------------
           ZERO    .D2     B4                ; |27| 
           STW     .D2T2   B4,*+DP(_poll)    ; |27| 
           NOP             2
	.line	4
;----------------------------------------------------------------------
;  28 | IRQ_globalDisable();                 //disable interrupts              
;----------------------------------------------------------------------
           MVKL    .S1     _IRQ_globalDisable,A0 ; |28| 
           MVKH    .S1     _IRQ_globalDisable,A0 ; |28| 
           CALL    .S2X    A0                ; |28| 
           MVKL    .S2     RL6,B3            ; |28| 
           MVKH    .S2     RL6,B3            ; |28| 
           NOP             3
RL6:       ; CALL OCCURS                     ; |28| 
	.line	5
;----------------------------------------------------------------------
;  29 | c6713_dsk_init();                                       //init DSP and
;     | codec                                                                  
;----------------------------------------------------------------------
           CALL    .S1     _c6713_dsk_init   ; |29| 
           MVKL    .S2     RL7,B3            ; |29| 
           MVKH    .S2     RL7,B3            ; |29| 
           NOP             3
RL7:       ; CALL OCCURS                     ; |29| 
	.line	6
;----------------------------------------------------------------------
;  30 | CODECEventId=MCBSP_getXmtEventId(DSK6713_AIC23_codecdatahandle);//McBSP
;     | 1 Xmit                                                                 
;  32 | #ifndef using_bios                                              //do no
;     | t need to point to vector table                                        
;  33 | IRQ_setVecs(vectors);                           //point to the IRQ vect
;     | or table                                                               
;  34 | #endif
;     |          //since interrupt vector handles this                         
;----------------------------------------------------------------------
           MVKL    .S2     _MCBSP_getXmtEventId,B4 ; |30| 
           MVKH    .S2     _MCBSP_getXmtEventId,B4 ; |30| 
           CALL    .S2     B4                ; |30| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |30| 
           MVKL    .S2     RL8,B3            ; |30| 
           MVKH    .S2     RL8,B3            ; |30| 
           NOP             2
RL8:       ; CALL OCCURS                     ; |30| 
           STW     .D2T1   A4,*+DP(_CODECEventId) ; |30| 
           NOP             2
	.line	12
;----------------------------------------------------------------------
;  36 | IRQ_map(CODECEventId, 11);                      //map McBSP1 Xmit to IN
;     | T11                                                                    
;----------------------------------------------------------------------
           MVKL    .S1     _IRQ_map,A0       ; |36| 
           MVKH    .S1     _IRQ_map,A0       ; |36| 
           CALL    .S2X    A0                ; |36| 
           MVKL    .S2     RL9,B3            ; |36| 
           MVK     .S2     0xb,B4            ; |36| 
           MVKH    .S2     RL9,B3            ; |36| 
           NOP             2
RL9:       ; CALL OCCURS                     ; |36| 
	.line	13
;----------------------------------------------------------------------
;  37 | IRQ_reset(CODECEventId);                //reset codec INT 11           
;----------------------------------------------------------------------
           MVKL    .S1     _IRQ_reset,A0     ; |37| 
           MVKH    .S1     _IRQ_reset,A0     ; |37| 
           CALL    .S2X    A0                ; |37| 
           LDW     .D2T1   *+DP(_CODECEventId),A4 ; |37| 
           MVKL    .S2     RL10,B3           ; |37| 
           MVKH    .S2     RL10,B3           ; |37| 
           NOP             2
RL10:      ; CALL OCCURS                     ; |37| 
	.line	14
;----------------------------------------------------------------------
;  38 | IRQ_globalEnable();                          //globally enable interrup
;     | ts                                                                     
;----------------------------------------------------------------------
           MVKL    .S1     _IRQ_globalEnable,A0 ; |38| 
           MVKH    .S1     _IRQ_globalEnable,A0 ; |38| 
           CALL    .S2X    A0                ; |38| 
           MVKL    .S2     RL11,B3           ; |38| 
           MVKH    .S2     RL11,B3           ; |38| 
           NOP             3
RL11:      ; CALL OCCURS                     ; |38| 
	.line	15
;----------------------------------------------------------------------
;  39 | IRQ_nmiEnable();                                //enable NMI interrupt 
;----------------------------------------------------------------------
           MVKL    .S2     _IRQ_nmiEnable,B4 ; |39| 
           MVKH    .S2     _IRQ_nmiEnable,B4 ; |39| 
           CALL    .S2     B4                ; |39| 
           MVKL    .S2     RL12,B3           ; |39| 
           MVKH    .S2     RL12,B3           ; |39| 
           NOP             3
RL12:      ; CALL OCCURS                     ; |39| 
	.line	16
;----------------------------------------------------------------------
;  40 | IRQ_enable(CODECEventId);                    //enable CODEC eventXmit I
;     | NT11                                                                   
;----------------------------------------------------------------------
           MVKL    .S1     _IRQ_enable,A0    ; |40| 
           MVKH    .S1     _IRQ_enable,A0    ; |40| 
           CALL    .S2X    A0                ; |40| 
           LDW     .D2T1   *+DP(_CODECEventId),A4 ; |40| 
           MVKL    .S2     RL13,B3           ; |40| 
           MVKH    .S2     RL13,B3           ; |40| 
           NOP             2
RL13:      ; CALL OCCURS                     ; |40| 
	.line	18
;----------------------------------------------------------------------
;  42 | output_sample(0);                               //start McBSP interrupt
;     |  outputting a sample                                                   
;----------------------------------------------------------------------
           CALL    .S1     _output_sample    ; |42| 
           MVKL    .S2     RL14,B3           ; |42| 
           MVKH    .S2     RL14,B3           ; |42| 
           ZERO    .D1     A4                ; |42| 
           NOP             2
RL14:      ; CALL OCCURS                     ; |42| 
	.line	19
           LDW     .D2T2   *++SP(8),B3       ; |43| 
           NOP             4
           RET     .S2     B3                ; |43| 
           NOP             5
           ; BRANCH OCCURS                   ; |43| 
	.endfunc	43,000080000h,8



	.sect	".text"
	.global	_output_sample
	.sym	_output_sample,_output_sample, 32, 2, 0
	.func	45
;----------------------------------------------------------------------
;  45 | void output_sample(int out_data)    //for out to Left and Right channel
;     | s                                                                      
;----------------------------------------------------------------------

;******************************************************************************
;* FUNCTION NAME: _output_sample                                              *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,SP                                      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP                                   *
;*   Local Frame Size  : 0 Args + 8 Auto + 4 Save = 12 byte                   *
;******************************************************************************
_output_sample:
;** --------------------------------------------------------------------------*
	.line	2
	.sym	_out_data,4, 4, 17, 32
	.sym	_out_data,4, 4, 1, 32
	.sym	_CHANNEL_data,8, 3, 1, 16
           STW     .D2T2   B3,*SP--(16)      ; |46| 
           NOP             2
;----------------------------------------------------------------------
;  47 | short CHANNEL_data;                                                    
;----------------------------------------------------------------------
           STW     .D2T1   A4,*+SP(4)        ; |46| 
           NOP             2
	.line	5
;----------------------------------------------------------------------
;  49 | AIC_data.uint=0;                 //clear data structure                
;----------------------------------------------------------------------
           ZERO    .D2     B4                ; |49| 
           STW     .D2T2   B4,*+DP(_AIC_data) ; |49| 
           NOP             2
	.line	6
;----------------------------------------------------------------------
;  50 | AIC_data.uint=out_data;          //32-bit data -->data structure       
;  52 | //The existing interface defaults to right channel. To default instead
;     | to the                                                                 
;  53 | //left channel and use output_sample(short), left and right channels ar
;     | e swapped                                                              
;  54 | //In main source program use LEFT 0 and RIGHT 1 (opposite of what is us
;     | ed here)                                                               
;----------------------------------------------------------------------
           LDW     .D2T2   *+SP(4),B4        ; |50| 
           NOP             4
           STW     .D2T2   B4,*+DP(_AIC_data) ; |50| 
           NOP             2
	.line	11
;----------------------------------------------------------------------
;  55 | CHANNEL_data=AIC_data.channel[RIGHT];                   //swap left and
;     |  right channels                                                        
;----------------------------------------------------------------------
           LDH     .D2T2   *+DP(_AIC_data),B4 ; |55| 
           NOP             4
           STH     .D2T2   B4,*+SP(8)        ; |55| 
           NOP             2
	.line	12
;----------------------------------------------------------------------
;  56 | AIC_data.channel[RIGHT]=AIC_data.channel[LEFT];                        
;----------------------------------------------------------------------
           LDH     .D2T2   *+DP(_AIC_data+2),B4 ; |56| 
           NOP             4
           STH     .D2T2   B4,*+DP(_AIC_data) ; |56| 
           NOP             2
	.line	13
;----------------------------------------------------------------------
;  57 | AIC_data.channel[LEFT]=CHANNEL_data;                                   
;----------------------------------------------------------------------
           LDH     .D2T2   *+SP(8),B4        ; |57| 
           NOP             4
           STH     .D2T2   B4,*+DP(_AIC_data+2) ; |57| 
           NOP             2
	.line	14
;----------------------------------------------------------------------
;  58 | if (poll) while(!MCBSP_xrdy(DSK6713_AIC23_DATAHANDLE));//if ready to tr
;     | ansmit                                                                 
;----------------------------------------------------------------------
           LDW     .D2T2   *+DP(_poll),B0    ; |58| 
           MVKL    .S2     RL15,B3           ; |58| 
           MVKH    .S2     RL15,B3           ; |58| 
           MVKL    .S2     _MCBSP_xrdy,B4    ; |58| 
           MVKH    .S2     _MCBSP_xrdy,B4    ; |58| 
   [!B0]   B       .S1     L2                ; |58| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |58| 
           NOP             4
           ; BRANCH OCCURS                   ; |58| 
;** --------------------------------------------------------------------------*
           CALL    .S2     B4                ; |58| 
           NOP             5
RL15:      ; CALL OCCURS                     ; |58| 
           MV      .D1     A4,A1             ; |58| 
   [ A1]   B       .S1     L2                ; |58| 
           NOP             5
           ; BRANCH OCCURS                   ; |58| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Software pipelining disabled
;*----------------------------------------------------------------------------*
L1:    
           MVKL    .S2     _MCBSP_xrdy,B4    ; |58| 
           MVKH    .S2     _MCBSP_xrdy,B4    ; |58| 
           CALL    .S2     B4                ; |58| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |58| 
           MVKL    .S2     RL16,B3           ; |58| 
           MVKH    .S2     RL16,B3           ; |58| 
           NOP             2
RL16:      ; CALL OCCURS                     ; |58| 
           MV      .D1     A4,A1             ; |58| 
   [!A1]   B       .S1     L1                ; |58| 
           NOP             5
           ; BRANCH OCCURS                   ; |58| 
;** --------------------------------------------------------------------------*
L2:    
           NOP             2
	.line	15
;----------------------------------------------------------------------
;  59 | MCBSP_write(DSK6713_AIC23_DATAHANDLE,AIC_data.uint);//write/output data
;----------------------------------------------------------------------
           MVKL    .S1     _MCBSP_write,A0   ; |59| 
           MVKH    .S1     _MCBSP_write,A0   ; |59| 

           CALL    .S2X    A0                ; |59| 
||         LDW     .D2T2   *+DP(_AIC_data),B4 ; |59| 

           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |59| 
           MVKL    .S2     RL17,B3           ; |59| 
           MVKH    .S2     RL17,B3           ; |59| 
           NOP             2
RL17:      ; CALL OCCURS                     ; |59| 
	.line	16
           LDW     .D2T2   *++SP(16),B3      ; |60| 
           NOP             4
           RET     .S2     B3                ; |60| 
           NOP             5
           ; BRANCH OCCURS                   ; |60| 
	.endfunc	60,000080000h,16



	.sect	".text"
	.global	_output_left_sample
	.sym	_output_left_sample,_output_left_sample, 32, 2, 0
	.func	62
;----------------------------------------------------------------------
;  62 | void output_left_sample(short out_data)                  //for output f
;     | rom left channel                                                       
;----------------------------------------------------------------------

;******************************************************************************
;* FUNCTION NAME: _output_left_sample                                         *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,SP                                      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP                                   *
;*   Local Frame Size  : 0 Args + 4 Auto + 4 Save = 8 byte                    *
;******************************************************************************
_output_left_sample:
;** --------------------------------------------------------------------------*
	.line	2
	.sym	_out_data,4, 3, 17, 16
	.sym	_out_data,4, 3, 1, 16
           STW     .D2T2   B3,*SP--(8)       ; |63| 
           NOP             2
           STH     .D2T1   A4,*+SP(4)        ; |63| 
           NOP             2
	.line	3
;----------------------------------------------------------------------
;  64 | AIC_data.uint=0;                              //clear data structure   
;----------------------------------------------------------------------
           ZERO    .D2     B4                ; |64| 
           STW     .D2T2   B4,*+DP(_AIC_data) ; |64| 
           NOP             2
	.line	4
;----------------------------------------------------------------------
;  65 | AIC_data.channel[LEFT]=out_data;   //data from Left channel -->data str
;     | ucture                                                                 
;----------------------------------------------------------------------
           LDH     .D2T2   *+SP(4),B4        ; |65| 
           NOP             4
           STH     .D2T2   B4,*+DP(_AIC_data+2) ; |65| 
           NOP             2
	.line	6
;----------------------------------------------------------------------
;  67 | if (poll) while(!MCBSP_xrdy(DSK6713_AIC23_DATAHANDLE));//if ready to tr
;     | ansmit                                                                 
;----------------------------------------------------------------------
           LDW     .D2T2   *+DP(_poll),B0    ; |67| 
           MVKL    .S2     RL18,B3           ; |67| 
           MVKH    .S2     RL18,B3           ; |67| 
           MVKL    .S2     _MCBSP_xrdy,B4    ; |67| 
           MVKH    .S2     _MCBSP_xrdy,B4    ; |67| 
   [!B0]   B       .S1     L4                ; |67| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |67| 
           NOP             4
           ; BRANCH OCCURS                   ; |67| 
;** --------------------------------------------------------------------------*
           CALL    .S2     B4                ; |67| 
           NOP             5
RL18:      ; CALL OCCURS                     ; |67| 
           MV      .D1     A4,A1             ; |67| 
   [ A1]   B       .S1     L4                ; |67| 
           NOP             5
           ; BRANCH OCCURS                   ; |67| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Software pipelining disabled
;*----------------------------------------------------------------------------*
L3:    
           MVKL    .S2     _MCBSP_xrdy,B4    ; |67| 
           MVKH    .S2     _MCBSP_xrdy,B4    ; |67| 
           CALL    .S2     B4                ; |67| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |67| 
           MVKL    .S2     RL19,B3           ; |67| 
           MVKH    .S2     RL19,B3           ; |67| 
           NOP             2
RL19:      ; CALL OCCURS                     ; |67| 
           MV      .D1     A4,A1             ; |67| 
   [!A1]   B       .S1     L3                ; |67| 
           NOP             5
           ; BRANCH OCCURS                   ; |67| 
;** --------------------------------------------------------------------------*
L4:    
           NOP             2
	.line	7
;----------------------------------------------------------------------
;  68 | MCBSP_write(DSK6713_AIC23_DATAHANDLE,AIC_data.uint);//output left chann
;     | el                                                                     
;----------------------------------------------------------------------
           MVKL    .S1     _MCBSP_write,A0   ; |68| 
           MVKH    .S1     _MCBSP_write,A0   ; |68| 

           CALL    .S2X    A0                ; |68| 
||         LDW     .D2T2   *+DP(_AIC_data),B4 ; |68| 

           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |68| 
           MVKL    .S2     RL20,B3           ; |68| 
           MVKH    .S2     RL20,B3           ; |68| 
           NOP             2
RL20:      ; CALL OCCURS                     ; |68| 
	.line	8
           LDW     .D2T2   *++SP(8),B3       ; |69| 
           NOP             4
           RET     .S2     B3                ; |69| 
           NOP             5
           ; BRANCH OCCURS                   ; |69| 
	.endfunc	69,000080000h,8



	.sect	".text"
	.global	_output_right_sample
	.sym	_output_right_sample,_output_right_sample, 32, 2, 0
	.func	71
;----------------------------------------------------------------------
;  71 | void output_right_sample(short out_data)                //for output fr
;     | om right channel                                                       
;----------------------------------------------------------------------

;******************************************************************************
;* FUNCTION NAME: _output_right_sample                                        *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,SP                                      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP                                   *
;*   Local Frame Size  : 0 Args + 4 Auto + 4 Save = 8 byte                    *
;******************************************************************************
_output_right_sample:
;** --------------------------------------------------------------------------*
	.line	2
	.sym	_out_data,4, 3, 17, 16
	.sym	_out_data,4, 3, 1, 16
           STW     .D2T2   B3,*SP--(8)       ; |72| 
           NOP             2
           STH     .D2T1   A4,*+SP(4)        ; |72| 
           NOP             2
	.line	3
;----------------------------------------------------------------------
;  73 | AIC_data.uint=0;                             //clear data structure    
;----------------------------------------------------------------------
           ZERO    .D2     B4                ; |73| 
           STW     .D2T2   B4,*+DP(_AIC_data) ; |73| 
           NOP             2
	.line	4
;----------------------------------------------------------------------
;  74 | AIC_data.channel[RIGHT]=out_data; //data from Right channel -->data str
;     | ucture                                                                 
;----------------------------------------------------------------------
           LDH     .D2T2   *+SP(4),B4        ; |74| 
           NOP             4
           STH     .D2T2   B4,*+DP(_AIC_data) ; |74| 
           NOP             2
	.line	6
;----------------------------------------------------------------------
;  76 | if (poll) while(!MCBSP_xrdy(DSK6713_AIC23_DATAHANDLE));//if ready to tr
;     | ansmit                                                                 
;----------------------------------------------------------------------
           LDW     .D2T2   *+DP(_poll),B0    ; |76| 
           MVKL    .S2     RL21,B3           ; |76| 
           MVKH    .S2     RL21,B3           ; |76| 
           MVKL    .S2     _MCBSP_xrdy,B4    ; |76| 
           MVKH    .S2     _MCBSP_xrdy,B4    ; |76| 
   [!B0]   B       .S1     L6                ; |76| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |76| 
           NOP             4
           ; BRANCH OCCURS                   ; |76| 
;** --------------------------------------------------------------------------*
           CALL    .S2     B4                ; |76| 
           NOP             5
RL21:      ; CALL OCCURS                     ; |76| 
           MV      .D1     A4,A1             ; |76| 
   [ A1]   B       .S1     L6                ; |76| 
           NOP             5
           ; BRANCH OCCURS                   ; |76| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Software pipelining disabled
;*----------------------------------------------------------------------------*
L5:    
           MVKL    .S2     _MCBSP_xrdy,B4    ; |76| 
           MVKH    .S2     _MCBSP_xrdy,B4    ; |76| 
           CALL    .S2     B4                ; |76| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |76| 
           MVKL    .S2     RL22,B3           ; |76| 
           MVKH    .S2     RL22,B3           ; |76| 
           NOP             2
RL22:      ; CALL OCCURS                     ; |76| 
           MV      .D1     A4,A1             ; |76| 
   [!A1]   B       .S1     L5                ; |76| 
           NOP             5
           ; BRANCH OCCURS                   ; |76| 
;** --------------------------------------------------------------------------*
L6:    
           NOP             2
	.line	7
;----------------------------------------------------------------------
;  77 | MCBSP_write(DSK6713_AIC23_DATAHANDLE,AIC_data.uint);//output right chan
;     | nel                                                                    
;----------------------------------------------------------------------
           MVKL    .S1     _MCBSP_write,A0   ; |77| 
           MVKH    .S1     _MCBSP_write,A0   ; |77| 

           CALL    .S2X    A0                ; |77| 
||         LDW     .D2T2   *+DP(_AIC_data),B4 ; |77| 

           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |77| 
           MVKL    .S2     RL23,B3           ; |77| 
           MVKH    .S2     RL23,B3           ; |77| 
           NOP             2
RL23:      ; CALL OCCURS                     ; |77| 
	.line	8
           LDW     .D2T2   *++SP(8),B3       ; |78| 
           NOP             4
           RET     .S2     B3                ; |78| 
           NOP             5
           ; BRANCH OCCURS                   ; |78| 
	.endfunc	78,000080000h,8



	.sect	".text"
	.global	_input_sample
	.sym	_input_sample,_input_sample, 46, 2, 0
	.func	80
;----------------------------------------------------------------------
;  80 | Uint32 input_sample()                                   //for 32-bit in
;     | put                                                                    
;----------------------------------------------------------------------

;******************************************************************************
;* FUNCTION NAME: _input_sample                                               *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,SP                                      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP                                   *
;*   Local Frame Size  : 0 Args + 4 Auto + 4 Save = 8 byte                    *
;******************************************************************************
_input_sample:
;** --------------------------------------------------------------------------*
	.line	2
;----------------------------------------------------------------------
;  82 | short CHANNEL_data;                                                    
;----------------------------------------------------------------------
	.sym	_CHANNEL_data,4, 3, 1, 16
           STW     .D2T2   B3,*SP--(8)       ; |81| 
           NOP             2
	.line	5
;----------------------------------------------------------------------
;  84 | if (poll) while(!MCBSP_rrdy(DSK6713_AIC23_DATAHANDLE));//if ready to re
;     | ceive                                                                  
;----------------------------------------------------------------------
           LDW     .D2T2   *+DP(_poll),B0    ; |84| 
           MVKL    .S2     _MCBSP_rrdy,B4    ; |84| 
           MVKL    .S2     RL24,B3           ; |84| 
           MVKH    .S2     _MCBSP_rrdy,B4    ; |84| 
           MVKH    .S2     RL24,B3           ; |84| 
   [!B0]   B       .S1     L8                ; |84| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |84| 
           NOP             4
           ; BRANCH OCCURS                   ; |84| 
;** --------------------------------------------------------------------------*
           CALL    .S2     B4                ; |84| 
           NOP             5
RL24:      ; CALL OCCURS                     ; |84| 
           MV      .D1     A4,A1             ; |84| 
   [ A1]   B       .S1     L8                ; |84| 
           NOP             5
           ; BRANCH OCCURS                   ; |84| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Software pipelining disabled
;*----------------------------------------------------------------------------*
L7:    
           MVKL    .S2     _MCBSP_rrdy,B4    ; |84| 
           MVKH    .S2     _MCBSP_rrdy,B4    ; |84| 
           CALL    .S2     B4                ; |84| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |84| 
           MVKL    .S2     RL25,B3           ; |84| 
           MVKH    .S2     RL25,B3           ; |84| 
           NOP             2
RL25:      ; CALL OCCURS                     ; |84| 
           MV      .D1     A4,A1             ; |84| 
   [!A1]   B       .S1     L7                ; |84| 
           NOP             5
           ; BRANCH OCCURS                   ; |84| 
;** --------------------------------------------------------------------------*
L8:    
           NOP             2
	.line	6
;----------------------------------------------------------------------
;  85 | AIC_data.uint=MCBSP_read(DSK6713_AIC23_DATAHANDLE);//read data         
;  87 | //Swapping left and right channels (see comments in output_sample())   
;----------------------------------------------------------------------
           MVKL    .S1     _MCBSP_read,A0    ; |85| 
           MVKH    .S1     _MCBSP_read,A0    ; |85| 
           CALL    .S2X    A0                ; |85| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |85| 
           MVKL    .S2     RL26,B3           ; |85| 
           MVKH    .S2     RL26,B3           ; |85| 
           NOP             2
RL26:      ; CALL OCCURS                     ; |85| 
           STW     .D2T1   A4,*+DP(_AIC_data) ; |85| 
           NOP             2
	.line	9
;----------------------------------------------------------------------
;  88 | CHANNEL_data=AIC_data.channel[RIGHT];                   //swap left and
;     |  right channel                                                         
;----------------------------------------------------------------------
           LDH     .D2T2   *+DP(_AIC_data),B4 ; |88| 
           NOP             4
           STH     .D2T2   B4,*+SP(4)        ; |88| 
           NOP             2
	.line	10
;----------------------------------------------------------------------
;  89 | AIC_data.channel[RIGHT]=AIC_data.channel[LEFT];                        
;----------------------------------------------------------------------
           LDH     .D2T2   *+DP(_AIC_data+2),B4 ; |89| 
           NOP             4
           STH     .D2T2   B4,*+DP(_AIC_data) ; |89| 
           NOP             2
	.line	11
;----------------------------------------------------------------------
;  90 | AIC_data.channel[LEFT]=CHANNEL_data;                                   
;----------------------------------------------------------------------
           LDH     .D2T2   *+SP(4),B4        ; |90| 
           NOP             4
           STH     .D2T2   B4,*+DP(_AIC_data+2) ; |90| 
           NOP             2
	.line	13
;----------------------------------------------------------------------
;  92 | return(AIC_data.uint);                                                 
;----------------------------------------------------------------------
           LDW     .D2T1   *+DP(_AIC_data),A4 ; |92| 
           NOP             4
	.line	14
           LDW     .D2T2   *++SP(8),B3       ; |93| 
           NOP             4
           RET     .S2     B3                ; |93| 
           NOP             5
           ; BRANCH OCCURS                   ; |93| 
	.endfunc	93,000080000h,8



	.sect	".text"
	.global	_input_left_sample
	.sym	_input_left_sample,_input_left_sample, 35, 2, 0
	.func	95
;----------------------------------------------------------------------
;  95 | short input_left_sample()                               //input to left
;     |  channel                                                               
;----------------------------------------------------------------------

;******************************************************************************
;* FUNCTION NAME: _input_left_sample                                          *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,SP                                      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP                                   *
;*   Local Frame Size  : 0 Args + 0 Auto + 4 Save = 4 byte                    *
;******************************************************************************
_input_left_sample:
;** --------------------------------------------------------------------------*
	.line	2
           STW     .D2T2   B3,*SP--(8)       ; |96| 
           NOP             2
	.line	3
;----------------------------------------------------------------------
;  97 | if (poll) while(!MCBSP_rrdy(DSK6713_AIC23_DATAHANDLE));//if ready to re
;     | ceive                                                                  
;----------------------------------------------------------------------
           LDW     .D2T2   *+DP(_poll),B0    ; |97| 
           MVKL    .S2     _MCBSP_rrdy,B4    ; |97| 
           MVKL    .S2     RL27,B3           ; |97| 
           MVKH    .S2     _MCBSP_rrdy,B4    ; |97| 
           MVKH    .S2     RL27,B3           ; |97| 
   [!B0]   B       .S1     L10               ; |97| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |97| 
           NOP             4
           ; BRANCH OCCURS                   ; |97| 
;** --------------------------------------------------------------------------*
           CALL    .S2     B4                ; |97| 
           NOP             5
RL27:      ; CALL OCCURS                     ; |97| 
           MV      .D1     A4,A1             ; |97| 
   [ A1]   B       .S1     L10               ; |97| 
           NOP             5
           ; BRANCH OCCURS                   ; |97| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Software pipelining disabled
;*----------------------------------------------------------------------------*
L9:    
           MVKL    .S2     _MCBSP_rrdy,B4    ; |97| 
           MVKH    .S2     _MCBSP_rrdy,B4    ; |97| 
           CALL    .S2     B4                ; |97| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |97| 
           MVKL    .S2     RL28,B3           ; |97| 
           MVKH    .S2     RL28,B3           ; |97| 
           NOP             2
RL28:      ; CALL OCCURS                     ; |97| 
           MV      .D1     A4,A1             ; |97| 
   [!A1]   B       .S1     L9                ; |97| 
           NOP             5
           ; BRANCH OCCURS                   ; |97| 
;** --------------------------------------------------------------------------*
L10:    
           NOP             2
	.line	4
;----------------------------------------------------------------------
;  98 | AIC_data.uint=MCBSP_read(DSK6713_AIC23_DATAHANDLE);//read into left cha
;     | nnel                                                                   
;----------------------------------------------------------------------
           MVKL    .S1     _MCBSP_read,A0    ; |98| 
           MVKH    .S1     _MCBSP_read,A0    ; |98| 
           CALL    .S2X    A0                ; |98| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |98| 
           MVKL    .S2     RL29,B3           ; |98| 
           MVKH    .S2     RL29,B3           ; |98| 
           NOP             2
RL29:      ; CALL OCCURS                     ; |98| 
           STW     .D2T1   A4,*+DP(_AIC_data) ; |98| 
           NOP             2
	.line	5
;----------------------------------------------------------------------
;  99 | return(AIC_data.channel[LEFT]);                                 //retur
;     | n left channel data                                                    
;----------------------------------------------------------------------
           LDH     .D2T1   *+DP(_AIC_data+2),A4 ; |99| 
           NOP             4
	.line	6
           LDW     .D2T2   *++SP(8),B3       ; |100| 
           NOP             4
           RET     .S2     B3                ; |100| 
           NOP             5
           ; BRANCH OCCURS                   ; |100| 
	.endfunc	100,000080000h,8



	.sect	".text"
	.global	_input_right_sample
	.sym	_input_right_sample,_input_right_sample, 35, 2, 0
	.func	102
;----------------------------------------------------------------------
; 102 | short input_right_sample()                              //input to righ
;     | t channel                                                              
;----------------------------------------------------------------------

;******************************************************************************
;* FUNCTION NAME: _input_right_sample                                         *
;*                                                                            *
;*   Regs Modified     : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,SP                                      *
;*   Regs Used         : A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,B6,  *
;*                           B7,B8,B9,DP,SP                                   *
;*   Local Frame Size  : 0 Args + 0 Auto + 4 Save = 4 byte                    *
;******************************************************************************
_input_right_sample:
;** --------------------------------------------------------------------------*
	.line	2
           STW     .D2T2   B3,*SP--(8)       ; |103| 
           NOP             2
	.line	3
;----------------------------------------------------------------------
; 104 | if (poll) while(!MCBSP_rrdy(DSK6713_AIC23_DATAHANDLE));//if ready to re
;     | ceive                                                                  
;----------------------------------------------------------------------
           LDW     .D2T2   *+DP(_poll),B0    ; |104| 
           MVKL    .S2     _MCBSP_rrdy,B4    ; |104| 
           MVKL    .S2     RL30,B3           ; |104| 
           MVKH    .S2     _MCBSP_rrdy,B4    ; |104| 
           MVKH    .S2     RL30,B3           ; |104| 
   [!B0]   B       .S1     L12               ; |104| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |104| 
           NOP             4
           ; BRANCH OCCURS                   ; |104| 
;** --------------------------------------------------------------------------*
           CALL    .S2     B4                ; |104| 
           NOP             5
RL30:      ; CALL OCCURS                     ; |104| 
           MV      .D1     A4,A1             ; |104| 
   [ A1]   B       .S1     L12               ; |104| 
           NOP             5
           ; BRANCH OCCURS                   ; |104| 
;*----------------------------------------------------------------------------*
;*   SOFTWARE PIPELINE INFORMATION
;*      Disqualified loop: Software pipelining disabled
;*----------------------------------------------------------------------------*
L11:    
           MVKL    .S2     _MCBSP_rrdy,B4    ; |104| 
           MVKH    .S2     _MCBSP_rrdy,B4    ; |104| 
           CALL    .S2     B4                ; |104| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |104| 
           MVKL    .S2     RL31,B3           ; |104| 
           MVKH    .S2     RL31,B3           ; |104| 
           NOP             2
RL31:      ; CALL OCCURS                     ; |104| 
           MV      .D1     A4,A1             ; |104| 
   [!A1]   B       .S1     L11               ; |104| 
           NOP             5
           ; BRANCH OCCURS                   ; |104| 
;** --------------------------------------------------------------------------*
L12:    
           NOP             2
	.line	4
;----------------------------------------------------------------------
; 105 | AIC_data.uint=MCBSP_read(DSK6713_AIC23_DATAHANDLE);//read into right ch
;     | annel                                                                  
;----------------------------------------------------------------------
           MVKL    .S1     _MCBSP_read,A0    ; |105| 
           MVKH    .S1     _MCBSP_read,A0    ; |105| 
           CALL    .S2X    A0                ; |105| 
           LDW     .D2T1   *+DP(_DSK6713_AIC23_codecdatahandle),A4 ; |105| 
           MVKL    .S2     RL32,B3           ; |105| 
           MVKH    .S2     RL32,B3           ; |105| 
           NOP             2
RL32:      ; CALL OCCURS                     ; |105| 
           STW     .D2T1   A4,*+DP(_AIC_data) ; |105| 
           NOP             2
	.line	5
;----------------------------------------------------------------------
; 106 | return(AIC_data.channel[RIGHT]);                                //retur
;     | n right channel data                                                   
;----------------------------------------------------------------------
           LDH     .D2T1   *+DP(_AIC_data),A4 ; |106| 
           NOP             4
	.line	6
           LDW     .D2T2   *++SP(8),B3       ; |107| 
           NOP             4
           RET     .S2     B3                ; |107| 
           NOP             5
           ; BRANCH OCCURS                   ; |107| 
	.endfunc	107,000080000h,8


;******************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                              *
;******************************************************************************
	.global	_IRQ_map
	.global	_IRQ_enable
	.global	_IRQ_reset
	.global	_IRQ_globalEnable
	.global	_IRQ_globalDisable
	.global	_IRQ_nmiEnable
	.global	_DSK6713_init
	.global	_MCBSP_start
	.global	_MCBSP_getXmtEventId
	.global	_MCBSP_read
	.global	_MCBSP_write
	.global	_MCBSP_xrdy
	.global	_MCBSP_rrdy
	.global	_MCBSP_config
	.global	_DSK6713_AIC23_openCodec
	.global	_DSK6713_AIC23_setFreq
	.global	_DSK6713_AIC23_codecdatahandle
	.global	_fs

;******************************************************************************
;* TYPE INFORMATION                                                           *
;******************************************************************************
	.sym	_DSK6713_AIC23_CodecHandle, 0, 4, 13, 32
	.sym	_Uint32, 0, 14, 13, 32
	.sym	_Uint32, 0, 14, 13, 32
	.stag	_DSK6713_AIC23_Config, 320
	.member	_regs, 0, 52, 8, 320, , 10
	.eos
	.sym	_DSK6713_AIC23_Config, 0, 8, 13, 320,_DSK6713_AIC23_Config
	.stag	$$fake0, 192
	.member	_allocated, 0, 14, 8, 32
	.member	_xmtEventId, 32, 14, 8, 32
	.member	_rcvEventId, 64, 14, 8, 32
	.member	_baseAddr, 96, 30, 8, 32
	.member	_drrAddr, 128, 14, 8, 32
	.member	_dxrAddr, 160, 14, 8, 32
	.eos
	.sym	_MCBSP_Handle, 0, 24, 13, 32,$$fake0
	.stag	$$fake1, 256
	.member	_spcr, 0, 14, 8, 32
	.member	_rcr, 32, 14, 8, 32
	.member	_xcr, 64, 14, 8, 32
	.member	_srgr, 96, 14, 8, 32
	.member	_mcr, 128, 14, 8, 32
	.member	_rcer, 160, 14, 8, 32
	.member	_xcer, 192, 14, 8, 32
	.member	_pcr, 224, 14, 8, 32
	.eos
	.sym	_MCBSP_Config, 0, 8, 13, 256,$$fake1
	.utag	$$fake2, 32
	.member	_uint, 0, 14, 11, 32
	.member	_channel, 0, 51, 11, 32, , 2
	.eos
