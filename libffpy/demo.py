import sys
import datetime
from libffpy import LibffPy, BigNum

n = int(sys.argv[1])

l = LibffPy(n)
g2 = l.gen2()
g1 = l.gen1()


start = datetime.datetime.now()
bg = [BigNum() for _ in xrange(n - 1)]
end = datetime.datetime.now()
print "BigNum creation ellapsed: %s" % (end - start)


s = reduce((lambda x,y: x + y), bg)

bg.append(bg[0].getOrder() + 1 - s)


start = datetime.datetime.now()
res = [g2 * e for e in bg]
end = datetime.datetime.now()
print "G2 Multiplication ellapsed: %s" % (end - start)

s = reduce((lambda x,y: x+ y), res)
print "Test passed: %s" % (s == g2)

start = datetime.datetime.now()
res = [g1 * e for e in bg]
end = datetime.datetime.now()
print "G1 multiplication ellapsed: %s" % (end - start)
