; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		rem.asm
;		Purpose:	Comment command (also can use ')
;		Created:	22nd September 2022
;		Reviewed: 	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

RemCommand: ;; [rem]
		.cget 								; string follows ?
		cmp 	#KWC_STRING
		bne 	_RMExit
		.cskipdatablock 					; if so skip data.
_RMExit:
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
