"""""""""""""""""""""""""""""""""""""""""""""""""" 
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""" 

if has('gui_running')
    colorscheme spring-night
    let g:spring_night_kill_italic=1

    " Window size
    set lines=50 columns=130
    syntax on
else
    set t_Co=256
    syntax on
    hi Search cterm=NONE ctermfg=Black ctermbg=White cterm=BOLD
    hi ColorColumn ctermbg=Blue 
endif

execute pathogen#infect()

"""""""""""""""""""""""""""""""""""""""""""""""""" 
" Common optimizations I've adopted
"""""""""""""""""""""""""""""""""""""""""""""""""" 

filetype indent plugin on

set autoindent
set nocompatible
set wildmenu
set showcmd
set hlsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set number
set shiftwidth=4
set softtabstop=4
set expandtab
set nrformats=
set colorcolumn=90
set relativenumber
autocmd FileType make setlocal noexpandtab


" Display the current working directory at the bottom of the window
set ls=2

inoremap jk <esc>
vnoremap <leader>jk <esc>
nnoremap <leader>jk <esc>

"""""""""""""""""""""""""""""""""""""""""""""""""" 
" Leader Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""" 

" General_rules: 
"   (1) leader mappings are two letters unless fundamental
"   (2) the first character specifies the category 
"           b = buffer    
"           v = vim
"           a = add-on/plugin

let mapleader = "\<Space>"
let maplocalleader = "-"

nnoremap <leader>w <c-w><c-w>

" Swap buffers in a two way split and stay in the current buffer
nnoremap <leader>bs <c-w><c-x><c-w><c-w>
vnoremap <leader>bs <c-w><c-x><c-w><c-w>gv

" edit and source vimrc
nnoremap <leader>ve :tabe $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

" have vim cd to buffer's path
nnoremap <leader>bc :cd %:p:h<cr>
vnoremap <leader>bc :cd %:p:h<cr>gv

nnoremap <leader>r :call ToggleRelativeNumber()<cr>
vnoremap <leader>r :call ToggleRelativeNumber()<cr>gv

" commands for quick commenting
autocmd BufEnter *.h,*.cpp,*.c nnoremap <buffer> <localleader>c I//<esc>
autocmd BufEnter *.h,*.cpp,*.c vnoremap <buffer> <localleader>c :s/^/\/\//<cr>:nohl<cr>

autocmd BufEnter *.py,Makefile nnoremap <buffer> <localleader>c I#<esc>
autocmd BufEnter *.vim,.vimrc nnoremap <buffer> <localleader>c I"<esc>

" Faster copy paste for GUI vim
nnoremap <leader>y "+yy
vnoremap <leader>y "+y

nnoremap <leader>p "+p
vnoremap <leader>p "+p
nnoremap <leader>P "+P

" Moving lines up and down -- taken from vim wiki
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" ctags: index current directory
nnoremap <leader>t :cd %:p:h<cr>:!ctags -R .<cr><cr>

"""""""""""""""""""""""""""""""""""""""""""""""""" 
" Abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""" 

" Rule: each abbreviation starts with '`'

" (50 characters)
iab `/ //////////////////////////////////////////////////
iab `- --------------------------------------------------
iab `= ==================================================
iab `" """"""""""""""""""""""""""""""""""""""""""""""""""
iab `# ##################################################

" (70 characters)
iab ``/ //////////////////////////////////////////////////////////////////////
iab ``- ----------------------------------------------------------------------
iab ``= ======================================================================
iab ``" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""" 
" Relative numbers
"""""""""""""""""""""""""""""""""""""""""""""""""" 

function! ToggleRelativeNumber()
    if (&relativenumber ==? 0)
        set relativenumber
    elseif (&relativenumber ==? 1) 
        set norelativenumber
    endif
endfunction

