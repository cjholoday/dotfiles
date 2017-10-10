" Do this first because it affects other commands
set nocompatible

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
" Common configurations 
"""""""""""""""""""""""""""""""""""""""""""""""""" 

" Load plugins, indentation, and trigger a FileType event 
filetype indent plugin on

set autoindent
set wildmenu
set showcmd
set hlsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set number
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set nrformats=
set colorcolumn=80
set relativenumber

" Use real tabs for makefiles because the syntax demands it
autocmd FileType make setlocal noexpandtab

" Use two space indentation with html
autocmd FileType html setlocal shiftwidth=2
autocmd FileType html setlocal smarttab
autocmd FileType jsx setlocal smarttab
autocmd FileType jsx setlocal shiftwidth=2

" Escape from insert and visual mode with 'jk'
inoremap jk <esc>
vnoremap <leader>jk <esc>

" Search visually selected text
vnoremap * y/<C-R>"<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""" 
" Leader Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""" 

let mapleader = "\<Space>"
let maplocalleader = "-"

" Quickly switch between buffers
nnoremap <leader>w <c-w><c-w>

" Quickly move tabs around
nnoremap <leader>n :tabmove 0<esc>
nnoremap <leader>m :tabmove<esc>

" Quickly save and exit a file
nnoremap <leader>f :w<esc>
nnoremap <leader>d :q<esc>

" Swap buffers in a two way split and stay in the current buffer
nnoremap <leader>bs <c-w><c-x><c-w><c-w>
vnoremap <leader>bs <c-w><c-x><c-w><c-w>gv

" cd to buffer's path
nnoremap <leader>bc :cd %:p:h<cr>
vnoremap <leader>bc :cd %:p:h<cr>gv

" Set flag
nnoremap <leader>sp :call TogglePaste()<cr>
nnoremap <leader>sn :call ToggleNumber()<cr>
nnoremap <leader>sr :call ToggleRelativeNumber()<cr>
vnoremap <leader>sr :call ToggleRelativeNumber()<cr>gv

" Edit and source vimrc
nnoremap <leader>ve :tabe $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

function! ToggleRelativeNumber()
    if (&relativenumber ==? 0)
        set relativenumber
    elseif (&relativenumber ==? 1) 
        set norelativenumber
        set number
    endif
endfunction

function! ToggleNumber()
    if (&number ==? 0)
        set number
    elseif (&number ==? 1)
        set nonumber
    endif
endfunction

function! TogglePaste()
    if (&paste ==? 0)
        set paste
    elseif (&paste ==? 1)
        set nopaste
    endif
endfunction

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

