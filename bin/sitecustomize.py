#!/usr/bin/env python

"""
DESCRIPTION

    This file should be in the the PYTHONPATH.
    It will be automatically imported when Python starts.
    This drops you into the Python debugger, pdb, when there is
    an unhandled exception but only when output is to a TTY
    not redirected to a pipe.

LICENSE

    This license is OSI registered and FSF approved as GPL-compatible.

    Copyright (c) 2009, Noah Spurrier <noah@noah.org>

    Permission to use, copy, modify, and/or distribute this software for any
    purpose with or without fee is hereby granted, provided that the above
    copyright notice and this permission notice appear in all copies.

    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
"""

import sys

def info(type, value, tb):
    if hasattr(sys, 'ps1') or not sys.stderr.isatty():
        sys.__excepthook__(type, value, tb)
    else:
        import traceback, pdb
        traceback.print_exception(type, value, tb)
        print
        pdb.pm()

sys.excepthook = info

# vim:set sr et ts=4 sw=4 ft=python : // See Vim, :help 'modeline'
