cimport libffpy

cdef class BigNumPy:
    cdef BigNum *_thisptr

    def __cinit__(self, init=True):
        if init:
            self._thisptr = new BigNum()

    def __dealloc__(self):
        self.free()

    def free(self):
        if self._thisptr != NULL:
            del self._thisptr

    cdef setElem(self, BigNum *b):
        self.free()
        self._thisptr = b

    cdef BigNum *getElemRef(self):
        return self._thisptr

    cdef BigNumPy createElem(self, BigNum* b):
        cdef BigNumPy bg = BigNumPy(init=False)
        bg.setElem(b)
        return bg

    @staticmethod
    def getOrder():
        cdef BigNum *newptr
        cdef BigNumPy res = BigNumPy()

        newptr = get_order()
        res.setElem(newptr)

        return res

    cpdef BigNumPy add(self, BigNumPy other):
        cdef BigNum *newptr
        newptr = self.getElemRef()[0].add(other.getElemRef())
        return self.createElem(newptr)

    cpdef BigNumPy sub(self, BigNumPy other):
        cdef BigNum *newptr
        newptr = self.getElemRef()[0].sub(other.getElemRef())
        return self.createElem(newptr)

    def __add__(x, y):
        cdef BigNumPy left, right

        if not (isinstance(x, BigNumPy) and isinstance(y, BigNumPy)):
            return NotImplemented

        left = <BigNumPy>x
        right = <BigNumPy>y
        return left.add(right)

    def __sub__(x, y):
        cdef BigNumPy left, right

        if not (isinstance(x, BigNumPy) and isinstance(y, BigNumPy)):
            return NotImplemented

        left = <BigNumPy>x
        right = <BigNumPy>y
        return left.sub(right)


cdef class G1Py:
    cdef G1Elem *_thisptr

    def __cinit__(self, init=True):
        if init:
            self._thisptr = new G1Elem()

    def __dealloc__(self):
        self.free()

    def init(self, int n):
        self.getElemRef()[0].init(n)

    def free(self):
        if self._thisptr != NULL:
            del self._thisptr

    cdef setElem(self, G1Elem *g):
        self.free()
        self._thisptr = g

    cdef G1Elem *getElemRef(self):
        return self._thisptr

    cdef G1Py createElem(self, G1Elem *g):
        cdef G1Py g1 = G1Py(init=False)
        g1.setElem(g)
        return g1

    cpdef G1Py mul(self, BigNumPy bgpy):
        cdef G1Elem *newptr
        cdef BigNum *bg = bgpy.getElemRef()

        newptr = self.getElemRef()[0].mul(bg)

        return self.createElem(newptr)

    cpdef G1Py add(self, G1Py other):
        cdef G1Elem *newptr
        newptr = self.getElemRef()[0].add(other.getElemRef())
        return self.createElem(newptr)

    def __mul__(x, y):
        cdef G1Py g1
        cdef BigNumPy bg

        if not (isinstance(x, G1Py) or isinstance(y, G1Py)):
            return NotImplemented

        if isinstance(x, G1Py):
            if not isinstance(y, BigNumPy):
                return NotImplemented
            g1 = <G1Py>x
            bg = <BigNumPy>y
        elif isinstance(x, BigNumPy):
            g1 = <G1Py>y
            bg = <BigNumPy>x

        return g1.mul(bg)

    def __add__(x, y):
        cdef G1Py left, right

        if not (isinstance(x, G1Py) and isinstance(y, G1Py)):
            return NotImplemented

        left = <G1Py>x
        right = <G1Py>y

        return left.add(right)


cdef class G2Py:
    cdef G2Elem *_thisptr

    def __cinit__(self, init=True):
        if init:
            self._thisptr = new G2Elem()

    def __dealloc__(self):
        self.free()

    def init(self, int n):
        self.getElemRef()[0].init(n)

    def free(self):
        if self._thisptr != NULL:
            del self._thisptr

    cdef setElem(self, G2Elem *g):
        self.free()
        self._thisptr = g

    cdef G2Elem *getElemRef(self):
        return self._thisptr

    cdef createElem(self, G2Elem *g):
        cdef G2Py g2 = G2Py(init=False)
        g2.setElem(g)
        return g2

    cpdef G2Py mul(self, BigNumPy bgpy):
        cdef G2Elem *newptr
        cdef BigNum *bg = bgpy.getElemRef()
        newptr = self.getElemRef()[0].mul(bg)
        return self.createElem(newptr)

    cpdef G2Py add(self, G2Py other):
        cdef G2Elem *newptr
        newptr = self.getElemRef()[0].add(other.getElemRef())
        return self.createElem(newptr)

    cpdef eq(self, G2Py other):
        return self.getElemRef()[0].eq(other.getElemRef())

    def __mul__(x, y):
        cdef G2Py g2
        cdef BigNumPy bg
        if not (isinstance(x, G2Py) or isinstance(y, G2Py)):
            return NotImplemented

        if isinstance(x, G2Py):
            if not isinstance(y, BigNumPy):
                return NotImplemented
            g2 = <G2Py>x
            bg = <BigNumPy>y
        elif isinstance(x, BigNumPy):
            g2 = <G2Py>y
            bg = <BigNumPy>x

        return g2.mul(bg)

    def __add__(x, y):
        cdef G2Py left, right

        if not (isinstance(x, G2Py) and isinstance(y, G2Py)):
            return NotImplemented

        left = <G2Py>x
        right = <G2Py>y

        return left.add(right)

    def __richcmp__(x, y, cmp):
        cdef G2Py left, right

        if cmp != 2:
            # not ==
            return NotImplemented

        if not (isinstance(x, G2Py) and isinstance(y, G2Py)):
            return NotImplemented

        left = <G2Py>x
        right = <G2Py>y

        return left.eq(right)


cdef class GTPy:
    cdef GTElem *_thisptr

    def __cinit__(self, init=True):
        if init:
            self._thisptr = new GTElem()

    def __dealloc__(self):
        self.free()

    def free(self):
        if self._thisptr != NULL:
            del self._thisptr

    cdef GTElem* getElemRef(self):
        return self._thisptr

    cdef setElem(self, GTElem *g):
        self.free()
        self._thisptr = g

    def pair(self, G1Py g1, G2Py g2):
        cdef GTElem *newptr;
        newptr = self.getElemRef()[0].pair(g1.getElemRef(), g2.getElemRef())
        self.setElem(newptr)


cdef class LibffPy:
    cdef G1Py g1
    cdef G2Py g2

    def __init__(self, int n):
        init_public_params()
        self.g1 = G1Py()
        self.g2 = G2Py()

        self.g1.init(n)
        self.g2.init(n)

    def order(self):
        return BigNumPy.getOrder()

    def gen1(self):
        return self.g1

    def gen2(self):
        return self.g2

    def pair(self, G1Py g1, G2Py g2):
        gt = GTPy(init=False)
        gt.pair(g1, g2)
        return gt
