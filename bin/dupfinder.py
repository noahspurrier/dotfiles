#!/usr/bin/env python

'''
SYNOPSIS

    dupfinder [-h,--help] [-v,--verbose] [--version] [--length=4096] [PATH=.]

DESCRIPTION

    This scans the given PATH and attempts to find duplicate files.
    The scan algorithm creates a finger-print of a portion of the file.
    This makes the scanner very fast, but has the danger of producing
    false positive matches for duplicate files. In general, this is rarely
    a problem. By default only the first 4096 bytes of a file is used.
    This can be changed by specifying the '--length' option.

    If a directory begins with '.git', '.svn', or 'CVS' then it is ignored.

    FIXME: rescan all positive matched files with a full byte-by-byte
    comparison to eliminate false positives.

    This docstring will be printed by the script if there is an error or
    if the user requests help (-h or --help).

EXAMPLES

    The following are some examples of how to use this script.
    This output will show the hash shared by duplicate files,
    followed by a list of files. There will be a blank line
    between each set of duplicates.

    $ dupfinder
    f429cce199f00ae43c4cbb19db5fab0f
     ./voreen-src-3.0.1-unix/resource/qt/icons/open.png
     ./voreen-src-3.0.1-unix/resource/vrn_share/icons/open.png

    d24f28774c0c1e2a910334a44044eee4
     ./.wine/drive_c/windows/system32/ddhelp.exe
     ./.wine/drive_c/windows/system32/dosx.exe
     ./.wine/drive_c/windows/system32/dsound.vxd

    5c9228d7a60cf3abd6e85ae13e1db6da
     ./PCL-1.6.0-Source/doc/tutorials/content/images/s1-6.png
     ./PCL-1.6.0-Source/doc/tutorials/content/images/registration/s1-6.png

    1d57212de5ec225551824f13d40fb1a7
     ./PCL-1.6.0-Source/build/io/CMakeFiles/pcl_io.dir/flags.make
     ./PCL-1.6.0-Source/build/io/CMakeFiles/pcl_io_ply.dir/flags.make


EXIT STATUS

    This exits with status 0 on success and 1 otherwise.
    This exits with a status greater than 1 if there was an
    unexpected run-time error.

AUTHOR

    Noah Spurrier <noah@noah.org>

LICENSE

    This license is approved by the OSI and FSF as GPL-compatible.
        http://opensource.org/licenses/isc-license.txt

    Copyright (c) 2013, Noah Spurrier <noah@noah.org>
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
__date__ = ''
__author__ = 'Noah Spurrier <noah@noah.org>'

import sys
import os
import traceback
import optparse
import time
import hashlib
import stat
#from pexpect import run, spawn


def short_sha(filename, max_length=1024):

    if not is_regular_file(filename):
        return '--- NOT REGULAR FILE -----------'
    try:
        fin = file(filename, 'rb')
        if max_length <= 0:
            data = fin.read()
        else:
            data = fin.read(max_length)
        m = hashlib.sha1(data)
    except Exception:
        return '--- COULD NOT READ FILE --------'
    return m.hexdigest()


def short_md5(filename, max_length=1024):

    if not is_regular_file(filename):
        return '--- NOT REGULAR FILE -----------'
    try:
        fin = file(filename, 'rb')
        if max_length <= 0:
            data = fin.read()
        else:
            data = fin.read(max_length)
        m = hashlib.md5(data)
    except Exception:
        return '--- COULD NOT READ FILE --------'
    return m.hexdigest()


def short_hash(filename, max_length=1024):

    if not is_regular_file(filename):
        return '--- NOT REGULAR FILE -----------'
    try:
        fin = file(filename, 'rb')
        if max_length <= 0:
            data = fin.read()
        else:
            data = fin.read(max_length)
        m = hash(data)
    except Exception:
        return '--- COULD NOT READ FILE --------'
    return hex(m)


def is_regular_file(filename):

    try:
        stat_mode = os.stat(filename)[stat.ST_MODE]
        if stat.S_ISREG(stat_mode):
            return True
    except OSError:
        return False
    return False


def test_hashes():

    '''This shows the speed of various Python hash functions. This was used to
    decide which hash to use. MD5 is fastest, as expected, but it doesn't hurt
    to know how much faster. Python also has a built-in hash() function, which
    is only 64-bit and platform dependent. Consistent hashing across platforms
    isn't required, but it's a nice feature to have. The main bottleneck in
    this application is disk I/O, so using a faster hash does not improve
    performance very much. Also, note that disk caching under Linux is very
    efficient, so when testing disk speed it's critical to tell Linux to clear
    the cache between each test.

        sync ; sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'

    Alternatively, you can run a throw-away test first to make sure data is
    cached before timing real tests. This can be tricky to get right. You are
    testing multiple layers at the same time.'''

    # timeit is part of the Python Standard Library.
    import timeit
    for hash_alg in ('sha1', 'sha224', 'sha256', 'sha384', 'sha512', 'md5'):
        t = timeit.Timer("hashlib.%s(x).hexdigest()" % hash_alg,
                "import hashlib;x=open('/dev/urandom','r').read(32768)")
        print hash_alg + "\t" + repr(t.timeit(10000))
    # The following test seems to run much too fast.
    t = timeit.Timer("hex(hash(x))", "x=open('/dev/urandom','r').read(32768)")
    print "hash()\t" + repr(t.timeit(10000))


def main(options=None, args=None):

    if len(args) == 0:
        start_path = '.'
    else:
        start_path = args[0]
    hashed_files = {}
    number_processed = 0
    for root, dirs, files in os.walk(start_path):
        if options.verbose:
            sys.stdout.write("# %s\n" % root)
        for filename in files:
            filename_canonical = os.path.join(root, filename)
            hash_key = short_md5(filename_canonical, options.length)
            #hash_key = short_sha(filename_canonical, options.length)
            #hash_key = short_hash(filename_canonical, options.length)
            if hash_key in hashed_files:
                hashed_files[hash_key].append(filename_canonical)
            else:
                hashed_files[hash_key] = [filename_canonical]
#            number_processed=number_processed+1
            #if not (number_processed%1000): print number_processed, root
#            if number_processed > 400000:
#                return
        if 'CVS' in dirs:
            dirs.remove('CVS')
        if '.svn' in dirs:
            dirs.remove('.svn')
        if '.git' in dirs:
            dirs.remove('.git')
        if '.gvfs' in dirs:
            dirs.remove('.gvfs')
#    hashed_files = sorted(hashed_files)
#    seen_hashes = {}
#    for record in hashed_files:
#        #sys.stdout.write("%s, %d, %s\n" % record)
#        if record[0] in seen_hashes:
#            seen_hashes[record[0]].append(record)
#        else:
#            seen_hashes[record[0]] = [record]
    rehashed_files = {}
    for (hash_key, records) in hashed_files.items():
        if len(records) <= 1:
            next
        for filename_canonical in records:
            rehash_key = short_md5(filename_canonical, 0)
            if rehash_key in rehashed_files:
                rehashed_files[rehash_key].append(filename_canonical)
            else:
                rehashed_files[rehash_key] = [filename_canonical]

    for (rehash_key, records) in rehashed_files.items():
        if len(records) > 1:
            rs = iter(records)
#            sys.stdout.write('# %s\n' % rehash_key)
            sys.stdout.write('# %s\n' % rs.next())
            for fn in rs:
                sys.stdout.write('rm %s\n' % fn)
            sys.stdout.write('\n')

if __name__ == '__main__':
    try:
        start_time = time.time()
        parser = optparse.OptionParser(
                formatter=optparse.TitledHelpFormatter(),
                usage=globals()['__doc__'],
                version='1')
        parser.add_option('-v', '--verbose', action='store_true',
                default=False, help='verbose output')
        parser.add_option('--length', dest='length', type='int',
                default=4096, help='Max length of bytes to examine. 0 for all.')
        (options, args) = parser.parse_args()
        if options.verbose:
            sys.stdout.write('# %s\n' % time.asctime())
        #if len(args) < 1:
        #    parser.error ('missing argument')
        exit_code = main(options, args)
        if exit_code is None:
            exit_code = 0
        if options.verbose:
            sys.stdout.write('# %s\n' % time.asctime())
            sys.stdout.write('# TOTAL TIME IN MINUTES: %f\n' %
                    ((time.time() - start_time) / 60.0))
        sys.exit(exit_code)
    except KeyboardInterrupt, e:
        # The user pressed Ctrl-C.
        raise e
    except SystemExit, e:
        # The script called sys.exit() somewhere.
        raise e
    except Exception, e:
        sys.stdout.write('ERROR: Unexpected Exception\n')
        sys.stdout.write(str(e))
        traceback.print_exc()
        os._exit(2)

# vim:set ft=python fileencoding=utf-8 sr et ts=4 sw=4 : See help 'modeline'
