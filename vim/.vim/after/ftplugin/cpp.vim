" the smartest indent engine for C
setlocal cindent

" auto-create folds per grammar
setlocal foldmethod=syntax
setlocal foldlevel=10

" set clang-format as auto-formatting tool
setlocal equalprg=clang-format\ --style=file
" Example Usage:
"   Format a whole file can be done like so
"   :gg=G
"   Wheres gg is start of file, = invokes indent (when equalprg is empty),
"   which in this case is clang-format, then G to go to end of file

setlocal path=.,,*/include/**2,./*/include/**2
" setlocal path+=/usr/include/**4,/usr/local/include/**3
" Disabled 2nd line for now as it took to long in vim

" Light shorthand/abbreviations
" So for example #d will change into #define
iabbrev #i #include
iabbrev #d #define
iabbrev main() auto main(int argc, char** argv) -> int

" add #include guard
iabbrev #g <C-R>=toupper(substitute(expand("%:p:h:t") . "_" . expand("%:t:r") . "_H", "[^a-z]", "_", "ig"))<CR><esc>yypki#ifndef <esc>j0i#define <esc>o<cr><cr>#endif<esc>2ki

" easily comment/uncomment c++ code
" https://stackoverflow.com/a/5437834/4634499
map <C-c> :s/^/\/\//<Enter>
map <C-u> :s/^\/\///<Enter>

" Hookup clang-check to <F5>
" https://clang.llvm.org/docs/HowToSetupToolingForLLVM.html#using-clang-tools
"
" TODO: Make it work by finding compile_commands.jsons (currently we have to
" be at the toplevel of the project so we can look into and find the
" 'build/*/compile_commands.json' file.
function! ClangCheckImpl(cmd)
    if &autowrite | wall | endif
    echo "Running " . a:cmd . " ..."
    let l:output = system(a:cmd)
    cexpr l:output
    cwindow
    let w:quickfix_title = a:cmd
    if v:shell_error != 0
        cc
    endif
    let g:clang_check_last_cmd = a:cmd
endfunction

function! ClangCheck()
    let l:filename = expand('%')
    if l:filename =~ '\.\(cpp\|cxx\|cc\|c\)$'
        " I normally keep src and build folders seperate, so give the tool the
        " helping hand it needs to find compile_commands.json
        " ISSUE: I need to open vim in project root
        call ClangCheckImpl("clang-check -p build/\* " . l:filename)
    elseif exists("g:clang_check_last_cmd")
        call ClangCheckImpl(g:clang_check_last_cmd)
    else
        echo "Can't detect file's compilation arguments and no previous clang-check invocation!"
    endif
endfunction

nmap <silent> <F5> :call ClangCheck()<CR><CR>
