; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		chr.asm
;		Purpose:	Convert number to string
;		Created:	29th September 2022
;		Reviewed: 	27th November 2022
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
; 										CHR$() function
;
; ************************************************************************************************

ChrUnary: ;; [chr$(]	
		plx 								; restore stack pos
		jsr 	Evaluate8BitInteger			; get value (chr$(0) returns an empty string)
		pha
		jsr 	CheckRightBracket
		lda 	#1 							; allocate space for one char
		jsr 	StringTempAllocate
		pla 								; write number to it
		jsr 	StringTempWrite
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
