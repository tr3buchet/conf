set nowrap          " do not wrap text
set number          " display line number

" tab settings
set autoindent
set expandtab       " convert tabs to spaces
"set tabstop=4      " sets how wide to display tabs
set softtabstop=4   " number of spaces to insert when tab is pressed in insert mode, use with 'set expandtab'
set shiftwidth=4    " number of spaces to insert with reindent operations (<< and >>) and automatic C-style indentation

set showmatch       " highlights all matches when searching
set hlsearch        " sets highlighting of all search terms

set nocompatible
"set mouse=a

filetype plugin indent on
syntax enable

" centralized backup directory for swp files
set backupdir=~/.vim/tmp
set directory=~/.vim/tmp

set title titlestring=%{$PWD}>\ %{v:progname}\ %f

" 00 switches to next window
nnoremap 00 <C-w><C-w>


" ----- ctags --------------------

" <F2> populates current bzr ctags database with current branch
fun GenCTags()
  let path = system('bzr root')
  if v:shell_error
    let path = system('git rev-parse --show-toplevel')
    if v:shell_error
      echo "not a git or bzr repo"
      return 0
    endif
  endif
  let result = system('ctags -R -f /home/trey/.ctags/python_std_lib /usr/local/lib/python2.6')
  let result = system('ctags -R -f /home/trey/.ctags/current_branch ' . path)
endfun
nnoremap <silent> <F2> :call GenCTags()<cr>

"nnoremap ,bt :!ctags -R -o /home/trey/.tags/nova_current_branch /home/trey/nova/trunk<CR>

" path to tags db(s)
set tags=/home/trey/.ctags/current_branch,/home/trey/.ctags/python_std_lib

" open ctag in new tab
"nnoremap <F4> :tab split<cr>:exec("tag ".expand("<cword>"))<cr>

" alt -> go to ctag under curser
nnoremap <A-Right> <C-]>
" alt <- move back through ctags
nnoremap <A-Left> <C-t>

" F4 opens ctag in vertical split
nnoremap <F4> :vsp <cr>:exec("tag ".expand("<cword>"))<cr>

" taglist window width
let Tlist_WinWidth = 60

" sorting
let Tlist_Sort_Type = "name"

" t opens taglist
nnoremap <silent> t :TlistToggle<cr>

" <F3> calls :tselect on word under cursor
fun TLTSelect()
  let s:word = expand('<cword>')
  :exe ":tselect " . s:word
endfun
nnoremap <F3> :call TLTSelect()<cr>
" ----- /ctags -------------------


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
"inoremap <S-tab> <tab>
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
command ReloadVims execute "!screen -X at \"\\#\" stuff :e"
nnoremap <F5> :ReloadVims<cr>

" :w!! will save current file using sudo, (if you forgot)
cmap w!! %!sudo tee > /dev/null %
