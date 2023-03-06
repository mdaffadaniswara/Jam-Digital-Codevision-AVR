
;CodeVisionAVR C Compiler V3.50 
;(C) Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPMCSR=0x37
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40
	.EQU __EEPROM_PAGE_SIZE=0x04

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _mode=R3
	.DEF _mode_msb=R4
	.DEF _seconds_jam=R5
	.DEF _seconds_jam_msb=R6
	.DEF _minutes_jam=R7
	.DEF _minutes_jam_msb=R8
	.DEF _seconds_timer=R9
	.DEF _seconds_timer_msb=R10
	.DEF _minutes_timer=R11
	.DEF _minutes_timer_msb=R12
	.DEF _seconds_stopwatch=R13
	.DEF _seconds_stopwatch_msb=R14

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timera_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0xA2:
	.DB  0x1
_0xA3:
	.DB  0x1

__GLOBAL_INI_TBL:
	.DW  0x0C
	.DW  0x03
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _atur
	.DW  _0xA2*2

	.DW  0x01
	.DW  _geser
	.DW  _0xA3*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x300

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;void init_int1(void)
; 0000 0019 {                        // 1s

	.CSEG
_init_int1:
; .FSTART _init_int1
; 0000 001A TCCR1A = (1 << WGM12); // ctc
	LDI  R30,LOW(8)
	STS  128,R30
; 0000 001B TCCR1B = (1 << CS12);  // 256
	LDI  R30,LOW(4)
	STS  129,R30
; 0000 001C TCNT1H = 0;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 001D TCNT1L = 0;
	STS  132,R30
; 0000 001E OCR1AH = 0xF4;
	LDI  R30,LOW(244)
	STS  137,R30
; 0000 001F OCR1AL = 0x24;
	LDI  R30,LOW(36)
	STS  136,R30
; 0000 0020 TIMSK1 = 0b00000010;
	LDI  R30,LOW(2)
	STS  111,R30
; 0000 0021 }
	RET
; .FEND
;void init_int2(void)
; 0000 0024 { // 1ms
_init_int2:
; .FSTART _init_int2
; 0000 0025 TIMSK0 = 0b00000001;
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 0026 TCCR0B = (1 << CS02); // 256
	LDI  R30,LOW(4)
	OUT  0x25,R30
; 0000 0027 TCNT0 = 0x83;
	LDI  R30,LOW(131)
	OUT  0x26,R30
; 0000 0028 }
	RET
; .FEND
;void init_buttonA(void)
; 0000 002B {
_init_buttonA:
; .FSTART _init_buttonA
; 0000 002C // SET FALLING EDGE PADA INT1
; 0000 002D EICRA = (1 << ISC11) | (0 << ISC10) | (0 << ISC01) | (0 << ISC00);
	LDI  R30,LOW(8)
	STS  105,R30
; 0000 002E // ENABLE INT1
; 0000 002F EIMSK = (1 << INT1) | (0 << INT0);
	LDI  R30,LOW(2)
	OUT  0x1D,R30
; 0000 0030 }
	RET
; .FEND
;void SevenSegment(int num)
; 0000 0034 {
_SevenSegment:
; .FSTART _SevenSegment
; 0000 0035 // Elif for number modifier Seven Segments
; 0000 0036 if (num == 0)
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	num -> R16,R17
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x3
; 0000 0037 {
; 0000 0038 SEG_A = 0;
	RCALL SUBOPT_0x0
; 0000 0039 SEG_B = 0;
; 0000 003A SEG_C = 0;
; 0000 003B SEG_D = 0;
; 0000 003C SEG_E = 0;
	CBI  0x8,1
; 0000 003D SEG_F = 0;
	CBI  0xB,4
; 0000 003E SEG_G = 1;
	SBI  0x8,0
; 0000 003F }
; 0000 0040 else if (num == 1)
	RJMP _0x12
_0x3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x13
; 0000 0041 {
; 0000 0042 SEG_A = 1;
	RCALL SUBOPT_0x1
; 0000 0043 SEG_B = 0;
; 0000 0044 SEG_C = 0;
; 0000 0045 SEG_D = 1;
; 0000 0046 SEG_E = 1;
	SBI  0x8,1
; 0000 0047 SEG_F = 1;
	SBI  0xB,4
; 0000 0048 SEG_G = 1;
	SBI  0x8,0
; 0000 0049 }
; 0000 004A else if (num == 2)
	RJMP _0x22
_0x13:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x23
; 0000 004B {
; 0000 004C SEG_A = 0;
	CBI  0x5,0
; 0000 004D SEG_B = 0;
	CBI  0xB,6
; 0000 004E SEG_C = 1;
	SBI  0xB,7
; 0000 004F SEG_D = 0;
	CBI  0x5,1
; 0000 0050 SEG_E = 0;
	CBI  0x8,1
; 0000 0051 SEG_F = 1;
	SBI  0xB,4
; 0000 0052 SEG_G = 0;
	RJMP _0x176
; 0000 0053 }
; 0000 0054 else if (num == 3)
_0x23:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x33
; 0000 0055 {
; 0000 0056 SEG_A = 0;
	RCALL SUBOPT_0x0
; 0000 0057 SEG_B = 0;
; 0000 0058 SEG_C = 0;
; 0000 0059 SEG_D = 0;
; 0000 005A SEG_E = 1;
	SBI  0x8,1
; 0000 005B SEG_F = 1;
	SBI  0xB,4
; 0000 005C SEG_G = 0;
	RJMP _0x176
; 0000 005D }
; 0000 005E else if (num == 4)
_0x33:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x43
; 0000 005F {
; 0000 0060 SEG_A = 1;
	RCALL SUBOPT_0x1
; 0000 0061 SEG_B = 0;
; 0000 0062 SEG_C = 0;
; 0000 0063 SEG_D = 1;
; 0000 0064 SEG_E = 1;
	RJMP _0x177
; 0000 0065 SEG_F = 0;
; 0000 0066 SEG_G = 0;
; 0000 0067 }
; 0000 0068 else if (num == 5)
_0x43:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x53
; 0000 0069 {
; 0000 006A SEG_A = 0;
	CBI  0x5,0
; 0000 006B SEG_B = 1;
	SBI  0xB,6
; 0000 006C SEG_C = 0;
	RJMP _0x178
; 0000 006D SEG_D = 0;
; 0000 006E SEG_E = 1;
; 0000 006F SEG_F = 0;
; 0000 0070 SEG_G = 0;
; 0000 0071 }
; 0000 0072 else if (num == 6)
_0x53:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x63
; 0000 0073 {
; 0000 0074 SEG_A = 0;
	CBI  0x5,0
; 0000 0075 SEG_B = 1;
	SBI  0xB,6
; 0000 0076 SEG_C = 0;
	CBI  0xB,7
; 0000 0077 SEG_D = 0;
	CBI  0x5,1
; 0000 0078 SEG_E = 0;
	CBI  0x8,1
; 0000 0079 SEG_F = 0;
	RJMP _0x179
; 0000 007A SEG_G = 0;
; 0000 007B }
; 0000 007C else if (num == 7)
_0x63:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x73
; 0000 007D {
; 0000 007E SEG_A = 0;
	CBI  0x5,0
; 0000 007F SEG_B = 0;
	CBI  0xB,6
; 0000 0080 SEG_C = 0;
	CBI  0xB,7
; 0000 0081 SEG_D = 1;
	SBI  0x5,1
; 0000 0082 SEG_E = 1;
	SBI  0x8,1
; 0000 0083 SEG_F = 1;
	SBI  0xB,4
; 0000 0084 SEG_G = 1;
	SBI  0x8,0
; 0000 0085 }
; 0000 0086 else if (num == 8)
	RJMP _0x82
_0x73:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x83
; 0000 0087 {
; 0000 0088 SEG_A = 0;
	RCALL SUBOPT_0x0
; 0000 0089 SEG_B = 0;
; 0000 008A SEG_C = 0;
; 0000 008B SEG_D = 0;
; 0000 008C SEG_E = 0;
	CBI  0x8,1
; 0000 008D SEG_F = 0;
	RJMP _0x179
; 0000 008E SEG_G = 0;
; 0000 008F }
; 0000 0090 else if (num == 9)
_0x83:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x93
; 0000 0091 {
; 0000 0092 SEG_A = 0;
	CBI  0x5,0
; 0000 0093 SEG_B = 0;
	CBI  0xB,6
; 0000 0094 SEG_C = 0;
_0x178:
	CBI  0xB,7
; 0000 0095 SEG_D = 0;
	CBI  0x5,1
; 0000 0096 SEG_E = 1;
_0x177:
	SBI  0x8,1
; 0000 0097 SEG_F = 0;
_0x179:
	CBI  0xB,4
; 0000 0098 SEG_G = 0;
_0x176:
	CBI  0x8,0
; 0000 0099 }
; 0000 009A }
_0x93:
_0x82:
_0x22:
_0x12:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND

	.DSEG
;void aturJam(void)
; 0000 00AD {

	.CSEG
_aturJam:
; .FSTART _aturJam
; 0000 00AE #asm("sei")
	SEI
; 0000 00AF atur = 0;
	LDI  R30,LOW(0)
	STS  _atur,R30
	STS  _atur+1,R30
; 0000 00B0 TIMSK1 &= ~(1 << OCIE1A);
	RCALL SUBOPT_0x2
; 0000 00B1 while (!(EIFR & (1 << INTF1)))
_0xA4:
	SBIC 0x1C,1
	RJMP _0xA6
; 0000 00B2 { // menunggu sampai interrupt ditekan
; 0000 00B3 if (BUTTON_D == 1)
	SBIS 0x6,3
	RJMP _0xA7
; 0000 00B4 {
; 0000 00B5 delay_ms(300);
	RCALL SUBOPT_0x3
; 0000 00B6 if (geser == 0)
	BRNE _0xA8
; 0000 00B7 {
; 0000 00B8 seconds_jam++;
	__GETW1R 5,6
	ADIW R30,1
	__PUTW1R 5,6
	SBIW R30,1
; 0000 00B9 if (seconds_jam >= 60)
	RCALL SUBOPT_0x4
	BRLT _0xA9
; 0000 00BA {
; 0000 00BB seconds_jam = 0;
	CLR  R5
	CLR  R6
; 0000 00BC }
; 0000 00BD }
_0xA9:
; 0000 00BE else
	RJMP _0xAA
_0xA8:
; 0000 00BF {
; 0000 00C0 minutes_jam++;
	RCALL SUBOPT_0x5
; 0000 00C1 if (minutes_jam >= 60)
	RCALL SUBOPT_0x6
	BRLT _0xAB
; 0000 00C2 {
; 0000 00C3 minutes_jam = 0;
	CLR  R7
	CLR  R8
; 0000 00C4 }
; 0000 00C5 }
_0xAB:
_0xAA:
; 0000 00C6 }
; 0000 00C7 else if (BUTTON_C == 1)
	RJMP _0xAC
_0xA7:
	SBIS 0x6,4
	RJMP _0xAD
; 0000 00C8 {
; 0000 00C9 delay_ms(300);
	RCALL SUBOPT_0x3
; 0000 00CA if (geser == 0)
	BRNE _0xAE
; 0000 00CB {
; 0000 00CC seconds_jam--;
	__GETW1R 5,6
	SBIW R30,1
	__PUTW1R 5,6
	ADIW R30,1
; 0000 00CD if (seconds_jam <= -1)
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R5
	CPC  R31,R6
	BRLT _0xAF
; 0000 00CE {
; 0000 00CF seconds_jam = 59;
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	__PUTW1R 5,6
; 0000 00D0 }
; 0000 00D1 }
_0xAF:
; 0000 00D2 else
	RJMP _0xB0
_0xAE:
; 0000 00D3 {
; 0000 00D4 minutes_jam--;
	__GETW1R 7,8
	SBIW R30,1
	__PUTW1R 7,8
; 0000 00D5 if (minutes_jam <= -1)
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R7
	CPC  R31,R8
	BRLT _0xB1
; 0000 00D6 {
; 0000 00D7 minutes_jam = 59;
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	__PUTW1R 7,8
; 0000 00D8 }
; 0000 00D9 }
_0xB1:
_0xB0:
; 0000 00DA }
; 0000 00DB else if (BUTTON_B == 1)
	RJMP _0xB2
_0xAD:
	SBIS 0x6,5
	RJMP _0xB3
; 0000 00DC {
; 0000 00DD delay_ms(300);
	RCALL SUBOPT_0x3
; 0000 00DE if (geser == 0)
	BRNE _0xB4
; 0000 00DF {
; 0000 00E0 geser = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _geser,R30
	STS  _geser+1,R31
; 0000 00E1 }
; 0000 00E2 else
	RJMP _0xB5
_0xB4:
; 0000 00E3 {
; 0000 00E4 geser = 0;
	LDI  R30,LOW(0)
	STS  _geser,R30
	STS  _geser+1,R30
; 0000 00E5 }
_0xB5:
; 0000 00E6 }
; 0000 00E7 // Update Digit Values
; 0000 00E8 digits[0] = minutes_jam / 10;
_0xB3:
_0xB2:
_0xAC:
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 00E9 digits[1] = minutes_jam % 10;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x9
; 0000 00EA digits[2] = seconds_jam / 10;
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
; 0000 00EB digits[3] = seconds_jam % 10;
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xC
; 0000 00EC }
	RJMP _0xA4
_0xA6:
; 0000 00ED atur = 1;
	RCALL SUBOPT_0xD
; 0000 00EE // Clear the external interrupt flag
; 0000 00EF EIFR &= (0 << INTF1);
	RJMP _0x2000001
; 0000 00F0 
; 0000 00F1 // Return from function
; 0000 00F2 return;
; 0000 00F3 }
; .FEND
;void stopWatch(void)
; 0000 00F6 {
_stopWatch:
; .FSTART _stopWatch
; 0000 00F7 #asm("sei")
	SEI
; 0000 00F8 seconds_stopwatch = 0;
	RCALL SUBOPT_0xE
; 0000 00F9 minutes_stopwatch = 0;
; 0000 00FA TIMSK1 &= ~(1 << OCIE1A);
	RCALL SUBOPT_0x2
; 0000 00FB 
; 0000 00FC while (!(EIFR & (1 << INTF1)))
_0xB6:
	SBIC 0x1C,1
	RJMP _0xB8
; 0000 00FD {                    // menunggu sampai interrupt ditekan
; 0000 00FE if (BUTTON_D == 1) // start
	SBIS 0x6,3
	RJMP _0xB9
; 0000 00FF {
; 0000 0100 delay_ms(300);
	RCALL SUBOPT_0xF
; 0000 0101 TIMSK1 |= (1 << OCIE1A);
; 0000 0102 }
; 0000 0103 else if (BUTTON_C == 1) // pause
	RJMP _0xBA
_0xB9:
	SBIS 0x6,4
	RJMP _0xBB
; 0000 0104 {
; 0000 0105 delay_ms(300);
	RCALL SUBOPT_0x10
; 0000 0106 TIMSK1 &= ~(1 << OCIE1A);
; 0000 0107 }
; 0000 0108 else if (BUTTON_B == 1)
	RJMP _0xBC
_0xBB:
	SBIS 0x6,5
	RJMP _0xBD
; 0000 0109 { // pause and reset
; 0000 010A delay_ms(300);
	RCALL SUBOPT_0x10
; 0000 010B TIMSK1 &= ~(1 << OCIE1A);
; 0000 010C seconds_stopwatch = 0;
	RCALL SUBOPT_0xE
; 0000 010D minutes_stopwatch = 0;
; 0000 010E }
; 0000 010F // Update Digit Values
; 0000 0110 digits[0] = minutes_stopwatch / 10;
_0xBD:
_0xBC:
_0xBA:
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x8
; 0000 0111 digits[1] = minutes_stopwatch % 10;
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x9
; 0000 0112 digits[2] = seconds_stopwatch / 10;
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xB
; 0000 0113 digits[3] = seconds_stopwatch % 10;
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xC
; 0000 0114 }
	RJMP _0xB6
_0xB8:
; 0000 0115 
; 0000 0116 // Clear the external interrupt flag
; 0000 0117 EIFR &= (0 << INTF1);
	RJMP _0x2000001
; 0000 0118 
; 0000 0119 // Return from function
; 0000 011A return;
; 0000 011B }
; .FEND
;void alarmTimer(void)
; 0000 011F {
_alarmTimer:
; .FSTART _alarmTimer
; 0000 0120 #asm("sei")
	SEI
; 0000 0121 start = 0;
	LDI  R30,LOW(0)
	STS  _start,R30
	STS  _start+1,R30
; 0000 0122 TIMSK1 &= ~(1 << OCIE1A);
	RCALL SUBOPT_0x2
; 0000 0123 seconds_timer = 0;
	CLR  R9
	CLR  R10
; 0000 0124 minutes_timer = 0;
	CLR  R11
	CLR  R12
; 0000 0125 while (!(EIFR & (1 << INTF1)))
_0xBE:
	SBIC 0x1C,1
	RJMP _0xC0
; 0000 0126 { // menunggu sampai interrupt ditekan
; 0000 0127 if (BUTTON_D == 1)
	SBIS 0x6,3
	RJMP _0xC1
; 0000 0128 {
; 0000 0129 delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
; 0000 012A seconds_timer++;
	__GETW1R 9,10
	ADIW R30,1
	__PUTW1R 9,10
	SBIW R30,1
; 0000 012B if (seconds_timer >= 60)
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R9,R30
	CPC  R10,R31
	BRLT _0xC2
; 0000 012C {
; 0000 012D seconds_timer = 0;
	CLR  R9
	CLR  R10
; 0000 012E }
; 0000 012F }
_0xC2:
; 0000 0130 else if (BUTTON_C == 1)
	RJMP _0xC3
_0xC1:
	SBIS 0x6,4
	RJMP _0xC4
; 0000 0131 {
; 0000 0132 delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
; 0000 0133 minutes_timer++;
	__GETW1R 11,12
	ADIW R30,1
	__PUTW1R 11,12
	SBIW R30,1
; 0000 0134 if (minutes_timer >= 60)
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R11,R30
	CPC  R12,R31
	BRLT _0xC5
; 0000 0135 {
; 0000 0136 minutes_timer = 0;
	CLR  R11
	CLR  R12
; 0000 0137 }
; 0000 0138 }
_0xC5:
; 0000 0139 else if (BUTTON_B == 1)
	RJMP _0xC6
_0xC4:
	SBIS 0x6,5
	RJMP _0xC7
; 0000 013A {
; 0000 013B delay_ms(300);
	RCALL SUBOPT_0xF
; 0000 013C TIMSK1 |= (1 << OCIE1A);
; 0000 013D start = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _start,R30
	STS  _start+1,R31
; 0000 013E }
; 0000 013F // Update Digit Values
; 0000 0140 digits[0] = minutes_timer / 10;
_0xC7:
_0xC6:
_0xC3:
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x8
; 0000 0141 digits[1] = minutes_timer % 10;
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x9
; 0000 0142 digits[2] = seconds_timer / 10;
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xB
; 0000 0143 digits[3] = seconds_timer % 10;
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xC
; 0000 0144 if (minutes_timer == 0 && seconds_timer == 0 && start == 1)
	CLR  R0
	CP   R0,R11
	CPC  R0,R12
	BRNE _0xC9
	CLR  R0
	CP   R0,R9
	CPC  R0,R10
	BRNE _0xC9
	LDS  R26,_start
	LDS  R27,_start+1
	SBIW R26,1
	BREQ _0xCA
_0xC9:
	RJMP _0xC8
_0xCA:
; 0000 0145 {
; 0000 0146 PIN_BUZZ = 1;
	SBI  0xB,2
; 0000 0147 }
; 0000 0148 }
_0xC8:
	RJMP _0xBE
_0xC0:
; 0000 0149 // Clear the external interrupt flag
; 0000 014A EIFR &= (0 << INTF1);
	RJMP _0x2000001
; 0000 014B 
; 0000 014C // Return from function
; 0000 014D return;
; 0000 014E }
; .FEND
;void tampilanJam(void)
; 0000 0151 {
_tampilanJam:
; .FSTART _tampilanJam
; 0000 0152 #asm("sei")
	SEI
; 0000 0153 
; 0000 0154 while (!(EIFR & (1 << INTF1)))
_0xCD:
	SBIS 0x1C,1
; 0000 0155 { // menunggu sampai interrupt ditekan
; 0000 0156 }
	RJMP _0xCD
; 0000 0157 
; 0000 0158 // Clear the external interrupt flag
; 0000 0159 EIFR &= (0 << INTF1);
_0x2000001:
	IN   R30,0x1C
	ANDI R30,LOW(0x0)
	OUT  0x1C,R30
; 0000 015A 
; 0000 015B // Return from function
; 0000 015C return;
	RET
; 0000 015D }
; .FEND
;interrupt[3] void ext_int1_isr(void)
; 0000 0161 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	RCALL SUBOPT_0x15
; 0000 0162 PIN_BUZZ = 0;
	CBI  0xB,2
; 0000 0163 delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
; 0000 0164 if (mode == 1)
	RCALL SUBOPT_0x16
	BRNE _0xD2
; 0000 0165 { // mode stopwatch
; 0000 0166 atur = 1;
	RCALL SUBOPT_0xD
; 0000 0167 mode = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	__PUTW1R 3,4
; 0000 0168 TIMSK1 &= ~(1 << OCIE1A);
	RCALL SUBOPT_0x2
; 0000 0169 stopWatch();
	RCALL _stopWatch
; 0000 016A }
; 0000 016B else if (mode == 0)
	RJMP _0xD3
_0xD2:
	MOV  R0,R3
	OR   R0,R4
	BRNE _0xD4
; 0000 016C { // mode tampilan
; 0000 016D atur = 1;
	RCALL SUBOPT_0xD
; 0000 016E mode = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 3,4
; 0000 016F TIMSK1 |= (1 << OCIE1A); // 256
	LDS  R30,111
	ORI  R30,2
	STS  111,R30
; 0000 0170 tampilanJam();
	RCALL _tampilanJam
; 0000 0171 }
; 0000 0172 else if (mode == 2)
	RJMP _0xD5
_0xD4:
	RCALL SUBOPT_0x17
	BRNE _0xD6
; 0000 0173 { // mode timer
; 0000 0174 atur = 1;
	RCALL SUBOPT_0xD
; 0000 0175 mode = 0;
	CLR  R3
	CLR  R4
; 0000 0176 TIMSK1 &= ~(1 << OCIE1A);
	RCALL SUBOPT_0x2
; 0000 0177 alarmTimer();
	RCALL _alarmTimer
; 0000 0178 }
; 0000 0179 /*else if (mode == 0)
; 0000 017A {           //mode mengatur
; 0000 017B mode = 1;
; 0000 017C TIMSK1 &= ~(1 << OCIE1A);
; 0000 017D aturJam();
; 0000 017E }  */
; 0000 017F }
_0xD6:
_0xD5:
_0xD3:
	RJMP _0x17B
; .FEND
;interrupt[12] void timera_compa_isr(void)
; 0000 0183 {
_timera_compa_isr:
; .FSTART _timera_compa_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0184 if (mode == 1)
	RCALL SUBOPT_0x16
	BRNE _0xD7
; 0000 0185 {
; 0000 0186 // Check if 1 Second has Passed
; 0000 0187 seconds_jam++;
	RCALL SUBOPT_0x18
; 0000 0188 
; 0000 0189 // Check if 1 Minute has Passed
; 0000 018A if (seconds_jam >= 60)
	BRLT _0xD8
; 0000 018B {
; 0000 018C seconds_jam = 0;
	CLR  R5
	CLR  R6
; 0000 018D minutes_jam++;
	RCALL SUBOPT_0x5
; 0000 018E }
; 0000 018F if (minutes_jam >= 60)
_0xD8:
	RCALL SUBOPT_0x6
	BRLT _0xD9
; 0000 0190 {
; 0000 0191 minutes_jam = 0;
	CLR  R7
	CLR  R8
; 0000 0192 }
; 0000 0193 // Update Digit Values
; 0000 0194 digits[0] = minutes_jam / 10;
_0xD9:
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 0195 digits[1] = minutes_jam % 10;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x9
; 0000 0196 digits[2] = seconds_jam / 10;
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
; 0000 0197 digits[3] = seconds_jam % 10;
	__GETW2R 5,6
	RJMP _0x17A
; 0000 0198 }
; 0000 0199 else if(mode == 0)
_0xD7:
	MOV  R0,R3
	OR   R0,R4
	BRNE _0xDB
; 0000 019A {
; 0000 019B // Check if 1 Second has Passed
; 0000 019C seconds_timer--;
	__GETW1R 9,10
	SBIW R30,1
	__PUTW1R 9,10
; 0000 019D seconds_jam++;
	RCALL SUBOPT_0x18
; 0000 019E 
; 0000 019F // Check if 1 Minute has Passed
; 0000 01A0 if (seconds_jam >= 60)
	BRLT _0xDC
; 0000 01A1 {
; 0000 01A2 seconds_jam = 0;
	CLR  R5
	CLR  R6
; 0000 01A3 minutes_jam++;
	RCALL SUBOPT_0x5
; 0000 01A4 }
; 0000 01A5 if (minutes_jam >= 60)
_0xDC:
	RCALL SUBOPT_0x6
	BRLT _0xDD
; 0000 01A6 {
; 0000 01A7 minutes_jam = 0;
	CLR  R7
	CLR  R8
; 0000 01A8 }
; 0000 01A9 
; 0000 01AA // Check if 1 Minute has Passed
; 0000 01AB if (seconds_timer == 0 && minutes_timer == 0)
_0xDD:
	CLR  R0
	CP   R0,R9
	CPC  R0,R10
	BRNE _0xDF
	CLR  R0
	CP   R0,R11
	CPC  R0,R12
	BREQ _0xE0
_0xDF:
	RJMP _0xDE
_0xE0:
; 0000 01AC { // timer sudah mencapai 0
; 0000 01AD TIMSK1 &= ~(1 << OCIE1A);
	RCALL SUBOPT_0x2
; 0000 01AE }
; 0000 01AF if (seconds_timer <= -1)
_0xDE:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R9
	CPC  R31,R10
	BRLT _0xE1
; 0000 01B0 {
; 0000 01B1 seconds_timer = 59;
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	__PUTW1R 9,10
; 0000 01B2 minutes_timer--;
	__GETW1R 11,12
	SBIW R30,1
	__PUTW1R 11,12
; 0000 01B3 }
; 0000 01B4 if (minutes_timer <= -1)
_0xE1:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R11
	CPC  R31,R12
	BRLT _0xE2
; 0000 01B5 {
; 0000 01B6 minutes_timer = 0;
	CLR  R11
	CLR  R12
; 0000 01B7 }
; 0000 01B8 // Update Digit Values
; 0000 01B9 digits[0] = minutes_timer / 10;
_0xE2:
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x8
; 0000 01BA digits[1] = minutes_timer % 10;
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x9
; 0000 01BB digits[2] = seconds_timer / 10;
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xB
; 0000 01BC digits[3] = seconds_timer % 10;
	__GETW2R 9,10
	RJMP _0x17A
; 0000 01BD }
; 0000 01BE else if (mode == 2)
_0xDB:
	RCALL SUBOPT_0x17
	BRNE _0xE4
; 0000 01BF {
; 0000 01C0 // Check if 1 Second has Passed
; 0000 01C1 seconds_stopwatch++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 13,14,30,31
; 0000 01C2 seconds_jam++;
	RCALL SUBOPT_0x18
; 0000 01C3 
; 0000 01C4 // Check if 1 Minute has Passed
; 0000 01C5 if (seconds_jam >= 60)
	BRLT _0xE5
; 0000 01C6 {
; 0000 01C7 seconds_jam = 0;
	CLR  R5
	CLR  R6
; 0000 01C8 minutes_jam++;
	RCALL SUBOPT_0x5
; 0000 01C9 }
; 0000 01CA if (minutes_jam >= 60)
_0xE5:
	RCALL SUBOPT_0x6
	BRLT _0xE6
; 0000 01CB {
; 0000 01CC minutes_jam = 0;
	CLR  R7
	CLR  R8
; 0000 01CD }
; 0000 01CE // Check if 1 Minute has Passed
; 0000 01CF if (seconds_stopwatch >= 60)
_0xE6:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R13,R30
	CPC  R14,R31
	BRLT _0xE7
; 0000 01D0 {
; 0000 01D1 seconds_stopwatch = 0;
	CLR  R13
	CLR  R14
; 0000 01D2 minutes_stopwatch++;
	LDI  R26,LOW(_minutes_stopwatch)
	LDI  R27,HIGH(_minutes_stopwatch)
	RCALL SUBOPT_0x19
; 0000 01D3 }
; 0000 01D4 if (minutes_stopwatch >= 60)
_0xE7:
	LDS  R26,_minutes_stopwatch
	LDS  R27,_minutes_stopwatch+1
	SBIW R26,60
	BRLT _0xE8
; 0000 01D5 {
; 0000 01D6 minutes_stopwatch = 00;
	LDI  R30,LOW(0)
	STS  _minutes_stopwatch,R30
	STS  _minutes_stopwatch+1,R30
; 0000 01D7 }
; 0000 01D8 // Update Digit Values
; 0000 01D9 digits[0] = minutes_stopwatch / 10;
_0xE8:
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x8
; 0000 01DA digits[1] = minutes_stopwatch % 10;
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x9
; 0000 01DB digits[2] = seconds_stopwatch / 10;
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xB
; 0000 01DC digits[3] = seconds_stopwatch % 10;
	__GETW2R 13,14
_0x17A:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0xC
; 0000 01DD }
; 0000 01DE }
_0xE4:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;interrupt[17] void timer0_ovf_isr(void)
; 0000 01E2 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	RCALL SUBOPT_0x15
; 0000 01E3 // Update Segment Values for Current Digit
; 0000 01E4 SevenSegment(digits[digit_index]);
	RCALL SUBOPT_0x1A
	LDI  R26,LOW(_digits)
	LDI  R27,HIGH(_digits)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	MOVW R26,R30
	RCALL _SevenSegment
; 0000 01E5 
; 0000 01E6 // Enable Multiplexing for Current Digit
; 0000 01E7 // Elif for choose seven SevenSegmen
; 0000 01E8 if (atur == 1)
	LDS  R26,_atur
	LDS  R27,_atur+1
	SBIW R26,1
	BRNE _0xE9
; 0000 01E9 {
; 0000 01EA if (digit_index == 0)
	RCALL SUBOPT_0x1A
	SBIW R30,0
	BRNE _0xEA
; 0000 01EB {
; 0000 01EC DIGIT_1 = 1;
	RCALL SUBOPT_0x1B
; 0000 01ED DIGIT_2 = 0;
; 0000 01EE DIGIT_3 = 0;
; 0000 01EF DIGIT_4 = 0;
; 0000 01F0 }
; 0000 01F1 else if (digit_index == 1)
	RJMP _0xF3
_0xEA:
	RCALL SUBOPT_0x1C
	SBIW R26,1
	BRNE _0xF4
; 0000 01F2 {
; 0000 01F3 DIGIT_1 = 0;
	RCALL SUBOPT_0x1D
; 0000 01F4 DIGIT_2 = 1;
; 0000 01F5 DIGIT_3 = 0;
; 0000 01F6 DIGIT_4 = 0;
; 0000 01F7 }
; 0000 01F8 else if (digit_index == 2)
	RJMP _0xFD
_0xF4:
	RCALL SUBOPT_0x1C
	SBIW R26,2
	BRNE _0xFE
; 0000 01F9 {
; 0000 01FA DIGIT_1 = 0;
	RCALL SUBOPT_0x1E
; 0000 01FB DIGIT_2 = 0;
; 0000 01FC DIGIT_3 = 1;
; 0000 01FD DIGIT_4 = 0;
; 0000 01FE }
; 0000 01FF else if (digit_index == 3)
	RJMP _0x107
_0xFE:
	RCALL SUBOPT_0x1C
	SBIW R26,3
	BRNE _0x108
; 0000 0200 {
; 0000 0201 DIGIT_1 = 0;
	RCALL SUBOPT_0x1F
; 0000 0202 DIGIT_2 = 0;
; 0000 0203 DIGIT_3 = 0;
; 0000 0204 DIGIT_4 = 1;
; 0000 0205 }
; 0000 0206 }
_0x108:
_0x107:
_0xFD:
_0xF3:
; 0000 0207 else
	RJMP _0x111
_0xE9:
; 0000 0208 {
; 0000 0209 if (digit_index == 0 && geser == 1)
	RCALL SUBOPT_0x1C
	SBIW R26,0
	BRNE _0x113
	RCALL SUBOPT_0x20
	BREQ _0x114
_0x113:
	RJMP _0x112
_0x114:
; 0000 020A {
; 0000 020B DIGIT_1 = 1;
	RCALL SUBOPT_0x1B
; 0000 020C DIGIT_2 = 0;
; 0000 020D DIGIT_3 = 0;
; 0000 020E DIGIT_4 = 0;
; 0000 020F }
; 0000 0210 else if (digit_index == 1 && geser == 1)
	RJMP _0x11D
_0x112:
	RCALL SUBOPT_0x1C
	SBIW R26,1
	BRNE _0x11F
	RCALL SUBOPT_0x20
	BREQ _0x120
_0x11F:
	RJMP _0x11E
_0x120:
; 0000 0211 {
; 0000 0212 DIGIT_1 = 0;
	RCALL SUBOPT_0x1D
; 0000 0213 DIGIT_2 = 1;
; 0000 0214 DIGIT_3 = 0;
; 0000 0215 DIGIT_4 = 0;
; 0000 0216 }
; 0000 0217 else if (digit_index == 2 && geser == 1)
	RJMP _0x129
_0x11E:
	RCALL SUBOPT_0x1C
	SBIW R26,2
	BRNE _0x12B
	RCALL SUBOPT_0x20
	BREQ _0x12C
_0x12B:
	RJMP _0x12A
_0x12C:
; 0000 0218 {
; 0000 0219 DIGIT_1 = 0;
	RCALL SUBOPT_0x21
; 0000 021A DIGIT_2 = 0;
; 0000 021B DIGIT_3 = 0;
; 0000 021C DIGIT_4 = 0;
; 0000 021D }
; 0000 021E else if (digit_index == 3 && geser == 1)
	RJMP _0x135
_0x12A:
	RCALL SUBOPT_0x1C
	SBIW R26,3
	BRNE _0x137
	RCALL SUBOPT_0x20
	BREQ _0x138
_0x137:
	RJMP _0x136
_0x138:
; 0000 021F {
; 0000 0220 DIGIT_1 = 0;
	RCALL SUBOPT_0x21
; 0000 0221 DIGIT_2 = 0;
; 0000 0222 DIGIT_3 = 0;
; 0000 0223 DIGIT_4 = 0;
; 0000 0224 }
; 0000 0225 else if (digit_index == 0 && geser == 0)
	RJMP _0x141
_0x136:
	RCALL SUBOPT_0x1C
	SBIW R26,0
	BRNE _0x143
	RCALL SUBOPT_0x22
	BREQ _0x144
_0x143:
	RJMP _0x142
_0x144:
; 0000 0226 {
; 0000 0227 DIGIT_1 = 0;
	RCALL SUBOPT_0x21
; 0000 0228 DIGIT_2 = 0;
; 0000 0229 DIGIT_3 = 0;
; 0000 022A DIGIT_4 = 0;
; 0000 022B }
; 0000 022C else if (digit_index == 1 && geser == 0)
	RJMP _0x14D
_0x142:
	RCALL SUBOPT_0x1C
	SBIW R26,1
	BRNE _0x14F
	RCALL SUBOPT_0x22
	BREQ _0x150
_0x14F:
	RJMP _0x14E
_0x150:
; 0000 022D {
; 0000 022E DIGIT_1 = 0;
	RCALL SUBOPT_0x21
; 0000 022F DIGIT_2 = 0;
; 0000 0230 DIGIT_3 = 0;
; 0000 0231 DIGIT_4 = 0;
; 0000 0232 }
; 0000 0233 else if (digit_index == 2 && geser == 0)
	RJMP _0x159
_0x14E:
	RCALL SUBOPT_0x1C
	SBIW R26,2
	BRNE _0x15B
	RCALL SUBOPT_0x22
	BREQ _0x15C
_0x15B:
	RJMP _0x15A
_0x15C:
; 0000 0234 {
; 0000 0235 DIGIT_1 = 0;
	RCALL SUBOPT_0x1E
; 0000 0236 DIGIT_2 = 0;
; 0000 0237 DIGIT_3 = 1;
; 0000 0238 DIGIT_4 = 0;
; 0000 0239 }
; 0000 023A else if (digit_index == 3 && geser == 0)
	RJMP _0x165
_0x15A:
	RCALL SUBOPT_0x1C
	SBIW R26,3
	BRNE _0x167
	RCALL SUBOPT_0x22
	BREQ _0x168
_0x167:
	RJMP _0x166
_0x168:
; 0000 023B {
; 0000 023C DIGIT_1 = 0;
	RCALL SUBOPT_0x1F
; 0000 023D DIGIT_2 = 0;
; 0000 023E DIGIT_3 = 0;
; 0000 023F DIGIT_4 = 1;
; 0000 0240 }
; 0000 0241 }
_0x166:
_0x165:
_0x159:
_0x14D:
_0x141:
_0x135:
_0x129:
_0x11D:
_0x111:
; 0000 0242 
; 0000 0243 // Increment Digit Index
; 0000 0244 digit_index++;
	LDI  R26,LOW(_digit_index)
	LDI  R27,HIGH(_digit_index)
	RCALL SUBOPT_0x19
; 0000 0245 
; 0000 0246 // Wrap Around Digit Index
; 0000 0247 if (digit_index >= 4)
	RCALL SUBOPT_0x1C
	SBIW R26,4
	BRLT _0x171
; 0000 0248 {
; 0000 0249 digit_index = 0;
	LDI  R30,LOW(0)
	STS  _digit_index,R30
	STS  _digit_index+1,R30
; 0000 024A }
; 0000 024B }
_0x171:
_0x17B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;void main(void)
; 0000 024E {
_main:
; .FSTART _main
; 0000 024F // Initialize Timer1
; 0000 0250 // set prescaler 1024
; 0000 0251 init_int1();
	RCALL _init_int1
; 0000 0252 init_int2();
	RCALL _init_int2
; 0000 0253 init_buttonA();
	RCALL _init_buttonA
; 0000 0254 
; 0000 0255 // Enable Interrupts
; 0000 0256 #asm("sei")
	SEI
; 0000 0257 
; 0000 0258 // Set Seven Segment Pins as Output
; 0000 0259 DDRB = 0b111111;
	LDI  R30,LOW(63)
	OUT  0x4,R30
; 0000 025A DDRD &= ~(1 << DDD3);
	CBI  0xA,3
; 0000 025B DDRD |= (1 << DDD2) | (1 << DDD4) | (1 << DDD5) | (1 << DDD6) | (1 << DDD7);
	IN   R30,0xA
	ORI  R30,LOW(0xF4)
	OUT  0xA,R30
; 0000 025C DDRC |= (1 << DDC0) | (1 << DDC1);
	IN   R30,0x7
	ORI  R30,LOW(0x3)
	OUT  0x7,R30
; 0000 025D DDRC &= ~(1 << DDD5) & ~(1 << DDD4) & ~(1 << DDD3);
	IN   R30,0x7
	ANDI R30,LOW(0xC7)
	OUT  0x7,R30
; 0000 025E PORTD |= (1 << BUTTON_A) | (1 << BUTTON_B) | (1 << BUTTON_C) | (1 << BUTTON_D);
	IN   R22,11
	LDI  R30,0
	SBIC 0x9,3
	LDI  R30,1
	LDI  R26,LOW(1)
	RCALL __LSLB12
	MOV  R1,R30
	LDI  R30,0
	SBIC 0x6,5
	LDI  R30,1
	RCALL __LSLB12
	OR   R1,R30
	LDI  R30,0
	SBIC 0x6,4
	LDI  R30,1
	RCALL __LSLB12
	OR   R1,R30
	LDI  R30,0
	SBIC 0x6,3
	LDI  R30,1
	RCALL __LSLB12
	OR   R30,R1
	OR   R30,R22
	OUT  0xB,R30
; 0000 025F 
; 0000 0260 TIMSK1 &= ~(1 << OCIE1A);
	RCALL SUBOPT_0x2
; 0000 0261 mode = 0;
	CLR  R3
	CLR  R4
; 0000 0262 aturJam();
	RCALL _aturJam
; 0000 0263 while (1)
_0x172:
; 0000 0264 {
; 0000 0265 }
	RJMP _0x172
; 0000 0266 }
_0x175:
	RJMP _0x175
; .FEND

	.DSEG
_minutes_stopwatch:
	.BYTE 0x2
_digits:
	.BYTE 0x8
_digit_index:
	.BYTE 0x2
_atur:
	.BYTE 0x2
_geser:
	.BYTE 0x2
_start:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	CBI  0x5,0
	CBI  0xB,6
	CBI  0xB,7
	CBI  0x5,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	SBI  0x5,0
	CBI  0xB,6
	CBI  0xB,7
	SBI  0x5,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x2:
	LDS  R30,111
	ANDI R30,0xFD
	STS  111,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
	LDS  R30,_geser
	LDS  R31,_geser+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R5,R30
	CPC  R6,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 7,8,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R7,R30
	CPC  R8,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	__GETW2R 7,8
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x8:
	RCALL __DIVW21
	STS  _digits,R30
	STS  _digits+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x9:
	RCALL __MODW21
	__PUTW1MN _digits,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	__GETW2R 5,6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xB:
	RCALL __DIVW21
	__PUTW1MN _digits,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xC:
	RCALL __MODW21
	__PUTW1MN _digits,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _atur,R30
	STS  _atur+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	CLR  R13
	CLR  R14
	LDI  R30,LOW(0)
	STS  _minutes_stopwatch,R30
	STS  _minutes_stopwatch+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
	LDS  R30,111
	ORI  R30,2
	STS  111,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	LDS  R26,_minutes_stopwatch
	LDS  R27,_minutes_stopwatch+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	__GETW2R 13,14
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	__GETW2R 11,12
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	__GETW2R 9,10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x15:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R3
	CPC  R31,R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 5,6,30,31
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDS  R30,_digit_index
	LDS  R31,_digit_index+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	SBI  0x5,5
	CBI  0x5,3
	CBI  0x5,4
	CBI  0x5,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x1C:
	LDS  R26,_digit_index
	LDS  R27,_digit_index+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CBI  0x5,5
	SBI  0x5,3
	CBI  0x5,4
	CBI  0x5,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	CBI  0x5,5
	CBI  0x5,3
	SBI  0x5,4
	CBI  0x5,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	CBI  0x5,5
	CBI  0x5,3
	CBI  0x5,4
	SBI  0x5,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x20:
	LDS  R26,_geser
	LDS  R27,_geser+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	CBI  0x5,5
	CBI  0x5,3
	CBI  0x5,4
	CBI  0x5,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x22:
	LDS  R26,_geser
	LDS  R27,_geser+1
	SBIW R26,0
	RET

;RUNTIME LIBRARY

	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	NEG  R27
	NEG  R26
	SBCI R27,0
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
