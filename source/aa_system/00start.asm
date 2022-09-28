; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		00start.asm
;		Purpose:	Start up code.
;		Created:	18th September 2022
;		Reviewed: 	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

Start:	ldx 	#$FF 						; stack reset
		txs	
		;
		jsr 	NewCommand 					; erase current program
		jsr 	BackloadProgram
		jmp 	CommandRun
		
WarmStart:
		lda 	#"W"
		jsr 	$FFD2
halt:	bra 	halt

ErrorHandler:		
		.debug
		jmp 	ErrorHandler

		.align 2
		.include "../generated/vectors.dat"

		.send code

; ************************************************************************************************
;
;									Changes and Updates
;
; ************************************************************************************************
;
;		Date			Notes
;		==== 			=====
;
; ************************************************************************************************
