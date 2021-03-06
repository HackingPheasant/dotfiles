" vim compiler file
" Compiler:     LLVM clang
" Maintainer:   Joe Nelson <joe@begriffs.com>
" Last Change:  2019 Jun 29

" allow user plugin to override, can remove this
" guard if installing to personal runtime directory
if exists("current_compiler")
	finish
endif

let current_compiler = "clang"

" for older vim versions
if exists(":CompilerSet") != 2
	command -nargs=* CompilerSet setlocal <args>
endif

" formatting variations documented at
" https://clang.llvm.org/docs/UsersManual.html#formatting-of-diagnostics
"
" It should be possible to make this work for the combination of
" -fno-show-column and -fcaret-diagnostics as well with multiline
" and %p, but I was too lazy to figure it out.
"
" The %D and %X patterns are not clang per se. They capture the directory
" change messages from (GNU) 'make -w'. I needed this for building a project
" which used recursive Makefiles.

CompilerSet errorformat=
	\%f:%l%c:{%*[^}]}{%*[^}]}:\ %trror:\ %m,
	\%f:%l%c:{%*[^}]}{%*[^}]}:\ %tarning:\ %m,
	\%f:%l:%c:\ %trror:\ %m,
	\%f:%l:%c:\ %tarning:\ %m,
	\%f(%l,%c)\ :\ %trror:\ %m,
	\%f(%l,%c)\ :\ %tarning:\ %m,
	\%f\ +%l%c:\ %trror:\ %m,
	\%f\ +%l%c:\ %tarning:\ %m,
	\%f:%l:\ %trror:\ %m,
	\%f:%l:\ %tarning:\ %m,
	\%D%*\\a[%*\\d]:\ Entering\ directory\ %*[`']%f',
	\%D%*\\a:\ Entering\ directory\ %*[`']%f',
	\%X%*\\a[%*\\d]:\ Leaving\ directory\ %*[`']%f',
	\%X%*\\a:\ Leaving\ directory\ %*[`']%f',
	\%DMaking\ %*\\a\ in\ %f

CompilerSet makeprg=make

" vim:foldmethod=marker:foldlevel=0
