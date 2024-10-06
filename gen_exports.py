#!/bin/env python3

import sys

_, inpath, outpath = sys.argv

with open(inpath, "r") as infile:
	data = infile.read()

# search for magic string
exportstart = data.find("<APP_LIBRARY_EXPORTS>")

out = []
if exportstart != -1:
	# seek to next line
	exportstart = data.find("\n", start=exportstart)
	if exportstart != -1:
		# iterate through the file's remaining lines
		# printing lines starting with "// ",
		# exiting if a line doesn't and its length is greater than 0
		for line in data[exportstart:].split("\n"):
			line = line.strip(" \t")
			if line.startswith("// "):
				if " " in line:
					line = line.split(" ", maxsplit=1)[0]
				out.append("export "+line)
			elif len(line) > 0:
				break

with open(outpath, "w") as outfile:
	outfile.write("\n".join(out))
