if &compatible
  " Vim defaults to `compatible` when selecting a vimrc with the command-line
  " `-u` argument. Override this.
  set nocompatible
endif

" Its {current year} we should be able to use a mouse if we want to
if has('mouse')
  set mouse=a
endif

" Insert anywhere and let vim worry about inserting the spaces
set virtualedit=block

set nostartofline	" Stop some movements placing cursor on start of line
set noautochdir		" Dont auto change dir to current file
set wrapscan		" Searches wrap around the end of the file
set magic		" Make regex like grep
set ignorecase		" Case insensitive search
set smartcase		" Case sensitive when using capital letters
set hlsearch		" Highlight searches

" Make "Visual Block" modemore useful
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

set nowrap 		" Don't wrap text

" Enable syntax highlighting
syntax enable

if has('guicolors')
  set guicolors
endif

" Preferred colorscheme, it ships with vim
colorscheme ron

set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands

" Pop vertical splits to the right, not left
set splitright
" Pop horizontal splits below, not above
set splitbelow

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

" use a more readable diff algorithm
if has("patch-8.1.0360")
	set diffopt+=internal,algorithm:patience
endif

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key


" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Protect changes between writes. Default values of updatecount (200 
" keystrokes) and updatetime (4 seconds) are fine
set swapfile
set directory^=~/.vim/swap//

set writebackup          " Protect against crash-during-write 
set nobackup             " But do not persist backup after successful write 
set backupcopy=auto      " Use rename-and-write-new method whenever safe
if has("patch-8.1.0251") " Patch required to honor double slash at end
	" Consolidate the writebackups -- not a big deal either way, 
        " since they usually get deleted
	set backupdir^=~/.vim/backup//
end

set undofile            " Persist the undo tree for each file
set undodir^=~/.vim/undo//

set history=200		" keep 200 lines of command line history
set wildmenu		" display completion matches in a status line
set wildignore+=*~,*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*.bak,*.exe,target,tags,.tags,*/.git/*
set wildignore+=*.pyc,*.DS_Store,*.db
set wildignore+=versions/*,cache/*


set tags=./tags,**5/tags,tags;~
"                          ^ in working dir, or parents
"                   ^ in any subfolder of working dir
"           ^ sibling of open file

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

" When using spellcheck press CTRL-N or CTRL-P in insert-mode to complete the word
set complete+=kspell

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

" TODO: Probably break below into their independent filetype files and keep the
" vimrc for applicable global config changes

" Spell check the following files/filetypes
autocmd BufRead,BufNewFile *.md setlocal spell spelllang=en
autocmd FileType gitcommit setlocal spell


" Plugins
" Integrate GDB into vim
if has('terminal')
    packadd! termdebug
endif

" Plugin Settings

" netrw (filebrowser) settings
" Set default view to long listing
let g:netrw_liststyle = 1
" Set the filesize show in human-readable (uses 1024 base)
let g:netrw_sizestyle = "H"
" Open files in new tab
let g:netrw_browse_split = 3
" don't show object files
let g:netrw_list_hide = "\.[oa]$"

" Custom key remaps

" Force saving files that require root permission 
cnoremap w!! w !sudo tee > /dev/null %

" Auto add end curly bracket
inoremap {<Enter> {<Enter>}<Esc>O
