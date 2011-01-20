set nowrap          " do not wrap text
set number          " display line number

" tab settings
set autoindent
set expandtab       " convert tabs to spaces
"set tabstop=4      " sets how wide to display tabs
set softtabstop=2   " number of spaces to insert when tab is pressed in insert mode, use with 'set expandtab'
set shiftwidth=2    " number of spaces to insert with reindent operations (<< and >>) and automatic C-style indentation

set showmatch       " highlights all matches when searching
set hlsearch        " sets highlighting of all search terms

set nocompatible
"set mouse=a

filetype plugin indent on
syntax enable

" centralized backup directory for swp files
set backupdir=~/.vim/tmp
set directory=~/.vim/tmp

" set titlestring
set title titlestring=%{$PWD}>\ %{v:progname}\ %f

" ctags
" map ,bt :!ctags -R -o /home/trey/.tags/nova_trunk /home/trey/nova/trunk<CR>
" set tags=/home/trey/.ctags/nova_trunk,/home/trey/.ctags/python_std_lib
" map <F4> <C-]>
" map <F3> <C-t>

" remember cursor location in file
if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"zz" | endif
endif

" space centers current line
nmap <space> zz

" show trailing whitespace
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Auto completion using shift tab
inoremap <S-tab> <C-p>

" set tabs to insert tabs on line in normal mode
nnoremap <S-tab> <<
nnoremap <tab> >>


" omnicomplete
" set popup menu colors
" items are green on black
" selected item is red on black
" scrollbar is red on black
highlight Pmenu ctermbg=black ctermfg=green
highlight PmenuSel ctermbg=black ctermfg=red
highlight PmenuSbar ctermbg=black ctermfg=red
highlight PmenuThumb ctermfg=red

" only add up to the longest match into buffer
" show menu even if there is only one item
set completeopt=longest,menuone

" set term to xterm if inside screen
if &term == 'screen'
  exe "set term=xterm"
endif

" reload all files open in vim in current screen session
command ReloadVims execute "!screen -X at \"\\#\" stuff :e^M"
nnoremap <F5> :ReloadVims<cr>

" :w!! will save current file using sudo, (if you forgot)
cmap w!! %!sudo tee > /dev/null %
