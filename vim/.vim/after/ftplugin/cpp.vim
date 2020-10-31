" the smartest indent engine for C
setlocal cindent

" auto-create folds per grammar
setlocal foldmethod=syntax
setlocal foldlevel=10

" set clang-format as auto-formatting tool
setlocal equalprg=clang-format
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
iabbrev main() int main(int argc, char** argv)

" add #include guard
iabbrev #g <C-R>=toupper(substitute(expand("%:p:h:t") . "_" . expand("%:t:r") . "_H", "[^a-z]", "_", "ig"))<CR><esc>yypki#ifndef <esc>j0i#define <esc>o<cr><cr>#endif<esc>2ki
