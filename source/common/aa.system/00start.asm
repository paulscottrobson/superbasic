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
		jsr 	EXTInitialise 				; hardware initialise

		lda 	#0 							; graphics system initialise.
		tax
		tay
		jsr 	GXGraphicDraw

		ldx 	#(Prompt >> 8) 				; prompt
		lda 	#(Prompt & $FF)
		jsr 	PrintStringXA

		jsr 	NewProgram 					; erase current program
		jsr 	BackloadProgram

		.if 	AUTORUN==1 					; run straight off
		jmp 	CommandRun
		.else
		jmp 	WarmStart
		.endif

Prompt:	.text 	12,"*** F256 Junior SuperBASIC ***",13,13
		.text 	"Written by Paul Robson 2022.",13,13
		.include "../generated/timestamp.asm"
		.byte 	13,13,0

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
