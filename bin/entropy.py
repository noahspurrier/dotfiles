#!/usr/bin/env python

'''
SYNOPSIS

    entropy.py [--blocksize=N] [-h,--help] [-v,--verbose] [--version]

DESCRIPTION

    This script calculates the Shannon entropy over data read from stdin.
    Entropy is calculated for blocks of data. The entropy is printed for each
    block. The default blocksize is 1024. Setting the blocksize to 0 will read
    the stream until end of file and calculate the entropy for the entire
    dataset.

    This docstring will be printed by the script if there is an error
    or if the user requests help (-h or --help).

EXAMPLES

    The following are some examples of how to use this script.
        $ dd if=/dev/urandom bs=1024 count=10 | ./entropy.py --blocksize=0
        10+0 records in
        10+0 records out
        10240 bytes (10 kB) copied, 0.00236719 s, 4.3 MB/s
        7.97868699469

        $ dd if=/dev/urandom bs=1024 count=10 | ./entropy.py
        10+0 records in
        10+0 records out
        10240 bytes (10 kB) copied, 0.00253304 s, 4.0 MB/s
        7.78113154233
        7.81023909332
        7.82709308603
        7.80825125827
        7.81572421929
        7.77518144269
        7.83449952802
        7.81081381332
        7.81897457133
        7.80212491335

EXIT STATUS

    This exits with status 0 on success and 1 otherwise.
    This exits with a status greater than 1 if there was an
    unexpected run-time error.

AUTHOR

    Noah Spurrier <noah@noah.org>

LICENSE

    This license is approved by the OSI and FSF as GPL-compatible.
        http://opensource.org/licenses/isc-license.txt

    Copyright (c) 2014, Noah Spurrier
    PERMISSION TO USE, COPY, MODIFY, AND/OR DISTRIBUTE THIS SOFTWARE FOR ANY
    PURPOSE WITH OR WITHOUT FEE IS HEREBY GRANTED, PROVIDED THAT THE ABOVE
    COPYRIGHT NOTICE AND THIS PERMISSION NOTICE APPEAR IN ALL COPIES.
    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

VERSION

    Version 1
'''

__version__ = 'Version 1'
__date__ = 'date'
__author__ = 'Noah Spurrier <noah@noah.org>'

import sys
import os
import traceback
import optparse
import time
import logging
import math
import random
import fileinput

logging.basicConfig(format='%(asctime)s %(message)s')
logger = logging.getLogger(__name__)
if os.getenv('PYTHONLOGGING') in logging._levelNames:
    logger.setLevel(logging._levelNames[os.getenv('PYTHONLOGGING')])

# Uncomment the following section if you want readline history support.
#import readline, atexit
#histfile = os.path.join(os.environ['HOME'], '.TODO_history')
#try:
#    readline.read_history_file(histfile)
#except IOError:
#    pass
#atexit.register(readline.write_history_file, histfile)


def entropy_shannon(block):

    histogram = {}
    for vv in block:
        if vv in histogram:
            histogram[vv] += 1
        else:
            histogram[vv] = 1
    length = float(len(block))
    ee = 0.0
    for count in histogram.values():
        cl = float(count/length)
        ee += cl * math.log(cl, 2)
    # Add zero to eliminate negative zeros (an IEEE quirk).
    return -ee + 0.0


def read_blocks(fin, blocksize=1024):

    while True:
        block = fin.read(blocksize)
        if block:
            yield block
        else:
            return


def main(options=None, args=None):

    if options.blocksize == 0:
        print entropy_shannon(sys.stdin.read())
    else:
        for bb in read_blocks(sys.stdin, options.blocksize):
            print entropy_shannon(bb)


if __name__ == '__main__':
    try:
        start_time = time.time()
        parser = optparse.OptionParser(
            formatter=optparse.TitledHelpFormatter(),
            usage=globals()['__doc__'],
            version='1'
        )
        parser.add_option('--blocksize', type='int',
                          default=1024, help='set blocksize (default 1024)')
        parser.add_option('-v', '--verbose', action='store_true',
                          default=False, help='verbose output')
        (options, args) = parser.parse_args()
        #if len(args) < 1:
        #    parser.error ('missing argument')
        if options.verbose:
            print(time.asctime())
        exit_code = main(options, args)
        if exit_code is None:
            exit_code = 0
        if options.verbose:
            print(time.asctime())
            print('TOTAL TIME IN MINUTES: %f' %
                  ((time.time() - start_time) / 60.0))
        sys.exit(exit_code)
    except KeyboardInterrupt as e:
        # The user pressed Ctrl-C.
        raise e
    except SystemExit as e:
        # The script called sys.exit() somewhere.
        raise e
    except Exception as e:
        print('ERROR: Unexpected Exception')
        print(str(e))
        traceback.print_exc()
        os._exit(2)

# vim:set ft=python fileencoding=utf-8 sr et ts=4 sw=4 : See help 'modeline'
