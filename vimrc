runtime! archlinux.vim

set nocompatible

"set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
set hidden       " Hide buffers when they are abandoned
set mouse=a      " Enable mouse usage (all modes) in terminals

filetype plugin indent on
syntax on

colorscheme mydesert

"set background=dark

let mapleader = ","

" Scroll the viewport faster by 3 lines
nnoremap <C-e> <C-e><C-e><C-e>
nnoremap <C-y> <C-y><C-y><C-y>

" Highlight search terms
"set hlsearch
"set incsearch

" Scroll buffer if cursor hits less than x lines on border
set scrolloff=3

" Show ↪ at the beginning of wrapped lines
let &sbr = nr2char(8618).' '

set visualbell

" default tab settings
autocmd FileType * set noexpandtab
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent

autocmd FileType groovy,scala,ruby,haskell,tex,bib,xml setlocal sts=2 ts=2 sw=2 expandtab
autocmd FileType tex set textwidth=70

" treat html files as xml (i.e. indentation and ftplugins)
autocmd BufNewFile,BufRead *.html,*.htm set filetype=xml
autocmd BufNewFile,BufRead *.gradle set filetype=groovy

set ruler

" project plugin
let g:proj_flags="imstvg"
let g:proj_window_width="30"
map <C-T> <Esc>:tabnew<CR><Plug>ToggleProject/
nmap <silent> <F3> <Plug>ToggleProject

" show trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/

" remove trailing whitespace and those ^M
function Trimws()
	%s/[ \t\r]\+$//eg
endfunction

let g:GetLatestVimScripts_allowautoinstall=1

set pastetoggle=<F12>

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

"shortcut to toggle whitespace display
nmap <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬
