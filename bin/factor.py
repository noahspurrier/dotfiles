#!/usr/bin/env python

'''
SYNOPSIS

    factor.py INTEGER

DESCRIPTION

    This will print the factors of the given INTEGER.
    If no INTEGER is given as an argument then integers will be read from
    standard input.
    The output format is compatible with shell arithmatic expressions.

EXAMPLES

    $ ./factor.py 68931686392
    2**3 * 89681 * 96079

EXIT STATUS

    This exits with status 0 on success and 1 otherwise.
    This exits with a status greater than 1 if there was an
    unexpected run-time error.

AUTHOR

    Noah Spurrier <noah@noah.org>

LICENSE

    This license is approved by the OSI and FSF as GPL-compatible.
        http://opensource.org/licenses/isc-license.txt

    Copyright (c) 2013, Noah Spurrier
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

import sys
import os
import traceback
import optparse
import time


def prime_factors(nn):

    ii = 2
    limit = nn ** 0.5
    while ii <= limit:
        if nn % ii == 0:
            nn = nn / ii
            limit = nn ** 0.5
            yield ii
        else:
            ii += 1
    if nn > 1:
        yield nn


def standard_form(nn):

    pf = list(prime_factors(nn))
    pf_sf = [(ff, pf.count(ff)) for ff in set(pf)]
    pf_sf.sort()
    return pf_sf


def standard_form_formatted(nn):

    sf = standard_form(nn)
    ss = ''
    for (ff, cc) in sf:
        if cc > 1:
            ss += '%d**%d * ' % (ff, cc)
        else:
            ss += '%d * ' % ff
    ss = ss[:-3]
    return ss


def main(options, args):

    # Figure out where to get input (file or stdin).
    # Use stdin if arguments are given.
    if len(args) > 0:
        list_ints_to_factor = map(int, args)
    else:
        list_ints_to_factor = map(int, sys.stdin.readlines())

    for nn in list_ints_to_factor:
        print(standard_form_formatted(nn))


if __name__ == '__main__':

    try:
        start_time = time.time()
        parser = optparse.OptionParser(
            formatter=optparse.TitledHelpFormatter(),
            usage=globals()['__doc__'],
            version='1')
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
            print('TOTAL TIME IN MINUTES: %f'
                  % ((time.time() - start_time) / 60.0))
        sys.exit(exit_code)
    except KeyboardInterrupt, e:  # The user pressed Ctrl-C.
        raise e
    except SystemExit, e:  # The script called sys.exit() somewhere.
        raise e
    except Exception, e:
        print('ERROR: Unexpected Exception')
        print(str(e))
        traceback.print_exc()
        os._exit(2)

# vim:set ft=python fileencoding=utf-8 sr et ts=4 sw=4 : See help 'modeline'
