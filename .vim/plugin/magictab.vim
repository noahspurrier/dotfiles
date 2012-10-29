" MagicTab.vim
"
" This script will allow the TAB key to do completion yet still function as a
" TAB key for indentation. It uses the surrounding context to guess when you
" indend to do completion versus indentation. You can always use CTRL-V then TAB
" for a real tab.
"
" If your intent is a TAB character then TAB will insert a TAB and SHITF-TAB
" will delete one shiftwidth of indent (like TAB and CTRL-D). If your intent is
" completion then TAB will complete next and SHIFT-TAB will complete previous
" (like CTRL-N and CTRL-P).
"
" This script guesses intent based on the character in front of the cursor. If
" the character is a non-keyword character then you probably indend to insert a
" TAB. If the character is a keyword character then you probably want
" completion. See iskeyword option and '\k' in regular expressions.
"
" == Install ==
"
" Put this script in ~/.vim/plugin then edit your ~/.vimrc file to map the TAB
" key to the MagicTabWrapper.
"
"   inoremap <tab> <c-r>=MagicTabWrapper("forward")<cr>
"   inoremap <s-tab> <c-r>=MagicTabWrapper("backward")<cr>
"
" == License ==
"
" I release all copyright claims. This code is in the public domain. Permission
" is granted to use, copy modify, distribute, and sell this software for any
" purpose. I make no guarantee about the suitability of this software for any
" purpose and I am not liable for any damages resulting from its use. Further, I
" am under no obligation to maintain or extend this software. It is provided on
" an 'as is' basis without any expressed or implied warranty.

function MagicTabWrapper(direction)
    if pumvisible()
        if a:direction=="backward"
            return "\<c-p>"
        else
            return "\<c-n>"
        endif
    endif
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        if a:direction=="backward"
            return "\<c-d>"
        else
            return "\<tab>"
        endif
    elseif a:direction=="backward"
        if exists('&omnifunc') && &omnifunc != ''
            return "\<c-x>\<c-o>"
        else
            return "\<c-p>"
        endif
    endif
        if exists('&omnifunc') && &omnifunc != ''
            return "\<c-x>\<c-o>"
        else
            return "\<c-n>"
        endif
    endif
endfunction

