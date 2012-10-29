#!/usr/bin/env python

try:
    import readline
except ImportError:
    print ("Module readline not available.")
else:
    # Setup readline and history saving
    from atexit import register
    from os import path
    import rlcompleter

    # Set up a tab for completion; use a single space to indent Python code.
    readline.parse_and_bind('set show-all-if-ambiguous on')
    readline.parse_and_bind('tab: complete')

    history = path.expanduser('~/.python_history')
    readline.set_history_length(1000)

    # Read the history of the previous session, if it exists.
    if path.exists(history):
        readline.read_history_file(history)

    # Set up history saving on exit.
    def save(history=history, readline=readline):
        readline.write_history_file(history)

    register(save)

    # Clean up the global name space. Note that save, history, and readline
    # will continue to exist, since del decrements the reference count by one.
    del register, path, readline, rlcompleter, history, save
