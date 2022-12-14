; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		asc.asm
;		Purpose:	ASCII value of string
;		Created:	29th September 2022
;		Reviewed: 	27th November 2022
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
; 									Asc (String)
;
; ************************************************************************************************

AscUnary: ;; [asc(]	
		plx 								; restore stack pos
		jsr 	EvaluateString 				; get a string
		lda 	(zTemp0)					; get/return first character
		jsr 	NSMSetByte 					; ASC("") will return zero.
		jsr 	CheckRightBracket
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
