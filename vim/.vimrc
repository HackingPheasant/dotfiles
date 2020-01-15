" Its {current year} we should be able to use a mouse if we want to
if has('mouse')
  set mouse=a
endif

set nostartofline	" Stop some movements placing cursor on start of line
set noautochdir		" Dont auto change dir to current file
set wrapscan		" Searches wrap around the end of the file
set magic		" Make regex like grep
set ignorecase		" Case insensitive search
set smartcase		" Case sensitive when using capital letters
set hlsearch		" Highlight searches

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Put these in an autocmd group, so that you can revert them with:
" ":augroup vimStartup | au! | augroup END"
augroup vimStartup
  au!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid, when inside an event handler
  " (happens when dropping a file on gvim) and for a commit message (it's
  " likely a different one than last time).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

augroup END

set  showfulltag	" Add context around the tag 

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

set nowrap 		" Dont wrap text

" Enable synntax highlighting
syntax enable

if has('guicolors')
  set guicolors
endif

set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
" Revert with ":filetype off".
filetype plugin indent on

set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Force saving files that require root permission 
cnoremap w!! w !sudo tee > /dev/null %

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

set history=200		" keep 200 lines of command line history
set wildmenu		" display completion matches in a status line
set wildignore+=*~,*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*.bak,*.exe,target,tags,.tags,*/.git/*
set wildignore+=*.pyc,*.DS_Store,*.db
set wildignore+=versions/*,cache/*

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

" Plugins

" Intergrate GDB into vim
if has('terminal')
    packadd! termdebug
endif


" Custom Commands
" Note: Use <c-u> after : to clear the command line.

" Properly display nfo files
autocmd BufRead,BufNewFile *.nfo,*.NFO set ft=nfo

" TODO: Add command to close windows all at once
" F3 opens termdebug with specific layout
nnoremap <F3> :<c-u>Termdebug <CR><c-w>2j<c-w>L<c-w>h

" TODO: Make these more flexible
" F5 to compile
nnoremap <silent> <F5> :<c-u>make %<<cr>
" Ctrl+F5 to run compiled program
nnoremap <silent> <C-F5> :<c-u>vertical term ./%<<cr>
