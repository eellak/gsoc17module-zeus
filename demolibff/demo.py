import sys
import datetime
from g2_wrapper_py import LibffPy, BigNumPy

l = LibffPy(10)
g2 = l.gen2()
g1 = l.gen1()

n = int(sys.argv[1])


start = datetime.datetime.now()
bg = [BigNumPy() for _ in xrange(n - 1)]
end = datetime.datetime.now()
print "BigNumPy creation ellapsed: %s" % (end - start)


s = reduce((lambda x,y: x + y), bg)

bg.append(bg[0].getOrder() - s)


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
