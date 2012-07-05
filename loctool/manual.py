import sys
def writeToLua(r):
	print 'return {'
	for n in r:
		print '["'+n+'"]="",'
	print '}'

r = []
for line in sys.stdin:
	r.append(line[:-1])

writeToLua(r)