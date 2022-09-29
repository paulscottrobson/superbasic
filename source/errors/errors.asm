; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		errors.asm
;		Purpose:	Handle errors
;		Created:	29th September 2022
;		Reviewed: 	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;								Report error A
;
; ************************************************************************************************

ErrorHandler:		
		tay 								; find the error text
		beq 	_EHEnd
		ldx 	#0
_EHFind:		
		dey 								; found the error text ?
		beq 	_EHFound
_EHFindZero:
		lda 	ErrorText,x 				; find the next error
		inx
		cmp 	#0
		bne 	_EHFindZero
		bra 	_EHFind
_EHFound:
		lda 	ErrorText,x 				; print the message
		jsr 	EXTPrintCharacter
		inx
		lda 	ErrorText,x
		bne 	_EHFound		

		ldy 	#1 							; if line number zero don't print i
		.cget
		bne 	_EHAtMsg
		iny
		.cget
		beq 	_EHCREnd

_EHAtMsg:		
		ldx 	#_AtMsg >> 8 				; print " at "
		lda 	#_AtMsg & $FF
		jsr 	PrintStringXA

		ldy 	#1 							; line number into XA
		.cget
		pha
		iny
		.cget
		tax
		pla
		jsr 	ConvertInt16 				; convert XA to string
		jsr 	PrintStringXA 				; and print it.

_EHCREnd:
		lda 	#13 						; new line
		jsr 	EXTPrintCharacter
_EHEnd:			
		jmp 	WarmStart

_AtMsg:	.text 	" at line ",0

; ************************************************************************************************
;
;								  Print String at XA
;
; ************************************************************************************************

PrintStringXA:
		stx 	zTemp0+1
		sta 	zTemp0
		ldy 	#0
_PSXALoop:
		lda 	(zTemp0),y
		beq 	_PSXAExit
		jsr 	EXTPrintCharacter
		iny
		bra 	_PSXALoop
_PSXAExit:
		rts						
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