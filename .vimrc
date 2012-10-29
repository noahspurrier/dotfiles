" .vimrc
"
" This is a long vimrc, but it does not do anything drastic.
"
" Noah Spurrier

" To set Vim as your default editor and page add the following to your .bashrc
" and/or .profile startup files. Also note that $PAGER is set blank
" INSIDE of this .vimrc file.
"export EDITOR=vim
"export VISUAL=vim
"export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
"    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
"    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
"    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

" Unset PAGER environment variable to prevent recursive
" fork when using Vim's 'Man' command.
" This works with the PAGER setting in .profile or .bashrc. 
let $PAGER=''

set nocompatible " use vim defaults (this should be first in .vimrc)
filetype plugin on " load ftplugin.vim
filetype indent on " load indent.vim

set encoding=utf-8
" When 'fileencoding' is empty, the same value as 'encoding' will be used.
"set fileencoding=utf-8

" Use a software cursor when in a Linux console.
" This is helpful on embedded systems with a broken cursor.
"if &term == "linux"
"    set t_ve+=^[[?48c
"endif

set history=1000 " number of commands and search patterns to save
"set binary " show control characters (ignore 'fileformat')
set noautoindent " do not auto indent
set shiftround " round alignment to nearest indent when shifting with < and >
" turn off auto adding comments on next line so cut and paste works better.
" http://vimdoc.sourceforge.net/htmldoc/change.html#fo-table
"set formatoptions=tcq
set formatoptions+=r " auto-format comments while typing
" Traditional xterm has only 8 colors while newer terms have at least 16.
" Strangely, Mac OS X does not support 256 color xterm.
if &term =~ "xterm"
    if has("terminfo")
        set t_Co=8
        set t_Sf=<Esc>[3%p1%dm
        set t_Sb=<Esc>[4%p1%dm
    else
        set t_Co=8
        set t_Sf=<Esc>[3%dm
        set t_Sb=<Esc>[4%dm
    endif
else
    set t_Co=16
endif
"colorscheme native
if $BACKGROUND == "light" " set terminal background color (see map for <F3>)
    set background=light
else
    "This is the default if BACKGROUND not set
    set background=dark
endif

"highlight LiteralTabs ctermbg=darkgreen guibg=darkgreen
"match LiteralTabs /\s\ /
"highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
"match ExtraWhitespace /\s\+$/

"set guifont=Lucida_Console:h8 " set gvim font on Windows
syntax on " use syntax color highlighting
"colo ps_color " color scheme in ~/.vim/colors
"set visualbell " flash instead of beep -- this can be annoying
"set visualbell t_vb= " no beep or flash
"set mouse=a " enable VIM mouse (see map for F12)
set ttyfast " smoother display on fast network connections
set whichwrap=b,s,<,>,[,],~ " allow most motion keys to wrap
set backspace=indent,eol,start " allow bs over EOL, indent, and start of insert
set nostartofline " if possible, keep cursor in same column for many commands
set incsearch " incremental search
set hlsearch " highlight the current search pattern
" Press enter to clear the current search highlight.
nnoremap <silent><CR> :nohlsearch<CR><CR>
set ignorecase " ignore case when searching (see smartcase)
set smartcase " do not ignore case if pattern has mixed case (see ignorecase)
set nojoinspaces " use only one space when using join
set matchpairs+=<:> " add < > to chars that form pairs (see % command)
set showmatch " show matching brackets by flickering cursor
set matchtime=1 " show matching brackets quicker than default
set modeline " docs say this is default, but not on any Vim I tried!
set autoread " automatically read file changed outside of Vim
set autowrite " automatically save before commands like :next and :make
set splitbelow " open new split windows below the current one
set winminheight=0 " This makes more sense than the default of 1
set noequalalways " do not resize windows on split/close
"set shortmess="" " long messages -- does not seem to work
set showcmd " show partial command in status line
set tags=~/tags,./tags;,tags; " semicolon searchs up, see :h file-searching
set suffixes+=.class,.pyc,.o,.so " skip bytecode files for filename completion
set suffixes-=.h " do not skip C header files for filename completion
set wrap " wrap long lines
set sidescroll=1 " smooth scroll if set nowrap. for slow terminals set to 0.
"set showbreak=>>>> " string to print before wrapped lines
" set backup " backup files before editing
" set backupdir=~/tmp,.,/tmp,/var/tmp " backup locations
set dir=~/tmp,.,/tmp,/var/tmp " swap file locations
set virtualedit=block " allow selection anywhere when in Visual block mode
set laststatus=2 " always show statusline 
set statusline=%n\ %1*%h%f%*\ %=%<[%3lL,%2cC]\ %2p%%\ 0x%02B%r%m
set ruler " show ruler, but only shown if laststatus is off
set rulerformat=%h%r%m%=%f " sane value in case laststatus is off
set nonumber " don't show line numbers
"set printoptions=number:y " put line numbers on hardcopy
set printoptions=paper:letter " print US letter sized paper, not A4.
set wildmenu " show a menu of matches when doing completion
set wildmode=longest:full " make completion work like Bash.
set title " shows the current filename and path in the term title.
set showfulltag " show search pattern when completion matches in a tag file.
set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:< " :h 'list
if version >= 630
    set viminfo=!,%,'20,/100,:100,s100,n~/.viminfo " options for .viminfo
else
    set viminfo=!,%,'20,/100,:100,n~/.viminfo " options for .viminfo
endif
if version >= 700
    """ " Highlight the line and column of the cursor.
    """ set cursorline cursorcolumn
    """ au WinLeave * set nocursorline nocursorcolumn
    """ au WinEnter * set cursorline cursorcolumn
    set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,nbsp:% " :h 'list
    set numberwidth=4 " width of line numbers
    set nofsync " improves performance -- let OS decide when to flush disk
endif
if version >= 730
    set undofile
endif

"""" " Special handling for big files.
"""" let g:BigFileSizeLimit = 1024*1024 * 10
"""" " Editing big files can make Vim unusable if certain
"""" " options are turned on. If the file size is greater than
"""" " the big file size limit then set several options to
"""" " help improve speed and save memory. This does little to
"""" " improve the time it takes to open a file, but it makes
"""" " navigation and editing much faster. The following is
"""" " a list of option values and why they are set this way:
"""" "
"""" " * Syntax highlighting on big files makes navigation slow.
"""" "     eventignore+=FileType (no syntax highlighting)
"""" " * Swap files of big files are big and slow, so turn swap off.
"""" "     noswapfile
"""" " * When editing multiple big files in buffer you don't want
"""" " hidden files to be loaded in memory. Note this has the
"""" " downside that switching buffers will be slower.
"""" "     bufhidden=unload
"""" " * Turn off undo because changes that effect the entire file would
"""" " cause a massive undo history to be created.
"""" "     undolevels=-1
"""" " * Remind the user that they are editing a big file.
"""" "     statusline+=\ BIG\ File
"""" if !exists("big_file_auto_commands_loaded")
""""     let big_file_auto_commands_loaded = 1
""""     augroup BigFile
""""         autocmd BufReadPre *
""""             \ if getfsize(expand("<afile>")) > g:BigFileSizeLimit || getfsize(expand("<afile>")) <= -2
""""             \|   set eventignore+=FileType
""""             \|   setlocal noswapfile bufhidden=unload undolevels=-1
""""             \|   setlocal statusline+=\ BIG\ File
""""             \|   echomsg "WARNING: Using big file mode."
""""             \|   echomsg ""
""""             \| else
""""             \|   set eventignore-=FileType
""""             \|   echomsg "NOTICE: Not using big file mode."
""""             \|   echomsg ""
""""             \| endif
""""     augroup END
"""" endif

" For python.vim syntax by Dmitry Vasiliev. See ~/.vim/syntax/python.vim.
let g:python_highlight_all=1

"
" Tab settings for filetypes that should be set even if ftplugin is off.
"
set shiftround expandtab tabstop=4 shiftwidth=4 " default
autocmd FileType python   set shiftround expandtab tabstop=4 shiftwidth=4 " Python
autocmd FileType make     set shiftround noexpandtab tabstop=8 shiftwidth=8 " Makefile
autocmd FileType sh       set shiftround noexpandtab tabstop=8 shiftwidth=8 " shell scripts
autocmd FileType man      set shiftround noexpandtab tabstop=8 shiftwidth=8 " Man page (also used by psql to edit or view)
autocmd FileType calendar set shiftround noexpandtab tabstop=8 shiftwidth=8 " calendar(1) reminder service

" augroup vimrc_autocmds
"   autocmd BufRead * highlight OverLength ctermbg=lightgray guibg=lightgray
"   autocmd BufRead * match OverLength /\%74v.*/
" augroup END

" This was just too clever and never worked quite right.
" I still want something like this, so I keep it here in case
" I ever figure out a smarter way of doing this.
" use magictab
"inoremap <tab> <c-r>=MagicTabWrapper("forward")<cr>
"inoremap <s-tab> <c-r>=MagicTabWrapper("backward")<cr>

" This highlights suspicious whitespace.
"autocmd FileType * :call HighlightBadWS()

" These are used by the DirDiff plugin.
" DirDiff rules!
let g:DirDiffExcludes = ".git,.svn,*.jpg,*.png,*.gif,*.swp,*.a,*.so,*.o,*.pyc,*.exe,*.class,CVS,core,a.out"
let g:DirDiffIgnore = "Id:,Revision:,Date:"

"FIXME: DO NOT USE. SET TO ZERO. BACKUPS ARE BROKEN.
"/usr/sbin/ Make backups when using openssl plugin.
"FIXME: THIS IS BROKEN DUE TO A VIM BUG.
let g:openssl_backup = 0

" Automatically load templates for new files. Silent if the template for the
" extension does not exist. Virtually all template plugins I have seen for Vim
" are too complicated. This just loads what extension matches in
" $VIMHOME/templates/. For example the contents of html.tpl would be loaded
" for new html documents.
augroup BufNewFileFromTemplate
au!
autocmd BufNewFile * silent! 0r $HOME/.vim/templates/%:e.tpl
autocmd BufNewFile * normal! G"_dd1G
autocmd BufNewFile * silent! match Todo /TODO/
augroup BufNewFileFromTemplate

"
" maps
"

" \cwd changes current working directory
map <leader>cwd :cd %:p:h<CR>

" map Q as @q (replay the recording named q). I always use q as my throw-away
" recording name, so I start recording with "qq" then reply the recording with
" "Q". I never found a use for interactive ex-mode so I don't miss the
" original definition of Q.
nnoremap Q @q

" get rid of most annoying typo: typing q: when I meant :q.
" You can still get to cmdline-window easily by typing <Ctrl-F> in
" command mode, so loosing q: is no loss.
map q: :q

" easy indentation in visual mode
" This keeps the visual selection active after indenting.
" Usually the visual selection is lost after you indent it.
vmap > >gv
vmap < <gv

" Use display movement with arrow keys for extra precision. Arrow keys will
" move up and down the next line in the display even if the line is wrapped.
" This is useful for navigating very long lines that you often find with
" automatically generated text such as HTML.
" This is not useful if you turn off wrap.
imap <up> <C-O>gk
imap <down> <C-O>gj
nmap <up> gk
nmap <down> gj
vmap <up> gk
vmap <down> gj

" Split window selector and stacker.
" CTRL-J goes down one window and maximizes it; other windows are minimized.
" CTRL-K goes up one window and maximizes it; other windows are minimized.
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

" This maps \y so that it will yank the visual selection, and also quote the
" regex metacharacters so you can then paste into a search pattern. For
" example, use v to select some text. Press \y. Then start a search with /.
" Type CTRL-R" to insert the yanked selection. The last two mappings allow you
" to visual select an area and then search for other matches by typing * or #.
vmap <silent> <leader>y y:let @"=substitute(escape(@",'.$*[^\/~'),'\n','\\n','g')<CR>
vmap <silent> * y:let @/=substitute(escape(@",'.$*[^\/~'),'\n','\\n','g')<CR>n
vmap <silent> # y:let @/=substitute(escape(@",'.$*[^\/~'),'\n','\\n','g')<CR>N
vnoremap <silent> * :<C-U>
              \let old_reg=getreg('"')<bar>
              \let old_regmode=getregtype('"')<cr>
              \gvy/<C-R><C-R>=substitute(substitute(
              \escape(@", '\\/.*$^~[]' ), "\n$", "", ""),
              \"\n", '\\_[[:return:]]', "g")<cr><cr>
              \:call setreg('"', old_reg, old_regmode)<cr>
vnoremap <silent> # :<C-U>
              \let old_reg=getreg('"')<bar>
              \let old_regmode=getregtype('"')<cr>
              \gvy?<C-R><C-R>=substitute(substitute(
              \escape(@", '\\/.*$^~[]' ), "\n$", "", ""),
              \"\n", '\\_[[:return:]]', "g")<cr><cr>
              \:call setreg('"', old_reg, old_regmode)<cr>

" echo the date and time
"map <leader>d :echo strftime("%Y-%m-%d %H:%M:%S")<CR>

" spell check
" <F2> or \s
if version >= 700
    nnoremap <silent><F2> <ESC>:set spell!<CR>
    nnoremap <silent><leader>s <ESC>:set spell!<CR>
    "setlocal spell spelllang=en_us
else " older versions use external aspell
    nnoremap <silent><F2> <ESC>:!aspell -c "%"<CR>:edit! "%"<CR>
    nnoremap <silent><leader>s <ESC>:!aspell -c "%"<CR>:edit! "%"<CR>
endif

" tab support
if version >= 700
    map <S-left> :tabp<CR>
    map <S-right> :tabn<CR>
endif

" refresh - redraw window
" <F5>
nnoremap <silent><F5> :redraw!<CR>

" This runs the current buffer in an X terminal that disappears after 5 minutes.
" This needs the env var $TERM set to xterm or some compatible X11 terminal.
" This does not save first!
" <F7> or \r
function RunBufferInTerm ()
    if &filetype == 'python'
        silent !$TERM -bg black -fg green -e bash -c "python %; sleep 300" &
    elseif &filetype == 'sh'
        silent !$TERM -bg black -fg green -e bash -c "./%; sleep 300" &
    elseif &filetype == 'php'
        silent !$TERM -bg black -fg green -e bash -c "php %; sleep 300" &
    elseif &filetype == 'perl'
        silent !$TERM -bg black -fg green -e bash -c "perl %; sleep 300" &
    endif
    sleep 1
    redraw!
endfunction
nnoremap <silent><F7> :call RunBufferInTerm()<CR>
nnoremap <silent><leader>r :call RunBufferInTerm()<CR>

" <F8> or \a
" yank all lines
nnoremap <silent><F8> gg"+yG
nnoremap <silent><leader>a gg"+yG
" <F10> or \n
" toggle line numbers
nnoremap <silent><F10> :set number!<CR>
nnoremap <silent><leader>n :set number!<CR>
" <F3>
" toggle between dark and light backgrounds
nnoremap <silent><F3> :let &background=(&background == "dark"?"light":"dark")<CR>
" <F4>
" toggle mouse mode between VIM and xterm
function ShowMouseMode()
    if (&mouse == 'a')
        echo "MOUSE VIM"
    else
        echo "MOUSE X11"
    endif
endfunction
nnoremap <silent><F4> :let &mouse=(&mouse == "a"?"":"a")<CR>:call ShowMouseMode()<CR>

" This is now covered by the DirDiff plugin.
" extra diff support
"
"map <silent><leader>dp :diffput<CR>
"map <silent><leader>dg :diffget<CR>

" run Vim diff on HEAD copy in SVN.
nnoremap <silent><leader>ds :call SVNDiff()<CR>
function! SVNDiff()
   let fn = bufname("%")
   let newfn = fn . ".HEAD"
   let catstat = system("svn cat " . fn . " > " . newfn)
   if catstat == 0
      execute 'vert diffsplit ' . newfn
   else
      echo "*** ERROR: svn cat failed for " . fn . " (as " . newfn . ")"
   endif
endfunction

"
" folding using the current /search/ pattern -- very handy!
"
" \z
" This folds every line that does not contain the search pattern.
" So the end result is that you only see lines with the pattern
" see vimtip #282 and vimtip #108
"map <silent><leader>z :set foldexpr=getline(v:lnum)!~@/ foldlevel=0 foldcolumn=0 foldmethod=expr<CR>
nnoremap <silent><leader>z :set foldexpr=(getline(v:lnum)=~@/)?\">1\":\"=\" foldlevel=0 foldcolumn=0 foldmethod=expr foldtext=getline(v:foldstart)<CR>
" space toggles the fold state under the cursor.
nnoremap <silent><space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l')<CR>
" this folds all classes and functions -- mnemonic: think 'function fold'
nnoremap <silent>zff :set foldexpr=UniversalFoldExpression(v:lnum) foldmethod=expr foldlevel=0 foldcolumn=0 foldtext=getline(v:foldstart)<CR><CR>
function UniversalFoldExpression(lnum)
    if a:lnum == 1
        return ">1"
    endif
    "The first pattern matches C-like function syntax. It is fragile, but
    "works more or less bettern than not having it at all.
    return (getline(a:lnum)=~"^[a-zA-Z_][a-zA-Z_0-9]*\\s\\+[^(;=,]\\+([^);=]*)\\s*$\\|^\\s*public function\\s\\|^\\s*private function\\s\\|^\\s*function\\s\\|^\\s*class\\s\\|^\\s*def\\s") ? ">1" : "="
endfunction
" This doesn't work quite right:
    "if &filetype == 'php'
    "    if getline(a:lnum) =~ '/\*\*'
    "        call cursor(a:lnum,1)
    "        let sp = searchpair ('/\*\*','','\*/')
    "        call cursor(sp,1)
    "        let ax = search ('\n*\s*function','cW')
    "        if ax != 0
    "            return ">1"
    "        endif
    "    endif
    "    return "="
    "endif
    " @/ is the register that holds the last search pattern.

" plugins
runtime ftplugin/man.vim " allow vim to read man pages

"
" type \doc to insert PHPdocs
" see vimtip #1355
"
augroup php_doc
au!
"autocmd BufReadPost *.php,*.inc source ~/.vim/php-doc.vim
autocmd BufReadPost *.php,*.inc nnoremap <leader>doc :call PhpDocSingle()<CR>
autocmd BufReadPost *.php,*.inc vnoremap <leader>doc :call PhpDocRange()<CR>
augroup END


"
" This sets mouse support for editing XPM images in gvim.
" see h: xpm
"
function! GetPixel()
    let c = getline(".")[col(".") - 1]
    echo c
    exe "noremap <LeftMouse> <LeftMouse>r".c
    exe "noremap <LeftDrag>  <LeftMouse>r".c
endfunction
autocmd BufReadPre *.xpm noremap <RightMouse> <LeftMouse>:call GetPixel()<CR>
autocmd BufReadPre *.xpm set guicursor=n:hor20 " to see the color under cursor

"
" Experimental stuff
"

" visually select lines and turn them into an HTML table.
vnoremap <silent><leader>ht :s/\(\S\+\)/    <td>\1<\/td><CR>:'<,'>s/^\s*$/<\/tr><tr><CR>'>o</tr></table><ESC>'<O<table><tr><ESC>

function! AppendUnnamedReg()
    let old=@"
    yank
    let @" = old . @"
endfun

" online doc search
" TODO This needs some work.
map <silent><M-d> :call OnlineDoc()<CR>
function! OnlineDoc()
    if &ft =~ "cpp"
        let s:urlTemplate = "http://doc.trolltech.com/4.1/%.html"
    elseif &ft =~ "ruby"
        let s:urlTemplate = "http://www.ruby-doc.org/core/classes/%.html"
    elseif &ft =~ "php"
        let s:urlTemplate = "http://www.php.net/%"
    elseif &ft =~ "perl"
        let s:urlTemplate = "http://perldoc.perl.org/functions/%.html"
    elseif &ft =~ "python"
        let s:urlTemplate = "http://starship.python.net/crew/theller/pyhelp.cgi?keyword=%"
    else
        return
    endif
    let s:browser = "firefox"
    let s:wordUnderCursor = expand("<cword>")
    let s:url = substitute(s:urlTemplate, "%", s:wordUnderCursor, "g")
    let s:cmd = "silent !" . s:browser . " " . s:url
    execute  s:cmd
    redraw!
endfunction

" another online doc search
" TODO This also needs some work.
" vimtip #1354
function! OnlineDoc()
    let s:browser = "firefox"
    let s:wordUnderCursor = expand("<cword>")
    if &ft == "cpp" || &ft == "c" || &ft == "ruby" || &ft == "php" || &ft == "python"
        let s:url = "http://www.google.com/codesearch?q=".s:wordUnderCursor."+lang:".&ft
    elseif &ft == "vim"
        let s:url = "http://www.google.com/codesearch?q=".s:wordUnderCursor
    else
        return
    endif
    let s:cmd = "silent !" . s:browser . " " . s:url
    "echo  s:cmd
    execute  s:cmd
endfunction
" online doc search
map <LocalLeader>k :call OnlineDoc()<CR>

" simple calculator based loosely on vimtip #1349
" control the precision with this variable
let g:MyCalcPresition = 2
function MyCalc(str)
    return system("echo 'scale=" . g:MyCalcPresition . " ; print " . a:str . "' | bc -l")
endfunction
" Use \C to replace a math expression by the value of its computation
vmap <leader><silent>C :s/.*/\=MyCalc(submatch(0))/<cr>/<BS>
vmap <leader><silent>C= :B s/.*/\=submatch(0) . " = " . MyCalc(submatch(0))/<cr>/<BS>

" Python command Calc based on vimtip #1235
" does NOT use built-in vim python
command! -nargs=+ Calc :r! python -c "from math import *; print <args>"

" allow reading of MS Word doc documents
" on Ubuntu you must install the antiword package.
autocmd BufReadPre *.doc set ro
autocmd BufReadPost *.doc silent %!antiword -f -s -i 1 -m 8859-1 - | fmt -ut --width=78

" allow reading of MS Word doc documents
" on Ubuntu install the antiword deb package.
autocmd BufReadPre *.doc set ro
autocmd BufReadPost *.doc silent %!antiword -i 1 -s -f "%" - |fmt -csw78

" jump to the last known position in a file
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Split the 'screen' window if Vim is running inside a screen session.
map \s <esc><esc>:silent! if(strlen($STY))<CR>
            \silent! screen -X split<CR>:silent! screen -X focus down<CR>:silent! screen -X screen $SHELL -c "screen -X zombie;$SHELL;screen -X remove;screen -X redisplay"<CR>:redraw!<CR><CR>
            \endif<CR><CR>

":let &mouse=(&mouse == "a"?"":"a")<CR>

if filereadable ("~/.vimrc_local")
    source ~/.vimrc_local
endif

