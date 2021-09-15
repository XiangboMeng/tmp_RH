;* PRU1 Firmware for BeagleLogic (customized for RadioHoud V3.0)
;* AD9283 Single channel ADC 
;* Copyright (C) 2020 Arash Ebadi Shahriavr <aebadish@nd.edu>
;*
;* April '23: Modified by Arash Ebadi for supporting the RadioHoud board
;*
;* This modified firmware captures interleaved channels A & B into
;* /dev/beaglelogic
;*
;* This program is free software; you can redistribute it and/or modify
;* it under the terms of the GNU General Public License version 2 as
;* published by the Free Software Foundation.

	.include "beaglelogic-pru-defs.inc"

NOP	.macro
	 ADD R0.b0, R0.b0, R0.b0
	.endm

; Generic delay loop macro
; Also includes a post-finish op
DELAY	.macro Rx, op
	SUB	R0, Rx, 2
	QBEQ	$E?, R0, 0
$M?:	SUB	R0, R0, 1
	QBNE	$M?, R0, 0
$E?:	op
	.endm

	.sect ".text:main"
	.global asm_main
asm_main:
	; Set C28 in this PRU's bank =0x24000
	LDI32  R0, CTPPR_0+0x2000               ; Add 0x2000
	LDI    R1, 0x00000240                   ; C28 = 00_0240_00h = PRU1 CFG Registers
	SBBO   &R1, R0, 0, 4

	; Configure R2 = 0x0000 - ptr to PRU1 RAM
	LDI    R2, 0

	; Enable the cycle counter
	LBCO   &R0, C28, 0, 4
	SET    R0, R0, 3
	SBCO   &R0, C28, 0, 4

	; Load Cycle count reading to registers [LBCO=4 cycles, SBCO=2 cycles]
	LBCO   &R0, C28, 0x0C, 4
	SBCO   &R0, C24, 0, 4

	; Load magic bytes into R2
	LDI32  R0, 0xBEA61E10

	; Wait for PRU0 to load configuration into R14[samplerate] and R15[unit]
	; This will occur from an downcall issued to us by PRU0
	HALT

	; Jump to the appropriate sample loop
	; TODO

	LDI    R31, 27 + 16                     ; Signal VRING1 to kernel driver
	HALT

	; Sample starts here
	; Maintain global bytes transferred counter (8 byte bursts)
	LDI    R29, 0
	LDI    R20.w0, 0xFFFF                ; For masking unused bits
	LDI    R20.w2, 0xFFFF

sampleAD9283:
	; Changed code for AD9283 sampling
	WBC    R31, 11                       ; Wait for falling edge
	WBS    R31, 11                       ; Wait for rising edge
	NOP                                  ; 3 cycles ~15ns delay before readout
	NOP
	MOV    R21.b0, R31.b0                ; Read I0

	WBC    R31, 11
	WBS    R31, 11
	NOP
	
$sampleAD9283$2:
	NOP

	MOV    R21.b1, R31.b0                ; I1
	WBS    R31, 11
	NOP                                  
	NOP

	MOV    R21.b2, R31.b0                ; I2
	WBS    R31, 11
	NOP
	NOP

	MOV    R21.b3, R31.b0                ; I3
	WBS    R31, 11
	NOP
	NOP

	MOV    R22.b0, R31.b0                ; I4
	WBS    R31, 11
	NOP
	NOP

	MOV    R22.b1, R31.b0                ; I5
	WBS    R31, 11
	NOP
	NOP

	MOV    R22.b2, R31.b0                ; I6
	WBS    R31, 11
	NOP
	NOP

	MOV    R22.b3, R31.b0                ; I7
	WBS    R31, 11
	NOP
	NOP

	MOV    R23.b0, R31.b0                ; I8
	WBS    R31, 11
	NOP
	NOP

	MOV    R23.b1, R31.b0                ; I9
	WBS    R31, 11
	NOP
	NOP

	MOV    R23.b2, R31.b0                ; I10
	WBS    R31, 11
	NOP
	NOP

	MOV    R23.b3, R31.b0                ; I11
	WBS    R31, 11
	NOP
	NOP

	MOV    R24.b0, R31.b0                ; I12
	WBS    R31, 11
	NOP
	NOP

	MOV    R24.b1, R31.b0                ; I13
	WBS    R31, 11
	NOP
	NOP

	MOV    R24.b2, R31.b0                ; I14
	WBS    R31, 11
	NOP
	NOP

	MOV    R24.b3, R31.b0                ; I15
	WBS    R31, 11
	NOP
	NOP

	MOV    R25.b0, R31.b0                ; I16
	WBS    R31, 11
	NOP
	NOP

	MOV    R25.b1, R31.b0                ; I17
	WBS    R31, 11
	NOP
	NOP

	MOV    R25.b2, R31.b0                ; I18
	WBS    R31, 11
	NOP
	NOP

	MOV    R25.b3, R31.b0                ; I19
	WBS    R31, 11
	NOP
	NOP

	MOV    R26.b0, R31.b0                ; I20
	WBS    R31, 11
	NOP
	NOP

	MOV    R26.b1, R31.b0                ; I21
	WBS    R31, 11
	NOP
	NOP

	MOV    R26.b2, R31.b0                ; I22
	WBS    R31, 11
	NOP
	NOP

	MOV    R26.b3, R31.b0                ; I23
	WBS    R31, 11
	NOP
	NOP

	MOV    R27.b0, R31.b0                ; I24
	WBS    R31, 11
	NOP
	NOP

	MOV    R27.b1, R31.b0                ; I25
	WBS    R31, 11
	NOP
	NOP

	MOV    R27.b2, R31.b0                ; I26
	WBS    R31, 11
	NOP
	NOP

	MOV    R27.b3, R31.b0                ; I27
	WBS    R31, 11
	NOP
	NOP
	
	MOV    R28.b0, R31.b0                ; I28
	WBS    R31, 11
	NOP
	NOP

	MOV    R28.b1, R31.b0                ; I29
	WBS    R31, 11
	NOP
	NOP

	MOV    R28.b2, R31.b0                ; I30
	WBS    R31, 11
	ADD    R29, R29, 32                  ; Maintain global byte counter
	NOP

	MOV    R28.b3, R31.b0                ; I31
	WBS    R31, 11
	XOUT   10, &R21, 36                  ; Move data across the broadside
	LDI    R31, PRU1_PRU0_INTERRUPT + 16 ; Jab PRU0
	MOV    R21.b0, R31.b0                ; I0 (repeat)
	WBS    R31, 11
	JMP    $sampleAD9283$2

; End-of-firmware
	HALT
