
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
	.DEF _seconds_jam=R3
	.DEF _seconds_jam_msb=R4
	.DEF _minutes_jam=R5
	.DEF _minutes_jam_msb=R6
	.DEF _seconds_timer=R7
	.DEF _seconds_timer_msb=R8
	.DEF _minutes_timer=R9
	.DEF _minutes_timer_msb=R10
	.DEF _seconds_stopwatch=R11
	.DEF _seconds_stopwatch_msb=R12
	.DEF _minutes_stopwatch=R13
	.DEF _minutes_stopwatch_msb=R14

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

_0x3:
	.DB  0x1
_0x4:
	.DB  0x1

__GLOBAL_INI_TBL:
	.DW  0x0C
	.DW  0x03
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _atur
	.DW  _0x3*2

	.DW  0x01
	.DW  _geser
	.DW  _0x4*2

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
;void init_int1(void);
;void init_int2(void);
;void init_buttonA(void);
;void SevenSegment(int num);
;void aturJam(void);
;void stopWatch(void);
;void alarmTimer(void);
;void tampilanJam(void);

	.DSEG
;interrupt[3] void ext_int1_isr(void)
; 0000 003C {

	.CSEG
_ext_int1_isr:
; .FSTART _ext_int1_isr
	RCALL SUBOPT_0x0
; 0000 003D PIN_BUZZ = 0;
	CBI  0x8,2
; 0000 003E delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
; 0000 003F if (mode == 1)
	RCALL SUBOPT_0x1
	SBIW R26,1
	BRNE _0x7
; 0000 0040 { // mode stopwatch
; 0000 0041 atur = 1;
	RCALL SUBOPT_0x2
; 0000 0042 mode = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x3
; 0000 0043 start = 0;
	RCALL SUBOPT_0x4
; 0000 0044 stopWatch();
	RCALL _stopWatch
; 0000 0045 }
; 0000 0046 else if (mode == 0)
	RJMP _0x8
_0x7:
	RCALL SUBOPT_0x5
	BRNE _0x9
; 0000 0047 { // mode tampilan
; 0000 0048 atur = 1;
	RCALL SUBOPT_0x2
; 0000 0049 mode = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x3
; 0000 004A start = 1;
	RCALL SUBOPT_0x6
; 0000 004B TIMSK1 |= (1 << OCIE1A);
	LDS  R30,111
	ORI  R30,2
	STS  111,R30
; 0000 004C tampilanJam();
	RCALL _tampilanJam
; 0000 004D }
; 0000 004E else if (mode == 2)
	RJMP _0xA
_0x9:
	RCALL SUBOPT_0x1
	SBIW R26,2
	BRNE _0xB
; 0000 004F { // mode timer
; 0000 0050 atur = 1;
	RCALL SUBOPT_0x2
; 0000 0051 mode = 0;
	RCALL SUBOPT_0x7
; 0000 0052 start = 0;
	RCALL SUBOPT_0x4
; 0000 0053 alarmTimer();
	RCALL _alarmTimer
; 0000 0054 }
; 0000 0055 /*else if (mode == 0)
; 0000 0056 {           //mode mengatur
; 0000 0057 mode = 1;
; 0000 0058 TIMSK1 &= ~(1 << OCIE1A);
; 0000 0059 aturJam();
; 0000 005A }  */
; 0000 005B }
_0xB:
_0xA:
_0x8:
	RJMP _0x184
; .FEND
;interrupt[12] void timera_compa_isr(void)
; 0000 005F {
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
; 0000 0060 if (start == 1){
	LDS  R26,_start
	LDS  R27,_start+1
	SBIW R26,1
	BREQ PC+2
	RJMP _0xC
; 0000 0061 if (mode == 1)
	RCALL SUBOPT_0x1
	SBIW R26,1
	BRNE _0xD
; 0000 0062 {
; 0000 0063 // Check if 1 Second has Passed
; 0000 0064 seconds_jam++;
	RCALL SUBOPT_0x8
; 0000 0065 
; 0000 0066 // Check if 1 Minute has Passed
; 0000 0067 if (seconds_jam >= 60)
	BRLT _0xE
; 0000 0068 {
; 0000 0069 seconds_jam = 0;
	RCALL SUBOPT_0x9
; 0000 006A minutes_jam++;
; 0000 006B }
; 0000 006C if (minutes_jam >= 60)
_0xE:
	RCALL SUBOPT_0xA
	BRLT _0xF
; 0000 006D {
; 0000 006E minutes_jam = 0;
	CLR  R5
	CLR  R6
; 0000 006F }
; 0000 0070 // Update Digit Values
; 0000 0071 digits[0] = minutes_jam / 10;
_0xF:
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
; 0000 0072 digits[1] = minutes_jam % 10;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xD
; 0000 0073 digits[2] = seconds_jam / 10;
	RCALL SUBOPT_0xE
; 0000 0074 digits[3] = seconds_jam % 10;
	RJMP _0x17E
; 0000 0075 }
; 0000 0076 else if(mode == 0)
_0xD:
	RCALL SUBOPT_0x5
	BRNE _0x11
; 0000 0077 {
; 0000 0078 // Check if 1 Second has Passed
; 0000 0079 seconds_timer--;
	__GETW1R 7,8
	SBIW R30,1
	__PUTW1R 7,8
	ADIW R30,1
; 0000 007A seconds_jam++;
	RCALL SUBOPT_0xF
; 0000 007B 
; 0000 007C // Check if 1 Minute has Passed
; 0000 007D if (seconds_jam >= 60)
	BRLT _0x12
; 0000 007E {
; 0000 007F seconds_jam = 0;
	RCALL SUBOPT_0x9
; 0000 0080 minutes_jam++;
; 0000 0081 }
; 0000 0082 if (minutes_jam >= 60)
_0x12:
	RCALL SUBOPT_0xA
	BRLT _0x13
; 0000 0083 {
; 0000 0084 minutes_jam = 0;
	CLR  R5
	CLR  R6
; 0000 0085 }
; 0000 0086 
; 0000 0087 // Check if 1 Minute has Passed
; 0000 0088 if (seconds_timer == 0 && minutes_timer == 0)
_0x13:
	CLR  R0
	CP   R0,R7
	CPC  R0,R8
	BRNE _0x15
	CLR  R0
	CP   R0,R9
	CPC  R0,R10
	BREQ _0x16
_0x15:
	RJMP _0x14
_0x16:
; 0000 0089 { // timer sudah mencapai 0
; 0000 008A PIN_BUZZ = 1;
	SBI  0x8,2
; 0000 008B start = 0;
	RCALL SUBOPT_0x4
; 0000 008C }
; 0000 008D if (seconds_timer <= -1)
_0x14:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R7
	CPC  R31,R8
	BRLT _0x19
; 0000 008E {
; 0000 008F seconds_timer = 59;
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	__PUTW1R 7,8
; 0000 0090 minutes_timer--;
	__GETW1R 9,10
	SBIW R30,1
	__PUTW1R 9,10
; 0000 0091 }
; 0000 0092 if (minutes_timer <= -1)
_0x19:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R9
	CPC  R31,R10
	BRLT _0x1A
; 0000 0093 {
; 0000 0094 minutes_timer = 0;
	CLR  R9
	CLR  R10
; 0000 0095 }
; 0000 0096 // Update Digit Values
; 0000 0097 digits[0] = minutes_timer / 10;
_0x1A:
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
; 0000 0098 digits[1] = minutes_timer % 10;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xD
; 0000 0099 digits[2] = seconds_timer / 10;
	RCALL SUBOPT_0x11
; 0000 009A digits[3] = seconds_timer % 10;
	RJMP _0x17E
; 0000 009B }
; 0000 009C else if (mode == 2)
_0x11:
	RCALL SUBOPT_0x1
	SBIW R26,2
	BRNE _0x1C
; 0000 009D {
; 0000 009E // Check if 1 Second has Passed
; 0000 009F seconds_stopwatch++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 11,12,30,31
; 0000 00A0 seconds_jam++;
	RCALL SUBOPT_0x8
; 0000 00A1 
; 0000 00A2 // Check if 1 Minute has Passed
; 0000 00A3 if (seconds_jam >= 60)
	BRLT _0x1D
; 0000 00A4 {
; 0000 00A5 seconds_jam = 0;
	RCALL SUBOPT_0x9
; 0000 00A6 minutes_jam++;
; 0000 00A7 }
; 0000 00A8 if (minutes_jam >= 60)
_0x1D:
	RCALL SUBOPT_0xA
	BRLT _0x1E
; 0000 00A9 {
; 0000 00AA minutes_jam = 0;
	CLR  R5
	CLR  R6
; 0000 00AB }
; 0000 00AC // Check if 1 Minute has Passed
; 0000 00AD if (seconds_stopwatch >= 60)
_0x1E:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R11,R30
	CPC  R12,R31
	BRLT _0x1F
; 0000 00AE {
; 0000 00AF seconds_stopwatch = 0;
	CLR  R11
	CLR  R12
; 0000 00B0 minutes_stopwatch++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 13,14,30,31
; 0000 00B1 }
; 0000 00B2 if (minutes_stopwatch >= 60)
_0x1F:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R13,R30
	CPC  R14,R31
	BRLT _0x20
; 0000 00B3 {
; 0000 00B4 minutes_stopwatch = 00;
	CLR  R13
	CLR  R14
; 0000 00B5 }
; 0000 00B6 // Update Digit Values
; 0000 00B7 digits[0] = minutes_stopwatch / 10;
_0x20:
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xC
; 0000 00B8 digits[1] = minutes_stopwatch % 10;
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xD
; 0000 00B9 digits[2] = seconds_stopwatch / 10;
	RCALL SUBOPT_0x13
; 0000 00BA digits[3] = seconds_stopwatch % 10;
_0x17E:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x14
; 0000 00BB }
; 0000 00BC } else{
_0x1C:
	RJMP _0x21
_0xC:
; 0000 00BD seconds_jam++;
	RCALL SUBOPT_0x8
; 0000 00BE 
; 0000 00BF // Check if 1 Minute has Passed
; 0000 00C0 if (seconds_jam >= 60)
	BRLT _0x22
; 0000 00C1 {
; 0000 00C2 seconds_jam = 0;
	RCALL SUBOPT_0x9
; 0000 00C3 minutes_jam++;
; 0000 00C4 }
; 0000 00C5 if (minutes_jam >= 60)
_0x22:
	RCALL SUBOPT_0xA
	BRLT _0x23
; 0000 00C6 {
; 0000 00C7 minutes_jam = 0;
	CLR  R5
	CLR  R6
; 0000 00C8 }
; 0000 00C9 if (mode == 2){
_0x23:
	RCALL SUBOPT_0x1
	SBIW R26,2
	BRNE _0x24
; 0000 00CA digits[0] = minutes_stopwatch / 10;
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xC
; 0000 00CB digits[1] = minutes_stopwatch % 10;
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xD
; 0000 00CC digits[2] = seconds_stopwatch / 10;
	RCALL SUBOPT_0x13
; 0000 00CD digits[3] = seconds_stopwatch % 10;
	RJMP _0x17F
; 0000 00CE }
; 0000 00CF else if(mode == 1) {
_0x24:
	RCALL SUBOPT_0x1
	SBIW R26,1
	BRNE _0x26
; 0000 00D0 digits[0] = minutes_timer / 10;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
; 0000 00D1 digits[1] = minutes_timer % 10;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xD
; 0000 00D2 digits[2] = seconds_timer / 10;
	RCALL SUBOPT_0x11
; 0000 00D3 digits[3] = seconds_timer % 10;
_0x17F:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x14
; 0000 00D4 }
; 0000 00D5 }
_0x26:
_0x21:
; 0000 00D6 }
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
; 0000 00DA {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	RCALL SUBOPT_0x0
; 0000 00DB // Update Segment Values for Current Digit
; 0000 00DC SevenSegment(digits[digit_index]);
	RCALL SUBOPT_0x15
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
; 0000 00DD 
; 0000 00DE // Enable Multiplexing for Current Digit
; 0000 00DF // Elif for choose seven SevenSegmen
; 0000 00E0 if (atur == 1)
	LDS  R26,_atur
	LDS  R27,_atur+1
	SBIW R26,1
	BRNE _0x27
; 0000 00E1 {
; 0000 00E2 if (digit_index == 0)
	RCALL SUBOPT_0x15
	SBIW R30,0
	BRNE _0x28
; 0000 00E3 {
; 0000 00E4 DIGIT_1 = 1;
	RCALL SUBOPT_0x16
; 0000 00E5 DIGIT_2 = 0;
; 0000 00E6 DIGIT_3 = 0;
; 0000 00E7 DIGIT_4 = 0;
; 0000 00E8 }
; 0000 00E9 else if (digit_index == 1)
	RJMP _0x31
_0x28:
	RCALL SUBOPT_0x17
	SBIW R26,1
	BRNE _0x32
; 0000 00EA {
; 0000 00EB DIGIT_1 = 0;
	RCALL SUBOPT_0x18
; 0000 00EC DIGIT_2 = 1;
; 0000 00ED DIGIT_3 = 0;
; 0000 00EE DIGIT_4 = 0;
; 0000 00EF }
; 0000 00F0 else if (digit_index == 2)
	RJMP _0x3B
_0x32:
	RCALL SUBOPT_0x17
	SBIW R26,2
	BRNE _0x3C
; 0000 00F1 {
; 0000 00F2 DIGIT_1 = 0;
	RCALL SUBOPT_0x19
; 0000 00F3 DIGIT_2 = 0;
; 0000 00F4 DIGIT_3 = 1;
; 0000 00F5 DIGIT_4 = 0;
; 0000 00F6 }
; 0000 00F7 else if (digit_index == 3)
	RJMP _0x45
_0x3C:
	RCALL SUBOPT_0x17
	SBIW R26,3
	BRNE _0x46
; 0000 00F8 {
; 0000 00F9 DIGIT_1 = 0;
	RCALL SUBOPT_0x1A
; 0000 00FA DIGIT_2 = 0;
; 0000 00FB DIGIT_3 = 0;
; 0000 00FC DIGIT_4 = 1;
; 0000 00FD }
; 0000 00FE }
_0x46:
_0x45:
_0x3B:
_0x31:
; 0000 00FF else
	RJMP _0x4F
_0x27:
; 0000 0100 {
; 0000 0101 if (digit_index == 0 && geser == 1)
	RCALL SUBOPT_0x17
	SBIW R26,0
	BRNE _0x51
	RCALL SUBOPT_0x1B
	BREQ _0x52
_0x51:
	RJMP _0x50
_0x52:
; 0000 0102 {
; 0000 0103 DIGIT_1 = 1;
	RCALL SUBOPT_0x16
; 0000 0104 DIGIT_2 = 0;
; 0000 0105 DIGIT_3 = 0;
; 0000 0106 DIGIT_4 = 0;
; 0000 0107 }
; 0000 0108 else if (digit_index == 1 && geser == 1)
	RJMP _0x5B
_0x50:
	RCALL SUBOPT_0x17
	SBIW R26,1
	BRNE _0x5D
	RCALL SUBOPT_0x1B
	BREQ _0x5E
_0x5D:
	RJMP _0x5C
_0x5E:
; 0000 0109 {
; 0000 010A DIGIT_1 = 0;
	RCALL SUBOPT_0x18
; 0000 010B DIGIT_2 = 1;
; 0000 010C DIGIT_3 = 0;
; 0000 010D DIGIT_4 = 0;
; 0000 010E }
; 0000 010F else if (digit_index == 2 && geser == 1)
	RJMP _0x67
_0x5C:
	RCALL SUBOPT_0x17
	SBIW R26,2
	BRNE _0x69
	RCALL SUBOPT_0x1B
	BREQ _0x6A
_0x69:
	RJMP _0x68
_0x6A:
; 0000 0110 {
; 0000 0111 DIGIT_1 = 0;
	RCALL SUBOPT_0x1C
; 0000 0112 DIGIT_2 = 0;
; 0000 0113 DIGIT_3 = 0;
; 0000 0114 DIGIT_4 = 0;
; 0000 0115 }
; 0000 0116 else if (digit_index == 3 && geser == 1)
	RJMP _0x73
_0x68:
	RCALL SUBOPT_0x17
	SBIW R26,3
	BRNE _0x75
	RCALL SUBOPT_0x1B
	BREQ _0x76
_0x75:
	RJMP _0x74
_0x76:
; 0000 0117 {
; 0000 0118 DIGIT_1 = 0;
	RCALL SUBOPT_0x1C
; 0000 0119 DIGIT_2 = 0;
; 0000 011A DIGIT_3 = 0;
; 0000 011B DIGIT_4 = 0;
; 0000 011C }
; 0000 011D else if (digit_index == 0 && geser == 0)
	RJMP _0x7F
_0x74:
	RCALL SUBOPT_0x17
	SBIW R26,0
	BRNE _0x81
	RCALL SUBOPT_0x1D
	BREQ _0x82
_0x81:
	RJMP _0x80
_0x82:
; 0000 011E {
; 0000 011F DIGIT_1 = 0;
	RCALL SUBOPT_0x1C
; 0000 0120 DIGIT_2 = 0;
; 0000 0121 DIGIT_3 = 0;
; 0000 0122 DIGIT_4 = 0;
; 0000 0123 }
; 0000 0124 else if (digit_index == 1 && geser == 0)
	RJMP _0x8B
_0x80:
	RCALL SUBOPT_0x17
	SBIW R26,1
	BRNE _0x8D
	RCALL SUBOPT_0x1D
	BREQ _0x8E
_0x8D:
	RJMP _0x8C
_0x8E:
; 0000 0125 {
; 0000 0126 DIGIT_1 = 0;
	RCALL SUBOPT_0x1C
; 0000 0127 DIGIT_2 = 0;
; 0000 0128 DIGIT_3 = 0;
; 0000 0129 DIGIT_4 = 0;
; 0000 012A }
; 0000 012B else if (digit_index == 2 && geser == 0)
	RJMP _0x97
_0x8C:
	RCALL SUBOPT_0x17
	SBIW R26,2
	BRNE _0x99
	RCALL SUBOPT_0x1D
	BREQ _0x9A
_0x99:
	RJMP _0x98
_0x9A:
; 0000 012C {
; 0000 012D DIGIT_1 = 0;
	RCALL SUBOPT_0x19
; 0000 012E DIGIT_2 = 0;
; 0000 012F DIGIT_3 = 1;
; 0000 0130 DIGIT_4 = 0;
; 0000 0131 }
; 0000 0132 else if (digit_index == 3 && geser == 0)
	RJMP _0xA3
_0x98:
	RCALL SUBOPT_0x17
	SBIW R26,3
	BRNE _0xA5
	RCALL SUBOPT_0x1D
	BREQ _0xA6
_0xA5:
	RJMP _0xA4
_0xA6:
; 0000 0133 {
; 0000 0134 DIGIT_1 = 0;
	RCALL SUBOPT_0x1A
; 0000 0135 DIGIT_2 = 0;
; 0000 0136 DIGIT_3 = 0;
; 0000 0137 DIGIT_4 = 1;
; 0000 0138 }
; 0000 0139 }
_0xA4:
_0xA3:
_0x97:
_0x8B:
_0x7F:
_0x73:
_0x67:
_0x5B:
_0x4F:
; 0000 013A 
; 0000 013B // Increment Digit Index
; 0000 013C digit_index++;
	LDI  R26,LOW(_digit_index)
	LDI  R27,HIGH(_digit_index)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 013D 
; 0000 013E // Wrap Around Digit Index
; 0000 013F if (digit_index >= 4)
	RCALL SUBOPT_0x17
	SBIW R26,4
	BRLT _0xAF
; 0000 0140 {
; 0000 0141 digit_index = 0;
	LDI  R30,LOW(0)
	STS  _digit_index,R30
	STS  _digit_index+1,R30
; 0000 0142 }
; 0000 0143 }
_0xAF:
_0x184:
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
; 0000 0148 {
_main:
; .FSTART _main
; 0000 0149 // Initialize Timer1
; 0000 014A // set prescaler 1024
; 0000 014B init_int1();
	RCALL _init_int1
; 0000 014C init_int2();
	RCALL _init_int2
; 0000 014D init_buttonA();
	RCALL _init_buttonA
; 0000 014E 
; 0000 014F // Enable Interrupts
; 0000 0150 #asm("sei")
	SEI
; 0000 0151 
; 0000 0152 // Set Seven Segment Pins as Output
; 0000 0153 DDRB = 0b111111;
	LDI  R30,LOW(63)
	OUT  0x4,R30
; 0000 0154 DDRD &= ~(1 << DDD0) & ~(1 << DDD1) & ~(1 << DDD2) & ~(1 << DDD3) ;
	IN   R30,0xA
	ANDI R30,LOW(0xF0)
	OUT  0xA,R30
; 0000 0155 DDRD |= (1 << DDD4) | (1 << DDD5) | (1 << DDD6) | (1 << DDD7);
	IN   R30,0xA
	ORI  R30,LOW(0xF0)
	OUT  0xA,R30
; 0000 0156 DDRC |= (1 << DDC0) | (1 << DDC1) | (1 << DDC2);
	IN   R30,0x7
	ORI  R30,LOW(0x7)
	OUT  0x7,R30
; 0000 0157 PORTD |= (1 << BUTTON_A) | (1 << BUTTON_B) | (1 << BUTTON_C) | (1 << BUTTON_D);
	IN   R22,11
	LDI  R30,0
	SBIC 0x9,0
	LDI  R30,1
	LDI  R26,LOW(1)
	RCALL __LSLB12
	MOV  R1,R30
	LDI  R30,0
	SBIC 0x9,1
	LDI  R30,1
	RCALL __LSLB12
	OR   R1,R30
	LDI  R30,0
	SBIC 0x9,2
	LDI  R30,1
	RCALL __LSLB12
	OR   R1,R30
	LDI  R30,0
	SBIC 0x9,3
	LDI  R30,1
	RCALL __LSLB12
	OR   R30,R1
	OR   R30,R22
	OUT  0xB,R30
; 0000 0158 
; 0000 0159 TIMSK1 &= ~(1 << OCIE1A);
	RCALL SUBOPT_0x1E
; 0000 015A mode = 0;
	RCALL SUBOPT_0x7
; 0000 015B aturJam();
	RCALL _aturJam
; 0000 015C while (1)
_0xB0:
; 0000 015D {
; 0000 015E }
	RJMP _0xB0
; 0000 015F }
_0xB3:
	RJMP _0xB3
; .FEND
;void init_int1(void)
; 0000 0163 {                        // 1s
_init_int1:
; .FSTART _init_int1
; 0000 0164 TCCR1A = (1 << WGM12); // ctc
	LDI  R30,LOW(8)
	STS  128,R30
; 0000 0165 TCCR1B = (1 << CS12);  // 256
	LDI  R30,LOW(4)
	STS  129,R30
; 0000 0166 TCNT1H = 0;
	LDI  R30,LOW(0)
	STS  133,R30
; 0000 0167 TCNT1L = 0;
	STS  132,R30
; 0000 0168 OCR1AH = 0xF4;
	LDI  R30,LOW(244)
	STS  137,R30
; 0000 0169 OCR1AL = 0x24;
	LDI  R30,LOW(36)
	STS  136,R30
; 0000 016A TIMSK1 = 0b00000010;
	LDI  R30,LOW(2)
	STS  111,R30
; 0000 016B }
	RET
; .FEND
;void init_int2(void)
; 0000 016E { // 1ms
_init_int2:
; .FSTART _init_int2
; 0000 016F TIMSK0 = 0b00000001;
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 0170 TCCR0B = (1 << CS02); // 256
	LDI  R30,LOW(4)
	OUT  0x25,R30
; 0000 0171 TCNT0 = 0x83;
	LDI  R30,LOW(131)
	OUT  0x26,R30
; 0000 0172 }
	RET
; .FEND
;void init_buttonA(void)
; 0000 0175 {
_init_buttonA:
; .FSTART _init_buttonA
; 0000 0176 // SET FALLING EDGE PADA INT1
; 0000 0177 EICRA = (1 << ISC11) | (0 << ISC10) | (0 << ISC01) | (0 << ISC00);
	LDI  R30,LOW(8)
	STS  105,R30
; 0000 0178 // ENABLE INT1
; 0000 0179 EIMSK = (1 << INT1) | (0 << INT0);
	LDI  R30,LOW(2)
	OUT  0x1D,R30
; 0000 017A }
	RET
; .FEND
;void SevenSegment(int num)
; 0000 017D {
_SevenSegment:
; .FSTART _SevenSegment
; 0000 017E // Elif for number modifier Seven Segments
; 0000 017F if (num == 0)
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	num -> R16,R17
	MOV  R0,R16
	OR   R0,R17
	BRNE _0xB4
; 0000 0180 {
; 0000 0181 SEG_A = 0;
	RCALL SUBOPT_0x1F
; 0000 0182 SEG_B = 0;
; 0000 0183 SEG_C = 0;
; 0000 0184 SEG_D = 0;
; 0000 0185 SEG_E = 0;
	CBI  0x5,0
; 0000 0186 SEG_F = 0;
	CBI  0x5,1
; 0000 0187 SEG_G = 1;
	SBI  0x5,2
; 0000 0188 }
; 0000 0189 else if (num == 1)
	RJMP _0xC3
_0xB4:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0xC4
; 0000 018A {
; 0000 018B SEG_A = 1;
	RCALL SUBOPT_0x20
; 0000 018C SEG_B = 0;
; 0000 018D SEG_C = 0;
; 0000 018E SEG_D = 1;
; 0000 018F SEG_E = 1;
	SBI  0x5,0
; 0000 0190 SEG_F = 1;
	SBI  0x5,1
; 0000 0191 SEG_G = 1;
	SBI  0x5,2
; 0000 0192 }
; 0000 0193 else if (num == 2)
	RJMP _0xD3
_0xC4:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0xD4
; 0000 0194 {
; 0000 0195 SEG_A = 0;
	CBI  0xB,4
; 0000 0196 SEG_B = 0;
	CBI  0xB,5
; 0000 0197 SEG_C = 1;
	SBI  0xB,6
; 0000 0198 SEG_D = 0;
	CBI  0xB,7
; 0000 0199 SEG_E = 0;
	CBI  0x5,0
; 0000 019A SEG_F = 1;
	SBI  0x5,1
; 0000 019B SEG_G = 0;
	RJMP _0x180
; 0000 019C }
; 0000 019D else if (num == 3)
_0xD4:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0xE4
; 0000 019E {
; 0000 019F SEG_A = 0;
	RCALL SUBOPT_0x1F
; 0000 01A0 SEG_B = 0;
; 0000 01A1 SEG_C = 0;
; 0000 01A2 SEG_D = 0;
; 0000 01A3 SEG_E = 1;
	SBI  0x5,0
; 0000 01A4 SEG_F = 1;
	SBI  0x5,1
; 0000 01A5 SEG_G = 0;
	RJMP _0x180
; 0000 01A6 }
; 0000 01A7 else if (num == 4)
_0xE4:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0xF4
; 0000 01A8 {
; 0000 01A9 SEG_A = 1;
	RCALL SUBOPT_0x20
; 0000 01AA SEG_B = 0;
; 0000 01AB SEG_C = 0;
; 0000 01AC SEG_D = 1;
; 0000 01AD SEG_E = 1;
	RJMP _0x181
; 0000 01AE SEG_F = 0;
; 0000 01AF SEG_G = 0;
; 0000 01B0 }
; 0000 01B1 else if (num == 5)
_0xF4:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x104
; 0000 01B2 {
; 0000 01B3 SEG_A = 0;
	CBI  0xB,4
; 0000 01B4 SEG_B = 1;
	SBI  0xB,5
; 0000 01B5 SEG_C = 0;
	RJMP _0x182
; 0000 01B6 SEG_D = 0;
; 0000 01B7 SEG_E = 1;
; 0000 01B8 SEG_F = 0;
; 0000 01B9 SEG_G = 0;
; 0000 01BA }
; 0000 01BB else if (num == 6)
_0x104:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x114
; 0000 01BC {
; 0000 01BD SEG_A = 0;
	CBI  0xB,4
; 0000 01BE SEG_B = 1;
	SBI  0xB,5
; 0000 01BF SEG_C = 0;
	CBI  0xB,6
; 0000 01C0 SEG_D = 0;
	CBI  0xB,7
; 0000 01C1 SEG_E = 0;
	CBI  0x5,0
; 0000 01C2 SEG_F = 0;
	RJMP _0x183
; 0000 01C3 SEG_G = 0;
; 0000 01C4 }
; 0000 01C5 else if (num == 7)
_0x114:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x124
; 0000 01C6 {
; 0000 01C7 SEG_A = 0;
	CBI  0xB,4
; 0000 01C8 SEG_B = 0;
	CBI  0xB,5
; 0000 01C9 SEG_C = 0;
	CBI  0xB,6
; 0000 01CA SEG_D = 1;
	SBI  0xB,7
; 0000 01CB SEG_E = 1;
	SBI  0x5,0
; 0000 01CC SEG_F = 1;
	SBI  0x5,1
; 0000 01CD SEG_G = 1;
	SBI  0x5,2
; 0000 01CE }
; 0000 01CF else if (num == 8)
	RJMP _0x133
_0x124:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x134
; 0000 01D0 {
; 0000 01D1 SEG_A = 0;
	RCALL SUBOPT_0x1F
; 0000 01D2 SEG_B = 0;
; 0000 01D3 SEG_C = 0;
; 0000 01D4 SEG_D = 0;
; 0000 01D5 SEG_E = 0;
	CBI  0x5,0
; 0000 01D6 SEG_F = 0;
	RJMP _0x183
; 0000 01D7 SEG_G = 0;
; 0000 01D8 }
; 0000 01D9 else if (num == 9)
_0x134:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x144
; 0000 01DA {
; 0000 01DB SEG_A = 0;
	CBI  0xB,4
; 0000 01DC SEG_B = 0;
	CBI  0xB,5
; 0000 01DD SEG_C = 0;
_0x182:
	CBI  0xB,6
; 0000 01DE SEG_D = 0;
	CBI  0xB,7
; 0000 01DF SEG_E = 1;
_0x181:
	SBI  0x5,0
; 0000 01E0 SEG_F = 0;
_0x183:
	CBI  0x5,1
; 0000 01E1 SEG_G = 0;
_0x180:
	CBI  0x5,2
; 0000 01E2 }
; 0000 01E3 }
_0x144:
_0x133:
_0xD3:
_0xC3:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;void aturJam(void)
; 0000 01E6 {
_aturJam:
; .FSTART _aturJam
; 0000 01E7 #asm("sei")
	SEI
; 0000 01E8 atur = 0;
	LDI  R30,LOW(0)
	STS  _atur,R30
	STS  _atur+1,R30
; 0000 01E9 TIMSK1 &= ~(1 << OCIE1A);
	RCALL SUBOPT_0x1E
; 0000 01EA while (!(EIFR & (1 << INTF1)))
_0x153:
	SBIC 0x1C,1
	RJMP _0x155
; 0000 01EB { // menunggu sampai interrupt ditekan
; 0000 01EC if (BUTTON_D == 1)
	SBIS 0x9,3
	RJMP _0x156
; 0000 01ED {
; 0000 01EE delay_ms(300);
	RCALL SUBOPT_0x21
; 0000 01EF if (geser == 0)
	BRNE _0x157
; 0000 01F0 {
; 0000 01F1 seconds_jam++;
	RCALL SUBOPT_0xF
; 0000 01F2 if (seconds_jam >= 60)
	BRLT _0x158
; 0000 01F3 {
; 0000 01F4 seconds_jam = 0;
	CLR  R3
	CLR  R4
; 0000 01F5 }
; 0000 01F6 }
_0x158:
; 0000 01F7 else
	RJMP _0x159
_0x157:
; 0000 01F8 {
; 0000 01F9 minutes_jam++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 5,6,30,31
; 0000 01FA if (minutes_jam >= 60)
	RCALL SUBOPT_0xA
	BRLT _0x15A
; 0000 01FB {
; 0000 01FC minutes_jam = 0;
	CLR  R5
	CLR  R6
; 0000 01FD }
; 0000 01FE }
_0x15A:
_0x159:
; 0000 01FF }
; 0000 0200 else if (BUTTON_C == 1)
	RJMP _0x15B
_0x156:
	SBIS 0x9,2
	RJMP _0x15C
; 0000 0201 {
; 0000 0202 delay_ms(300);
	RCALL SUBOPT_0x21
; 0000 0203 if (geser == 0)
	BRNE _0x15D
; 0000 0204 {
; 0000 0205 seconds_jam--;
	__GETW1R 3,4
	SBIW R30,1
	__PUTW1R 3,4
	ADIW R30,1
; 0000 0206 if (seconds_jam <= -1)
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R3
	CPC  R31,R4
	BRLT _0x15E
; 0000 0207 {
; 0000 0208 seconds_jam = 59;
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	__PUTW1R 3,4
; 0000 0209 }
; 0000 020A }
_0x15E:
; 0000 020B else
	RJMP _0x15F
_0x15D:
; 0000 020C {
; 0000 020D minutes_jam--;
	__GETW1R 5,6
	SBIW R30,1
	__PUTW1R 5,6
; 0000 020E if (minutes_jam <= -1)
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R5
	CPC  R31,R6
	BRLT _0x160
; 0000 020F {
; 0000 0210 minutes_jam = 59;
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	__PUTW1R 5,6
; 0000 0211 }
; 0000 0212 }
_0x160:
_0x15F:
; 0000 0213 }
; 0000 0214 else if (BUTTON_B == 1)
	RJMP _0x161
_0x15C:
	SBIS 0x9,1
	RJMP _0x162
; 0000 0215 {
; 0000 0216 delay_ms(300);
	RCALL SUBOPT_0x21
; 0000 0217 if (geser == 0)
	BRNE _0x163
; 0000 0218 {
; 0000 0219 geser = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _geser,R30
	STS  _geser+1,R31
; 0000 021A }
; 0000 021B else
	RJMP _0x164
_0x163:
; 0000 021C {
; 0000 021D geser = 0;
	LDI  R30,LOW(0)
	STS  _geser,R30
	STS  _geser+1,R30
; 0000 021E }
_0x164:
; 0000 021F }
; 0000 0220 // Update Digit Values
; 0000 0221 digits[0] = minutes_jam / 10;
_0x162:
_0x161:
_0x15B:
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
; 0000 0222 digits[1] = minutes_jam % 10;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xD
; 0000 0223 digits[2] = seconds_jam / 10;
	RCALL SUBOPT_0xE
; 0000 0224 digits[3] = seconds_jam % 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x14
; 0000 0225 }
	RJMP _0x153
_0x155:
; 0000 0226 atur = 1;
	RCALL SUBOPT_0x2
; 0000 0227 // Clear the external interrupt flag
; 0000 0228 EIFR &= (0 << INTF1);
	RJMP _0x2000001
; 0000 0229 
; 0000 022A // Return from function
; 0000 022B return;
; 0000 022C }
; .FEND
;void stopWatch(void)
; 0000 022F {
_stopWatch:
; .FSTART _stopWatch
; 0000 0230 #asm("sei")
	SEI
; 0000 0231 seconds_stopwatch = 0;
	RCALL SUBOPT_0x22
; 0000 0232 minutes_stopwatch = 0;
; 0000 0233 start = 0;
	RCALL SUBOPT_0x4
; 0000 0234 
; 0000 0235 while (!(EIFR & (1 << INTF1)))
_0x165:
	SBIC 0x1C,1
	RJMP _0x167
; 0000 0236 {                    // menunggu sampai interrupt ditekan
; 0000 0237 if (BUTTON_D == 1) // start
	SBIS 0x9,3
	RJMP _0x168
; 0000 0238 {
; 0000 0239 delay_ms(300);
	RCALL SUBOPT_0x23
; 0000 023A start = 1;
; 0000 023B }
; 0000 023C else if (BUTTON_C == 1) // pause
	RJMP _0x169
_0x168:
	SBIS 0x9,2
	RJMP _0x16A
; 0000 023D {
; 0000 023E delay_ms(300);
	RCALL SUBOPT_0x24
; 0000 023F start = 0;
; 0000 0240 }
; 0000 0241 else if (BUTTON_B == 1)
	RJMP _0x16B
_0x16A:
	SBIS 0x9,1
	RJMP _0x16C
; 0000 0242 { // pause and reset
; 0000 0243 delay_ms(300);
	RCALL SUBOPT_0x24
; 0000 0244 start = 0;
; 0000 0245 seconds_stopwatch = 0;
	RCALL SUBOPT_0x22
; 0000 0246 minutes_stopwatch = 0;
; 0000 0247 }
; 0000 0248 // Update Digit Values
; 0000 0249 digits[0] = minutes_stopwatch / 10;
_0x16C:
_0x16B:
_0x169:
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xC
; 0000 024A digits[1] = minutes_stopwatch % 10;
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xD
; 0000 024B digits[2] = seconds_stopwatch / 10;
	RCALL SUBOPT_0x13
; 0000 024C digits[3] = seconds_stopwatch % 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x14
; 0000 024D }
	RJMP _0x165
_0x167:
; 0000 024E 
; 0000 024F // Clear the external interrupt flag
; 0000 0250 EIFR &= (0 << INTF1);
	RJMP _0x2000001
; 0000 0251 
; 0000 0252 // Return from function
; 0000 0253 return;
; 0000 0254 }
; .FEND
;void alarmTimer(void)
; 0000 0257 {
_alarmTimer:
; .FSTART _alarmTimer
; 0000 0258 #asm("sei")
	SEI
; 0000 0259 start = 0;
	RCALL SUBOPT_0x4
; 0000 025A seconds_timer = 0;
	CLR  R7
	CLR  R8
; 0000 025B minutes_timer = 0;
	CLR  R9
	CLR  R10
; 0000 025C while (!(EIFR & (1 << INTF1)))
_0x16D:
	SBIC 0x1C,1
	RJMP _0x16F
; 0000 025D { // menunggu sampai interrupt ditekan
; 0000 025E if (BUTTON_D == 1)
	SBIS 0x9,3
	RJMP _0x170
; 0000 025F {
; 0000 0260 delay_ms(300);
	RCALL SUBOPT_0x25
; 0000 0261 PIN_BUZZ = 0;
; 0000 0262 seconds_timer++;
	__ADDWRR 7,8,30,31
; 0000 0263 if (seconds_timer >= 60)
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R7,R30
	CPC  R8,R31
	BRLT _0x173
; 0000 0264 {
; 0000 0265 seconds_timer = 0;
	CLR  R7
	CLR  R8
; 0000 0266 }
; 0000 0267 }
_0x173:
; 0000 0268 else if (BUTTON_C == 1)
	RJMP _0x174
_0x170:
	SBIS 0x9,2
	RJMP _0x175
; 0000 0269 {
; 0000 026A delay_ms(300);
	RCALL SUBOPT_0x25
; 0000 026B PIN_BUZZ = 0;
; 0000 026C minutes_timer++;
	__ADDWRR 9,10,30,31
; 0000 026D if (minutes_timer >= 60)
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R9,R30
	CPC  R10,R31
	BRLT _0x178
; 0000 026E {
; 0000 026F minutes_timer = 0;
	CLR  R9
	CLR  R10
; 0000 0270 }
; 0000 0271 }
_0x178:
; 0000 0272 else if (BUTTON_B == 1)
	RJMP _0x179
_0x175:
	SBIC 0x9,1
; 0000 0273 {
; 0000 0274 delay_ms(300);
	RCALL SUBOPT_0x23
; 0000 0275 start = 1;
; 0000 0276 }
; 0000 0277 // Update Digit Values
; 0000 0278 digits[0] = minutes_timer / 10;
_0x179:
_0x174:
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xC
; 0000 0279 digits[1] = minutes_timer % 10;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xD
; 0000 027A digits[2] = seconds_timer / 10;
	RCALL SUBOPT_0x11
; 0000 027B digits[3] = seconds_timer % 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x14
; 0000 027C }
	RJMP _0x16D
_0x16F:
; 0000 027D // Clear the external interrupt flag
; 0000 027E EIFR &= (0 << INTF1);
	RJMP _0x2000001
; 0000 027F 
; 0000 0280 // Return from function
; 0000 0281 return;
; 0000 0282 }
; .FEND
;void tampilanJam(void)
; 0000 0285 {
_tampilanJam:
; .FSTART _tampilanJam
; 0000 0286 #asm("sei")
	SEI
; 0000 0287 
; 0000 0288 while (!(EIFR & (1 << INTF1)))
_0x17B:
	SBIS 0x1C,1
; 0000 0289 { // menunggu sampai interrupt ditekan
; 0000 028A }
	RJMP _0x17B
; 0000 028B 
; 0000 028C // Clear the external interrupt flag
; 0000 028D EIFR &= (0 << INTF1);
_0x2000001:
	IN   R30,0x1C
	ANDI R30,LOW(0x0)
	OUT  0x1C,R30
; 0000 028E 
; 0000 028F // Return from function
; 0000 0290 return;
	RET
; 0000 0291 }
; .FEND

	.DSEG
_digits:
	.BYTE 0x8
_digit_index:
	.BYTE 0x2
_atur:
	.BYTE 0x2
_geser:
	.BYTE 0x2
_mode:
	.BYTE 0x2
_start:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	LDS  R26,_mode
	LDS  R27,_mode+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _atur,R30
	STS  _atur+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	STS  _mode,R30
	STS  _mode+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	STS  _start,R30
	STS  _start+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	LDS  R30,_mode
	LDS  R31,_mode+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _start,R30
	STS  _start+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	STS  _mode,R30
	STS  _mode+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 3,4,30,31
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R3,R30
	CPC  R4,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9:
	CLR  R3
	CLR  R4
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 5,6,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R5,R30
	CPC  R6,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	__GETW2R 5,6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0xC:
	RCALL __DIVW21
	STS  _digits,R30
	STS  _digits+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0xD:
	RCALL __MODW21
	__PUTW1MN _digits,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xE:
	__GETW2R 3,4
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	__PUTW1MN _digits,4
	__GETW2R 3,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	__GETW1R 3,4
	ADIW R30,1
	__PUTW1R 3,4
	SBIW R30,1
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R3,R30
	CPC  R4,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	__GETW2R 9,10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x11:
	__GETW2R 7,8
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	__PUTW1MN _digits,4
	__GETW2R 7,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x12:
	__GETW2R 13,14
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x13:
	__GETW2R 11,12
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	__PUTW1MN _digits,4
	__GETW2R 11,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x14:
	RCALL __MODW21
	__PUTW1MN _digits,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDS  R30,_digit_index
	LDS  R31,_digit_index+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	SBI  0x5,4
	CBI  0x5,5
	CBI  0x8,0
	CBI  0x8,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x17:
	LDS  R26,_digit_index
	LDS  R27,_digit_index+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	CBI  0x5,4
	SBI  0x5,5
	CBI  0x8,0
	CBI  0x8,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	CBI  0x5,4
	CBI  0x5,5
	SBI  0x8,0
	CBI  0x8,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	CBI  0x5,4
	CBI  0x5,5
	CBI  0x8,0
	SBI  0x8,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1B:
	LDS  R26,_geser
	LDS  R27,_geser+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	CBI  0x5,4
	CBI  0x5,5
	CBI  0x8,0
	CBI  0x8,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1D:
	LDS  R26,_geser
	LDS  R27,_geser+1
	SBIW R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LDS  R30,111
	ANDI R30,0xFD
	STS  111,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1F:
	CBI  0xB,4
	CBI  0xB,5
	CBI  0xB,6
	CBI  0xB,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	SBI  0xB,4
	CBI  0xB,5
	CBI  0xB,6
	SBI  0xB,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
	LDS  R30,_geser
	LDS  R31,_geser+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	CLR  R11
	CLR  R12
	CLR  R13
	CLR  R14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
	CBI  0x8,2
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
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
