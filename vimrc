let mapleader = ","
set visualbell

filetype on        " what kind of file am I?
filetype indent on " auto-indent is mandatory (next line, too)
filetype indent plugin on
filetype plugin on " TeX-Suite is cool
set nocompatible   " vi-like is a pain in the ass
set softtabstop=4  " to hell with tabs; pretend they aren't there
set tabstop=4      " really, get rid of tabs
"set ts=4
set shiftwidth=4   " Only indent by 4
"set expandtab      " Get rid of \t characters
set noexpandtab
set noet

syn on             " Colors also mandatory
"set wildmenu       " Completion is handy.
"set completeopt="menu,preview,longest"  " Cool.
"set visualbell t_vb=  " disable visual bells
"colorscheme mac    " Based off of darkblue
set nohlsearch     " Don't highlight on searches; I hate that
"set showmatch      " Show matching () [] {}
"set hidden         " Let me keep track of several buffers at once
set tw=99          " Keep the text a reasonable width
set bs=2           " Make backspace behave most like notepad
set ruler          " Show me some useful numbers
"set cursorline     " That's handy.
"set whichwrap=<,>,h,l,[,]

"Highlight trailing whitespace at the end of lines
syntax on
" This is for files whose language vim doesn't recognize
syn match ErrorMsg /\s\+$/
" This is for files where vim can use syntax highlighting in the language.
autocmd Syntax * syn match ErrorMsg /\s\+$/

                   " Allow movement commands to wrap around lines
set grepprg=grep\ -nH\ $*
                   " Needed by TeX-Suite
map Q gqap         " Do formatting with Q instead of gq
map = zf%          " Collapse paragraphs on command.
"map gl :w<CR>:!pdflatex %<CR><CR>
map gl :w<CR>:!xelatex %<CR><CR>
map <leader>l :w<CR>:!xelatex %<CR><CR>
                   " Compile LaTeX file
map <C-K> :pyf /usr/share/vim/addons/syntax/clang-format-3.3.py<CR>
set dictionary=/usr/share/dict/words
                   " ^X^K completion is _cool_
set imd
let g:miniBufExplMaxSize = 1 " Don't let this get in the way
nnoremap <silent> <F8> :TlistToggle<CR> " tags are awesome
" Makes the OmniCPP preview window go away.
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Fun with scons
au BufNewFile,BufRead SConstruct,SConscript set filetype=python

" For .tex files, automatically add in line breaks
au BufNewFile,BufRead *.tex set textwidth=79

" Make searches case-insensitive
set ignorecase

"Make the colors easier to see as white text on a black background
set background=dark

"Give an alternative to <escape> for Mac keyboards
inoremap jj <Esc>

" Install vim-plug. Idea taken from
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/vim-plug')
Plug 'junegunn/rainbow_parentheses.vim'
" Try to set up a vim Language Server Protocol plugin for Rust
Plug 'prabirshrestha/vim-lsp'
Plug 'wellle/context.vim'
" If you add something new here, remember to call :PlugInstall next time you
" open vim!
call plug#end()

" red and darkred look too similar on Macs.
"\     ['red',       'springgreen1'],
let g:rainbow#colors = {
\   'dark': [
\     ['darkred',       'springgreen1'],
\     ['yellow',    'orange1'     ],
\     ['darkgreen', 'yellow1'     ],
\     ['cyan',      'greenyellow' ],
\     ['magenta',   'green1'      ],
\   ],
\   'light': [
\     ['red',         'green4'        ],
\     ['darkyellow',  'orangered3'    ],
\     ['darkgreen',   'orange2'       ],
\     ['blue',        'yellow3'       ],
\     ['darkmagenta', 'olivedrab4'    ],
\   ]
\ }
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
au VimEnter * RainbowParentheses


" Enable ctags support for the Privacy.com server repo
let &tags = $PRIVACY_META_ENV_ROOT . '/server/tags'

:command! JsonFormat :%!python -m json.tool

"if executable('rust-analyzer')
"  au User lsp_setup call lsp#register_server({
"        \   'name': 'Rust Language Server',
"        \   'cmd': {server_info->['rust-analyzer']},
"        \   'whitelist': ['rust'],
"        \ })
"endif
"let g:lsp_diagnostics_enabled = 0

" Put all .swp files in one place, rather than polluting all the different repos we work on. The
" two slashes at the end mean "files should be named with their full path name, so that two files
" with the same name in different locations don't use the same .swp file by mistake." Solution
" taken from https://stackoverflow.com/a/21026618
set directory=$HOME/.vim/swapfiles//
