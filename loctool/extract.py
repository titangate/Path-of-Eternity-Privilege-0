import os
import glob
 
path = '../'

d = {
'(' : ')',
"'" : "'",
'"' : '"',
}
def process(fn):
	result = []
	headlength = len('LocalizedString')
	f = file(fn)
	for line in f:
		n = line.find('LocalizedString')
		if n!=-1:
			n+=headlength
			start = line[n]
			n+=1
			si = n
			counterpart = d[start]
			while n<len(line) and line[n]!=counterpart: n+=1
			result.append(line[si:n])
	return result

m = []
def scan_dirs(path):
	for infile in glob.glob( os.path.join(path, '*') ):
		if os.path.isdir(infile):
			scan_dirs(infile)
		elif 'lua' == os.path.splitext(infile)[1][1:].strip():
			r = process(infile)
			m[len(m):] = r
	return m

existed = [file("../localization/Simplified Chinese.lua").read()]
#print existed
def writeToLua(r):
	print 'return {'
	for n in r:
		ex = False
		for f in existed:
			if f.find(n)!=-1: 
				ex = True
				break
		if not ex:print '["'+n+'"]="",'
	print '}'
		

writeToLua(set(scan_dirs(path)))