; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		bload.asm
;		Purpose:	BLOAD command (load binary)
;		Created:	2nd January 2023
;		Reviewed: 	No
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;									LOAD a Binary File
;
; ************************************************************************************************

		.section code

Command_BLoad: ;; [BLOAD]
		ldx 	#0
		jsr 	EvaluateString 				; file name to load
		jsr 	CheckComma 					; consume comma
		inx 							
		jsr 	EvaluateInteger 			; load address (full physical address)
		.debug
		phy
		;
		;		Try to open the file.
		;
		lda 	NSMantissa0					; file name -> XA
		ldx 	NSMantissa1
;		jsr 	KNLOpenFileRead 			; open file for reading
;		bcs 	CLErrorHandler 				; error, so fail.
;		sta 	CurrentFileStream 			; save the reading stream.
		;
		;		Open memory for access
		;
		ldx 	#1 							; address is in slot # 1
		jsr 	BLOpenPhysicalMemory 		; open for access.

		ldy 	BLYOffset
		ldx 	#0 							; write 0 to 16 out
_BLTest:
		txa
		ora 	#$80
		sta 	(zTemp2),y
		iny
		bne 	_BLNoAdjust
		jsr 	BLAdvancePhysicalMemory
_BLNoAdjust:
		inx
		cpx 	#16
		bne 	_BLTest

		jsr 	BLClosePhysicalMemory 		; close the access.
		lda 	CurrentFileStream 			; close the file
		jsr 	KNLCloseFile
		ply
		rts
		;
		;		Close file and handle error
		;
CBLCloseError:
		pha
		jsr 	BLClosePhysicalMemory 	
		lda 	CurrentFileStream
		jsr 	KNLCloseFile
		pla
		;
		;		Handle error, file never opened, file handling stuff.
		;
CBLErrorHandler:
		jmp 	CLErrorHandler

; ************************************************************************************************
;
;							Open page read/write at Mantissa,x
;
; ************************************************************************************************

BLAccessPage = 3 							; page to use for actual memory.

BLOpenPhysicalMemory:
		lda 	BLAccessPage+8 				; save current mapping
		sta 	BLNormalMapping

		lda 	NSMantissa0,x 				; copy address, 13 bit adjusted for page -> (zTemp2),BLYOffset
		sta 	BLYOffset 					; zTemp2 0 is *always* zero.
		stz 	zTemp2
		lda 	NSMantissa1,x
		and 	#$1F
		ora 	#BLAccessPage << 5
		sta 	zTemp2+1

		lda 	NSMantissa2,x 				; shift M2:M1 right 3 times to give page # required
		asl 	NSMantissa1,x
		rol 	a
		asl 	NSMantissa1,x
		rol 	a
		asl 	NSMantissa1,x
		rol 	a
		sta 	BLAccessPage+8 				; access that page
		rts

; ************************************************************************************************
;
;										Close opened page.
;
; ************************************************************************************************

BLClosePhysicalMemory:
		lda 	BLNormalMapping
		sta 	BLAccessPage+8
		rts

; ************************************************************************************************
;
;					Advance current address (when Y index ticks over to zero)
;
; ************************************************************************************************

BLAdvancePhysicalMemory:
		pha
		inc		zTemp2+1 					; bump MSB
		lda 	zTemp2+1
		cmp 	#(BLAccessPage+1) << 5 		; reached next page ?
		bne 	_BLAPMExit 					; (e.g. end of the mapped page.)

		inc 	BLAccessPage+8 				; next physical page
		lda 	#BLAccessPage << 5 			; page back to start of transfer page
		sta 	zTemp2+1

_BLAPMExit:
		pla
		rts

		.send code

		.section storage
BLNormalMapping:							; page the access page is normally mapped to.
		.fill 	1
BLYOffset: 									; position in zTemp2 page.
		.fill 	1
		.send storage

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
