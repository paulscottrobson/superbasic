; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		macros.inc
;		Purpose:	Standard Macros
;		Created:	18th September 2022
;		Reviewed: 	17th November 2022
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;							Insert an Emulator Breakpoint
;
; ************************************************************************************************

debug 		.macro
		.byte 	$DB 						; causes a break in the emulator
		.endm

; ************************************************************************************************
;
;								Set a 2 byte value in memory
;
; ************************************************************************************************

set16 		.macro
		lda 	#((\2) & $FF)
		sta 	0+\1
		lda 	#((\2) >> 8)
		sta 	1+\1
		.endm

; ************************************************************************************************
;
;							Break check, returns NZ set if breaking
;
; ************************************************************************************************
		
breakcheck 	.macro
		lda 	kernel.args.events.pending 	; load pending event count into accumulator
		beq 	_NoEvents					; if zero, skip with Z flag set.
		jsr 	ProcessEvents
_NoEvents:
		.endm		

; ************************************************************************************************
;
;									Changes and Updates
;
; ************************************************************************************************
;
;		Date			Notes
;		==== 			=====
;		02/01/23 		Added break check macro
;
; ************************************************************************************************
