'''
.pythonrc

Add the following line to your ~/.bashrc"
export PYTHONSTARTUP="$HOME/.pythonrc"

'''

# Some of this is done automatically now in Python3.
import os
import readline
import rlcompleter
import atexit
history_file = os.path.join(os.environ['HOME'], '.python_history')
atexit.register(readline.write_history_file, history_file)
try:
    readline.read_history_file(history_file)
except IOError:
    pass
# Negative length for unlimited history.
readline.set_history_length(-1)
readline.parse_and_bind("tab: complete")
readline.parse_and_bind('"\e[B": history-search-forward')
readline.parse_and_bind('"\e[A": history-search-backward')
readline.parse_and_bind('set blink-matching-paren on')
readline.parse_and_bind('set skip-completed-text on')
readline.parse_and_bind('set completion-query-items -1')
readline.parse_and_bind('set show-all-if-ambiguous on')
del history_file
del atexit
del rlcompleter
del readline
del os

#import sys
#sys.ps2=''
#del sys

try:
    import boto3
    print('Imported boto3')
except:
    pass

print('Imported %s' % __file__)

