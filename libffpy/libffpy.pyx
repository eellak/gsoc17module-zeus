cimport libffpy

from libcpp.string cimport string

cdef class BigNum:
    cdef Fr[curve] *_thisptr

    def __cinit__(self, num=None, init=True):
        if init:
            if num is not None and (isinstance(num, int) or isinstance(num, long)):
                self._thisptr = new Fr[curve](<long long>num)
            else:
                self._thisptr = new Fr[curve](Fr_get_random())

    def __dealloc__(self):
        self.free()

    def free(self):
        if self._thisptr != NULL:
            del self._thisptr

    @staticmethod
    def getOrder():
        cdef Fr[curve] *newptr
        cdef BigNum res = BigNum(init=False)

        newptr = new Fr[curve](get_order())
        res.setElem(newptr)

        return res

    cdef setElem(self, Fr[curve] *b):
        self.free()
        self._thisptr = b

    cdef Fr[curve] *getElemRef(self):
        return self._thisptr

    cdef BigNum createElem(self, Fr[curve]* b):
        cdef BigNum bg = BigNum(init=False)
        bg.setElem(b)
        return bg

    cpdef BigNum add(self, BigNum other):
        cdef Fr[curve] *newptr
        newptr = new Fr[curve](self.getElemRef()[0] + other.getElemRef()[0])
        return self.createElem(newptr)

    cpdef BigNum addInt(self, long long other):
        cdef Fr[curve] *newptr
        newptr = new Fr[curve](self.getElemRef()[0] + other)
        return self.createElem(newptr)

    cpdef BigNum subInt(self, long long other, neg=False):
        cdef Fr[curve] *newptr
        if neg:
            newptr = new Fr[curve](-self.getElemRef()[0] + other)
        else:
            newptr = new Fr[curve](self.getElemRef()[0] - other)

        return self.createElem(newptr)

    cpdef BigNum sub(self, BigNum other):
        cdef Fr[curve] *newptr
        newptr = new Fr[curve](self.getElemRef()[0] - other.getElemRef()[0])
        return self.createElem(newptr)

    cpdef eq(self, BigNum other):
        return self.getElemRef()[0] == other.getElemRef()[0]

    cpdef BigNum pow(self, unsigned long p):
        cdef Fr[curve] *newptr
        newptr = new Fr[curve](self.getElemRef()[0] ^ p)
        return self.createElem(newptr)

    cpdef BigNum mod_inverse(self):
        cdef Fr[curve] *newptr
        newptr = new Fr[curve](self.getElemRef()[0].inverse())
        return self.createElem(newptr)

    cpdef BigNum random(self, nonzero=False, nonorder=False):
        cdef Fr[curve] *newptr
        if nonzero:
            newptr = new Fr[curve](Fr_get_random_nonzero())
        elif nonorder:
            newptr = new Fr[curve](Fr_get_random_nonorder())
        else:
            newptr = new Fr[curve](Fr_get_random())
        return self.createElem(newptr)

    def __add__(x, y):
        cdef BigNum bgleft, bgright
        cdef long long intright

        if not (isinstance(x, BigNum) or isinstance(y, BigNum)):
            return NotImplemented

        if isinstance(x, BigNum):
            if isinstance(y, BigNum):
                bgleft = <BigNum>x
                bgright = <BigNum>y
                return bgleft.add(bgright)
            elif isinstance(y, int) or isinstance(y, long):
                bgleft = <BigNum>x
                intright = <long long>y
                return bgleft.addInt(intright)
            else:
                return NotImplemented

        # y is bignum
        if isinstance(x, int) or isinstance(x, long):
            bgleft = <BigNum>y
            intright = <long long>x
            return bgleft.addInt(intright)

        return NotImplemented


    def __sub__(x, y):
        cdef BigNum bgleft, bgright
        cdef long long intright

        if not (isinstance(x, BigNum) or isinstance(y, BigNum)):
            return NotImplemented

        if isinstance(x, BigNum):
            if isinstance(y, BigNum):
                bgleft = <BigNum>x
                bgright = <BigNum>y
                return bgleft.sub(bgright)
            elif isinstance(y, int) or isinstance(y, long):
                bgleft = <BigNum>x
                intright = <long long>y
                return bgleft.subInt(intright)
            else:
                return NotImplemented

        # y is bignum
        if isinstance(x, int) or isinstance(x, long):
            bgleft = <BigNum>y
            intright = <long long>x
            return bgleft.subInt(intright, neg=True)

        return NotImplemented

    cpdef BigNum mul(self, BigNum other):
        cdef Fr[curve] *newptr
        newptr = new Fr[curve](self.getElemRef()[0] * other.getElemRef()[0])
        return self.createElem(newptr)

    cpdef BigNum mulInt(self, long long other):
        cdef Fr[curve] *newptr
        newptr = new Fr[curve](self.getElemRef()[0] * other)
        return self.createElem(newptr)

    def __mul__(x, y):
        cdef BigNum left, right
        cdef long long intright
        if not (isinstance(x, BigNum) or isinstance(y, BigNum)):
            return NotImplemented

        if isinstance(x, BigNum):
            left = <BigNum>x
            if isinstance(y, BigNum):
                right = <BigNum>y
                return left.mul(right)

            if isinstance(y, int) or isinstance(y, long):
                intright = <long long>y
                return left.mulInt(intright)

        left = <BigNum>y
        if isinstance(x, int):
            intright = <long long>x
            return left.mulInt(intright)

        return NotImplemented


    def __pow__(x, y, z):
        cdef BigNum bg
        cdef unsigned long p
        if not isinstance(x, BigNum):
            return NotImplemented

        if not (isinstance(y, int) or isinstance(y, long)):
            return NotImplemented

        bg = <BigNum>x
        p = <unsigned long>y

        return bg.pow(p)

    def __richcmp__(x, y, int op):
        cdef BigNum left, right

        if op != 2:
            # not ==
            return NotImplemented

        if not (isinstance(x, BigNum) and isinstance(y, BigNum)):
            return NotImplemented

        left = <BigNum>x
        right = <BigNum>y

        return left.eq(right)

    def __neg__(self):
        cdef Fr[curve] *newptr
        newptr = new Fr[curve](-self.getElemRef()[0])
        return self.createElem(newptr)

    cpdef pyprint(self):
        self.getElemRef()[0].cprint()


cdef class G1Py:
    cdef G1[curve] *_thisptr
    cdef size_t g1_exp_count
    cdef size_t g1_window_size
    cdef window_table[G1[curve]] *g1_table

    def __cinit__(self, init=True):
        if init:
            self._thisptr = new G1[curve](get_g1_gen())

    def __dealloc__(self):
        self.free()
        if self.g1_table != NULL:
            del self.g1_table

    def initWindowTable(self, int n):
        self.g1_exp_count = 4 * n + 7;
        self.g1_window_size = get_g1_exp_window_size(self.g1_exp_count)
        self.g1_table = new window_table[G1[curve]](get_g1_window_table(self.g1_window_size, self.getElemRef()[0]))

    @staticmethod
    def inf():
        cdef G1[curve] *newptr
        cdef G1Py g = G1Py(init=False)
        newptr = new G1[curve](get_g1_zero())
        g.setElem(newptr)
        return g

    def free(self):
        if self._thisptr != NULL:
            del self._thisptr

    cdef setElem(self, G1[curve] *g):
        self.free()
        self._thisptr = g

    cdef G1[curve] *getElemRef(self):
        return self._thisptr

    cdef G1Py createElem(self, G1[curve] *g):
        cdef G1Py g1 = G1Py(init=False)
        g1.setElem(g)
        return g1

    cpdef G1Py mul(self, BigNum bgpy):
        cdef G1[curve] *newptr

        cdef Fr[curve] bg = bgpy.getElemRef()[0]
        cdef G1Py elem
        if self.g1_table != NULL:
            newptr = new G1[curve](g1_mul(self.g1_window_size, self.g1_table, bg))
        else:
            newptr = new G1[curve](bg * self.getElemRef()[0])

        return self.createElem(newptr)


    cpdef G1Py add(self, G1Py other):
        cdef G1[curve] *newptr
        newptr = new G1[curve](self.getElemRef()[0] + other.getElemRef()[0])
        return self.createElem(newptr)

    cpdef G1Py sub(self, G1Py other):
        cdef G1[curve] *newptr
        newptr = new G1[curve](self.getElemRef()[0] - other.getElemRef()[0])
        return self.createElem(newptr)

    cpdef eq(self, G1Py other):
        return self.getElemRef()[0] == other.getElemRef()[0]

    def __mul__(x, y):
        cdef G1Py g1
        cdef BigNum bg
        cdef Fr[curve] *fr

        if not (isinstance(x, G1Py) or isinstance(y, G1Py)):
            return NotImplemented

        if isinstance(x, G1Py):
            g1 = <G1Py>x
            if isinstance(y, BigNum):
                bg = <BigNum>y
            elif isinstance(y, int) or isinstance(y, long):
                bg = BigNum(<long long>y)
            else:
                return NotImplemented
        else:
            g1 = <G1Py>y
            if isinstance(x, BigNum):
                bg = <BigNum>x
            elif isinstance(x, int) or isinstance(x, long):
                bg = BigNum(<long long>x)
            else:
                return NotImplemented

        return g1.mul(bg)

    def __hash__(self):
        cdef G1[curve] *elem = new G1[curve](self.getElemRef()[0])

        elem[0].to_affine_coordinates()

        cdef string mystr = elem[0].coord[0].toString(10) + \
            elem[0].coord[1].toString(10) + \
            elem[0].coord[2].toString(10)

        return hash(mystr)

    def __add__(x, y):
        cdef G1Py left, right

        if not (isinstance(x, G1Py) and isinstance(y, G1Py)):
            return NotImplemented

        left = <G1Py>x
        right = <G1Py>y

        return left.add(right)

    def __sub__(x, y):
        cdef G1Py left, right

        if not (isinstance(x, G1Py) and isinstance(y, G1Py)):
            return NotImplemented

        left = <G1Py>x
        right = <G1Py>y

        return left.sub(right)

    def __richcmp__(x, y, int op):
        cdef G1Py left, right

        if op != 2:
            # not ==
            return NotImplemented

        if not (isinstance(x, G1Py) and isinstance(y, G1Py)):
            return NotImplemented

        left = <G1Py>x
        right = <G1Py>y

        return left.eq(right)

    cpdef pyprint(self):
        self.getElemRef()[0].cprint()


cdef class G2Py:
    cdef G2[curve] *_thisptr
    cdef size_t g2_exp_count
    cdef size_t g2_window_size
    cdef window_table[G2[curve]] *g2_table

    def __cinit__(self, init=True):
        if init:
            self._thisptr = new G2[curve](get_g2_gen())

    def __dealloc__(self):
        self.free()
        if self.g2_table != NULL:
            del self.g2_table

    def initWindowTable(self, int n):
        self.g2_exp_count = n + 6
        self.g2_window_size = get_g2_exp_window_size(self.g2_exp_count)
        self.g2_table = new window_table[G2[curve]](get_g2_window_table(self.g2_window_size, self.getElemRef()[0]))

    @staticmethod
    def inf():
        cdef G2[curve] *newptr
        cdef G2Py g = G2Py(init=False)
        newptr = new G2[curve](get_g2_zero())
        g.setElem(newptr)
        return g

    def free(self):
        if self._thisptr != NULL:
            del self._thisptr

    cdef setElem(self, G2[curve] *g):
        self.free()
        self._thisptr = g

    cdef G2[curve] *getElemRef(self):
        return self._thisptr

    cdef createElem(self, G2[curve] *g):
        cdef G2Py g2 = G2Py(init=False)
        g2.setElem(g)
        return g2

    cpdef G2Py mul(self, BigNum bgpy):
        cdef G2[curve] *newptr
        cdef Fr[curve] bg = bgpy.getElemRef()[0]

        if self.g2_table != NULL:
            newptr = new G2[curve](g2_mul(self.g2_window_size, self.g2_table, bg))
        else:
            newptr = new G2[curve](bg * self.getElemRef()[0])

        return self.createElem(newptr)

    cpdef G2Py add(self, G2Py other):
        cdef G2[curve] *newptr
        newptr = new G2[curve](self.getElemRef()[0] + other.getElemRef()[0])
        return self.createElem(newptr)

    cpdef G2Py sub(self, G2Py other):
        cdef G2[curve] *newptr
        newptr = new G2[curve](self.getElemRef()[0] - other.getElemRef()[0])
        return self.createElem(newptr)

    cpdef eq(self, G2Py other):
        return self.getElemRef()[0] == other.getElemRef()[0]

    def __mul__(x, y):
        cdef G2Py g2
        cdef BigNum bg
        cdef Fr[curve] *fr

        if not (isinstance(x, G2Py) or isinstance(y, G2Py)):
            return NotImplemented

        if isinstance(x, G2Py):
            if isinstance(y, BigNum):
                bg = <BigNum>y
            elif isinstance(y, int):
                fr = new Fr[curve](<int>y)
                bg = BigNum(init=False)
                bg.setElem(fr)
            else:
                return NotImplemented
            g2 = <G2Py>x
        elif isinstance(x, BigNum):
            g2 = <G2Py>y
            bg = <BigNum>x
        elif isinstance(x, int):
            g2 = <G2Py>y
            fr = new Fr[curve](<int>x)
            bg = BigNum(init=False)
            bg.setElem(fr)
        else:
            return NotImplemented

        return g2.mul(bg)

    def __hash__(self):
        cdef G2[curve] *elem = new G2[curve](self.getElemRef()[0])

        elem[0].to_affine_coordinates()

        cdef string mystr = elem[0].coord[0].toString(10) + \
            elem[0].coord[1].toString(10) + \
            elem[0].coord[2].toString(10)

        return hash(mystr)

    def __add__(x, y):
        cdef G2Py left, right

        if not (isinstance(x, G2Py) and isinstance(y, G2Py)):
            return NotImplemented

        left = <G2Py>x
        right = <G2Py>y

        return left.add(right)

    def __sub__(x, y):
        cdef G2Py left, right

        if not (isinstance(x, G2Py) and isinstance(y, G2Py)):
            return NotImplemented

        left = <G2Py>x
        right = <G2Py>y

        return left.sub(right)

    def __richcmp__(x, y, op):
        cdef G2Py left, right

        if op != 2:
            # not ==
            return NotImplemented

        if not (isinstance(x, G2Py) and isinstance(y, G2Py)):
            return NotImplemented

        left = <G2Py>x
        right = <G2Py>y

        return left.eq(right)

    cpdef pyprint(self):
        self.getElemRef()[0].cprint()


cdef class GTPy:
    cdef GT[curve] *_thisptr

    def __cinit__(self, init=True):
        if init:
            self._thisptr = new GT[curve]()

    def __dealloc__(self):
        self.free()

    def free(self):
        if self._thisptr != NULL:
            del self._thisptr

    def __mul__(x, y):
        cdef GTPy left, right

        if not (isinstance(x, GTPy) and isinstance(y, GTPy)):
            return NotImplemented

        left = <GTPy>x
        right = <GTPy>y

        return left.mul(right)

    def __pow__(x, y, z):
        cdef GTPy gt
        cdef BigNum bg

        if not (isinstance(x, GTPy) and isinstance(y, BigNum)):
            return NotImplemented

        gt = <GTPy>x
        bg = <BigNum>y

        return gt.pow(bg)

    def __richcmp__(x, y, op):
        cdef GTPy left, right
        if op != 2 or not(isinstance(x, GTPy) and isinstance(y, GTPy)):
            return NotImplemented

        left = <GTPy>x
        right = <GTPy>y

        return left.eq(right)

    cpdef GTPy inv(self):
        cdef GT[curve] *newptr
        newptr = new GT[curve](self.getElemRef()[0].unitary_inverse())
        return self.createElem(newptr)

    cdef GT[curve]* getElemRef(self):
        return self._thisptr

    cdef setElem(self, GT[curve] *g):
        self.free()
        self._thisptr = g

    cdef GTPy createElem(self, GT[curve] *g):
        cdef GTPy gt = GTPy(init=False)
        gt.setElem(g)
        return gt

    cpdef GTPy mul(self, GTPy other):
        cdef GT[curve] *newptr
        newptr = new GT[curve](self.getElemRef()[0] * other.getElemRef()[0])
        return self.createElem(newptr)

    cpdef GTPy pow(self, BigNum bg):
        cdef GT[curve] *newptr
        cdef Fr[curve] fr = bg.getElemRef()[0]
        newptr = new GT[curve](self.getElemRef()[0] ^ fr)
        return self.createElem(newptr)

    cpdef bool eq(self, GTPy other):
        return self.getElemRef()[0] == other.getElemRef()[0]

    @staticmethod
    def one():
        cdef GTPy gt = GTPy(init=False)
        cdef GT[curve] *newptr
        newptr = new GT[curve](get_gt_one())
        gt.setElem(newptr)
        return gt

    @staticmethod
    def pair(G1Py g1, G2Py g2):
        cdef GTPy gt = GTPy(init=False)
        cdef GT[curve] *newptr
        newptr = new GT[curve](reduced_pairing(g1.getElemRef()[0], g2.getElemRef()[0]))
        gt.setElem(newptr)
        return gt

    cpdef pyprint(self):
        self.getElemRef()[0].cprint()


cdef class LibffPy:
    cdef G1Py g1
    cdef G2Py g2

    def __init__(self, int n):
        init_public_params()
        self.g1 = G1Py()
        self.g2 = G2Py()

        self.g1.initWindowTable(n)
        self.g2.initWindowTable(n)

    def order(self):
        return BigNum.getOrder()

    def gen1(self):
        return self.g1

    def gen2(self):
        return self.g2

    def pair(self, G1Py g1, G2Py g2):
        gt = GTPy.pair(g1, g2)
        return gt
