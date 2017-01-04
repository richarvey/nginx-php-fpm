''' test runner '''

import unittest
import sys

def run_functional_tests():
    ''' Execute Functional Tests '''
    tests = unittest.TestLoader().discover('tests/functional')
    result = unittest.TextTestRunner(verbosity=2).run(tests)
    return result.wasSuccessful()

if __name__ == '__main__':

    print "#" * 70
    print "Test Runner: Functional tests"
    print "#" * 70
    functional_results = run_functional_tests()

    if functional_results:
        sys.exit(0)
    else:
        sys.exit(1)
