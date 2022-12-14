# ************************************************************************************************
# ************************************************************************************************
#
#		Name:		Makefile
#		Purpose:	Main make file
#		Created:	18th September 2022
#		Author:		Paul Robson (paul@robsons.org.uk)
#
# ************************************************************************************************
# ************************************************************************************************

ifeq ($(OS),Windows_NT)
include ..\..\documents\common.make
else
include ../../documents/common.make
endif

BINDIR = ..$(S)..$(S)bin$(S)
EMULATOR = $(BINDIR)jr256$(APPSTEM)
LANGUAGE = en
SOURCE = demo.bas

START = $(EMULATOR) $(BINDIR)basic.rom@b storage$(S)load.dat@x graphics.bin@s
# 3000 is hardcoded in backload.asm

#
#		Extract Graphics, perhaps
#
graphics:
	make -B -C graphics
#
#		Create sprites
#
sprites:
	python $(BINDIR)spritebuild.py sprites.def
#
#		Create autorunning test basic
#
auto:
	make -B -C ..$(S)..$(S)source testbasic
#
#		Build program
#
program:
	python $(BINDIR)basconv.py $(SOURCE) >storage$(S)load.dat
#
#		Run program (if built autorunning BASIC)
#
run: sprites program
	$(START)	
#
#		Run on hardware
#
go: sprites program 
	$(CCOPY) $(BINDIR)foenixmgr.ini .	
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --boot ram
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary $(BINDIR)$(S)lockout.rom --address $(LLOCKOUT)
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary graphics.bin --address $(LSPRITES)
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary storage$(S)load.dat --address $(LSOURCE)
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary $(BINDIR)$(S)basic.rom --address $(LBASIC)
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary $(BINDIR)$(S)monitor.rom --address $(LMONITOR)
#
#		Run on kernel hardware
#
fgo: sprites program 
	$(CCOPY) $(BINDIR)foenixmgr.ini .	
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --boot flash
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary graphics.bin --address $(LSPRITES)
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary storage$(S)load.dat --address $(LSOURCE)
