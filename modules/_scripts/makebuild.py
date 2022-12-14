# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		makebuild.py
#		Purpose :	Build the build file from asm/inc (Graphics version)
#		Date :		11th October 2022
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,re

sourceFiles = []																			# source files in order
includeFiles = []

for root,dirs,files in os.walk(sys.argv[1]): 												# scan for directories
	for f in files: 																		# look for files that are .asm
		fName = root + os.sep + f
		if fName.endswith(".asm"):
			sourceFiles.append(fName)
		if fName.endswith(".inc"):
			includeFiles.append(fName)
includeFiles.sort()			
sourceFiles.sort()

h = sys.stdout
h.write(";\n;\tThis file is automatically generated\n;\n")  							# output the build file
h.write("\n{0}Integrated=1\n\n".format(sys.argv[1]))
for f in includeFiles+sourceFiles:
	 for s in open(f).readlines():
	 	h.write("{0}\n".format(s.rstrip()))
h.close()
