
def assertArraysEqual(self, A, B, msg, verbose=False):
    "Asserts wether two given arrays are equal."
    try:
        for i in xrange(min(len(A), len(B))):
            a, b = A[i], B[i]
            if verbose:
                print a == b, a, b
            self.assertEqual(a, b)
        self.assertEqual(len(A), len(B))
    except AssertionError as ae:
        self.fail("{}. error: {}".format(msg, ae.message))
