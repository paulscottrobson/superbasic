; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		ticktask.asm
;		Purpose:	Tick task handlere
;		Created:	21st November 2022
;		Reviewed: 	No.
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section 	code

; ************************************************************************************************
;
;							Tick Handler - sort of interrupt routine
;
; ************************************************************************************************

TickHandler:
		phy 								; need to preserve Y
		.if 	soundIntegrated==1 			; if F256 sound module
		jsr 	SNDUpdate 					; update sound
		.endif
		ply
		rts

		.send 		code
		
		.section 	storage
LastTick:
		.fill 		1
		.send 		storage

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
