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
include ..\documents\common.make
else
include ../documents/common.make
endif
#
#		Current version.
#
VERSION = 29

#	System 0 = F256
SYSTEM = 0 						
BINDIR = $(ROOTDIR)bin$(S)
ASMOPTS = -q -b -Wall -c -C -D HARDWARE="$(SYSTEM)" -L output$(S)basic.lst -l output$(S)basic.lbl -Wall 
APPNAME = build$(S)basic.rom
SCRIPTDIR = scripts$(S)
EMULATOR = $(BINDIR)jr256$(APPSTEM)
LANGUAGE = en

EMU_REPO= ..$(S)..$(S)junior-emulator
TNY_REPO= ..$(S)..$(S)junior-tinykernel
LDR_FILE= ..$(S)..$(S)FoenixMgr
KRN_REPO= ..$(S)..$(S)F256_Jr_Kernel_DOS

MODULES= +hardware +graphics +tokeniser +sound

START = $(EMULATOR) $(APPNAME)@b storage$(S)load.dat@x $(BINDIR)graphics.bin@s boot@8000

all :  basic
#
#		Run on emulator with/without autorun
#	
run : basic	
	python scripts$(S)checkload.py
	$(START)

testbasic:prelim
	64tass -D AUTORUN=1 $(AADDRESSES) $(ASMOPTS) _basic.asm -o $(APPNAME)
	$(CCOPY) $(APPNAME) $(BINDIR)
#
#		Switch to Flash-Boot or RAM-Boot
#	
flashboot:
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --boot flash 
ramboot:	
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --boot ram
#
#		Build & update Kernel & api.asm
#
updatekernel:
	cd $(KRN_REPO) && git reset --hard
	cd $(KRN_REPO) && git pull
	make -B -C $(KRN_REPO)
	$(CCOPY) $(KRN_REPO)$(S)kernel$(S)*.bin build
	$(CCOPY) $(KRN_REPO)$(S)kernel$(S)api.asm  common$(S)api

#
#		Build RAM based kernel / ROM combo and boot.
#
ramkernel: ramboot
	cat build$(S)3f.bin build$(S)3e.bin build$(S)01.bin  >build$(S)kernel.ram 
	cat build$(S)kernel.ram build$(S)basic.rom >build$(S)ramkernel.bin
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary build$(S)ramkernel.bin --address E000
#
#		Run on real hardware (Flash RAM operation)
#	
rgo : ramkernel putcode
#
#		Run on real hardware (RAM operation)
#
go : ramboot
	python scripts$(S)checkload.py
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary $(BINDIR)$(S)lockout.rom --address $(LLOCKOUT)
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary $(BINDIR)$(S)graphics.bin --address $(LSPRITES)
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary storage$(S)load.dat --address $(LSOURCE)
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary $(APPNAME) --address $(LBASIC)
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary $(BINDIR)$(S)monitor.rom --address $(LMONITOR)
#
#		Store Basic code in upper RAM
#
putcode:
	python scripts$(S)checkload.py
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary storage$(S)load.dat --address $(LSOURCE)
#
#		Run on real hardware (Flash Operation)
#
fupload: flashboot basic
	make -C build 

fgo: flashboot
	python scripts$(S)checkload.py
	python $(BINDIR)fnxmgr.zip --port $(TTYPORT) --binary storage$(S)load.dat --address 28000
#
#		Create sprites
#
sprites:
	make -B -C ..$(S)spritebuild
#
#		Build and download tools
#
tools: emu monitor fnxmgr

shim:
	64tass -q -b _shim.asm -o shim.bin
	
fnxmgr:	
	$(CDEL) temp$(S)*.*
	$(CCOPY) $(LDR_FILE)$(S)FoenixMgr$(S)*.* temp
	$(CCOPY) temp$(S)fnxmgr.py temp$(S)__main__.py 
	zip temp$(S)fnxmgr.zip -j temp$(S)__main__.py temp$(S)constants.py temp$(S)foenix_config.py temp$(S)intelhex.py \
			temp$(S)pgx.py temp$(S)srec.py temp$(S)foenix.py temp$(S)pgz.py temp$(S)wdc.py
	$(CCOPY) temp$(S)fnxmgr.zip $(BINDIR) 

monitor:
	make -B -C $(TNY_REPO)
	$(CCOPY) $(TNY_REPO)$(S)monitor.rom $(BINDIR)
	$(CCOPY) $(TNY_REPO)$(S)lockout.rom $(BINDIR)

emu:
	make -B -C $(EMU_REPO)
	$(CCOPY) $(EMU_REPO)$(S)bin$(S)jr256$(APPSTEM) $(BINDIR)
#
#		Show various things
#
stack:
	python $(SCRIPTDIR)showstack.py
	
strings:
	python $(SCRIPTDIR)showstring.py

vars:
	python $(SCRIPTDIR)showvar.py
#
#		Builds with/without autorun
#	
basic : prelim
	64tass -D AUTORUN=0 $(AADDRESSES) $(ASMOPTS) _basic.asm -o $(APPNAME)
	$(CCOPY) $(APPNAME) $(BINDIR)

autorun:
	python scripts$(S)checkload.py
	$(START)
#
#		Scripts run in advance generating tables etc.
#	
prelim:
	make -B -C ..$(S)modules
	python $(SCRIPTDIR)errors.py $(LANGUAGE)
	python $(SCRIPTDIR)opcodes.py >common$(S)generated$(S)asmcore.asm
	python $(SCRIPTDIR)makebuild.py $(MODULES)
	python $(SCRIPTDIR)tokens.py
	python $(SCRIPTDIR)constants.py
	python $(SCRIPTDIR)timestamp.py $(VERSION)
#
#		Create a working release.
#
release:
	make -C . testbasic
	$(CCOPY) $(APPNAME) release$(S)$(S)roms$(S)basic_autoload.rom
	make -C . basic
	$(CCOPY) $(APPNAME) release$(S)roms$(S)basic.rom

	make -C build build
	$(CCOPY) build$(S)*.bin release
	$(CCOPY) build$(S)bulk.csv release

	$(CCOPY) ..$(S)CHANGES release$(S)documents
	$(CCOPY) ..$(S)reference$(S)source$(S)*.pdf release$(S)documents
	$(CCOPY) ..$(S)documents$(S)C256_Foenix_JR_UM_Rev002.pdf release$(S)documents
	$(CCOPY) ..$(S)documents$(S)superbasic.sublime-syntax release$(S)documents

	$(CDEL) release$(S)VERSION*
	echo "" >release$(S)VERSION_${VERSION}

	make -B -C ..$(S)howto
	cp ..$(S)howto$(S)howto*.zip release
	
	$(CDEL) release$(S)superbasic.zip
	zip -r release$(S)superbasic.zip release$(S)*
#
#		Run various tests.
#
test:
	python $(SCRIPTDIR)simpletests.py 

astest:
	python $(SCRIPTDIR)assign.py 	

sastest:
	python $(SCRIPTDIR)assign.py all	

artest:
	python $(SCRIPTDIR)array.py 	
	
benchmark:
	cp ..$(S)documents$(S)benchmarks$(S)bm$(ID).bas storage$(S)load.dat

assembler: 
	python $(SCRIPTDIR)asmtest.py
	64tass -q -b -c common$(S)generated$(S)asmtest.tass -L output$(S)asmtest.lst -o output$(S)asmtest.bin
	$(EMULATOR) $(APPNAME)@b storage$(S)load.dat@x
	python $(SCRIPTDIR)asmcheck.py

lineedit:
	python $(SCRIPTDIR)linetest.py
	64tass -D AUTORUN=1 $(AADDRESSES) $(ASMOPTS) _basic.asm -o $(APPNAME)
	$(START)
	python $(SCRIPTDIR)linecheck.py

paging:
	python $(SCRIPTDIR)checkpaging.py