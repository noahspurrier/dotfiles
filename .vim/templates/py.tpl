#!/usr/bin/env python
# vim:set ft=python fileencoding=utf-8 sr et ts=4 sw=4 : See help 'modeline'

"""
SYNOPSIS

    TODO: helloworld [-h,--help] [-v,--verbose] [--version]

DESCRIPTION

    TODO: This describes how to use this script.
    This docstring will be printed by the script if there is an error or
    if the user requests help (-h or --help).

EXAMPLES

    TODO: The following are some examples of how to use this script.
    $ helloworld --version
    1

EXIT STATUS

    TODO: This exits with status 0 on success and 1 otherwise.
    This exits with a status greater than 1 if there was an
    unexpected run-time error.

AUTHOR

    TODO: Name <name@example.org>

LICENSE

    This license is approved by the OSI and FSF as GPL-compatible.
        http://opensource.org/licenses/isc-license.txt

    TODO: Copyright (c) 4-digit year, Company or Person's Name
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

    TODO: Version 1
"""

__version__ = 'TODO: Version 1'
__date__ = 'TODO: date'
__author__ = 'TODO: Name <name@example.org>'

import sys
import os
import traceback
import optparse
import time
import logging
#from pexpect import run, spawn

logging.basicConfig(format='%(asctime)s %(message)s')
logger = logging.getLogger(__name__)
if os.getenv('PYTHONLOGGING') in logging._levelNames:
    logger.setLevel (logging._levelNames[os.getenv('PYTHONLOGGING')])

# Uncomment the following section if you want readline history support.
#import readline, atexit
#histfile = os.path.join(os.environ['HOME'], '.TODO_history')
#try:
#    readline.read_history_file(histfile)
#except IOError:
#    pass
#atexit.register(readline.write_history_file, histfile)

def main (options=None, args=None):

    # TODO: Do something more interesting here...
    sys.stdout.flush()
    sys.stdout.write ("\033[2J") # ED: clear screen
    sys.stdout.write ("\033[1;1H") # CUP: cursor home (row 1, col 1)
    sys.stdout.write ("\033[1G") # CHA: cursor to column 1
    print('Hello world!')

if __name__ == '__main__':
    try:
        start_time = time.time()
        # TODO: set version here.
        parser = optparse.OptionParser(
                formatter=optparse.TitledHelpFormatter(),
                usage=globals()['__doc__'],
                version='TODO')
        parser.add_option('-v', '--verbose', action='store_true',
                default=False, help='verbose output')
        (options, args) = parser.parse_args()
        #if len(args) < 1:
        #    parser.error ('missing argument')
        if options.verbose: print(time.asctime())
        exit_code = main(options, args)
        if exit_code is None:
            exit_code = 0
        if options.verbose:
            print (time.asctime())
            print ('TOTAL TIME IN MINUTES: %f'%((time.time()-start_time)/60.0))
        sys.exit(exit_code)
    except KeyboardInterrupt as e: # The user pressed Ctrl-C.
        raise e
    except SystemExit as e: # The script called sys.exit() somewhere.
        raise e
    except Exception as e:
        print ('ERROR: Unexpected Exception')
        print (str(e))
        traceback.print_exc()
        os._exit(2)

