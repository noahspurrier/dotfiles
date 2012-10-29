" hl_bad_ws.vim
"
" This script will highlight suspicious whitespace. These are lines with mixed
" spaces and TABs; lines with trailing whitespace; or lines with only
" whitespace. This automatically ignores help and man pages because they have a
" lot of embedded TABs.
"
" == Install ==
" Put this script in ~/.vim/plugin then edit your ~/.vimrc file
" to turn on bad whitespace highlighting.
"
"   autocmd FileType * :call HighlightBadWS()
"
" == License ==
" I release all copyright claims. This code is in the public domain.
" Permission is granted to use, copy modify, distribute, and sell this software
" for any purpose. I make no guarantee about the suitability of this software
" for any purpose and I am not liable for any damages resulting from its use.
" Further, I am under no obligation to maintain or extend this software.
" It is provided on an 'as is' basis without any expressed or implied warranty.

highlight BadWS term=standout cterm=bold ctermbg=Red guibg=Red

function HighlightBadWS()
    if &filetype == "help" || &filetype == "man"
        " help files have a lot of embedded TABs
        exe 'match'
        return
    endif
    " highlight mixed TABs and spaces or lines with only whitespace
    let left= substitute(&commentstring, '\(.*\)%s.*', '\1', '')
    exe 'match BadWS /\([^\t'.left.'#]\+\)\@<=\t\+\|\s\+$/'
endfunction

