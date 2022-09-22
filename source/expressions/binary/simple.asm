; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		simple.asm
;		Purpose:	Simple binary operations
;		Created:	21st September 2022
;		Reviewed: 	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;									Macro to simplify simple handlers
;
; ************************************************************************************************

simple32 .macro
		lda		NSMantissa0,x
		\1 		NSMantissa0+1,x 	
		sta 	NSMantissa0,x
		lda		NSMantissa1,x
		\1 		NSMantissa1+1,x 	
		sta 	NSMantissa1,x
		lda		NSMantissa2,x
		\1 		NSMantissa2+1,x 	
		sta 	NSMantissa2,x
		lda		NSMantissa3,x
		\1 		NSMantissa3+1,x 	
		sta 	NSMantissa3,x
		.endm

; ************************************************************************************************
;
;									Simple Binary Operators
;
; ************************************************************************************************

AddInteger: 	;; [+]
		plx
		.dispatcher NotDoneError,NotDoneError
AddTopTwoStack:		
		clc
		.simple32 adc
		rts

SubInteger: 	;; [-]
		plx
		.dispatcher NotDoneError,NotDoneError
SubTopTwoStack:		
		sec
		.simple32 sbc
		rts

AndInteger: 	;; [&]
		plx
		.dispatchintegeronly
		.simple32 and
		rts

OraInteger: 	;; [|]
		plx
		.dispatchintegeronly
		.simple32 ora
		rts

EorInteger: 	;; [^]
		plx
		.dispatchintegeronly
		.simple32 eor
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