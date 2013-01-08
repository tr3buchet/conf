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
set incsearch       " vim starts searching immediately and updates as you type

set nofoldenable    " disables folds/folding

set nocompatible
"set mouse=a

set visualbell      " no more beeps!

filetype plugin indent on
syntax enable

" centralized backup directory for swp files
set backupdir=~/.vim/tmp
set directory=~/.vim/tmp

" copy/paste between sessions
vmap <silent> <F5> y:call writefile(split(@0, "\n"), $HOME . "/.vim/copy_tmp")<cr>
nmap <silent> <F5> yy:call writefile(split(@0, "\n"), $HOME . "/.vim/copy_tmp")<cr>
nmap <F6> :r ~/.vim/copy_tmp<CR>

set title titlestring=%{v:progname}\ %F
"set title titlestring=[%{$PWD}]%%\ %{v:progname}\ %F

" 00 switches to next window
nnoremap 0 <C-w><C-w>

" ------- gist making! --------------------------------
fun Gister(...)
  let gister_call = "gister -v"
  for flag in a:000
    let gister_call = gister_call . " " . flag
  endfor
  let result = system(gister_call, expand("%:t") . "\n" . getreg("\""))
  echo result
endfun
" public gist on github from selection or single line
vnoremap <F9> y:call Gister()<cr>
nnoremap <F9> yy:call Gister()<cr>

" secret gist on github from selection or single line
vnoremap <F10> y:call Gister("-s")<cr>
nnoremap <F10> yy:call Gister("-s")<cr>

" public gist on private github from selection or single line
vnoremap <F11> y:call Gister("-p")<cr>
nnoremap <F11> yy:call Gister("-p")<cr>

" secret gist on private github from selection or single line
vnoremap <F12> y:call Gister("-p", "-s")<cr>
nnoremap <F12> yy:call Gister("-p", "-s")<cr>
" ------- end gist making! ---------------------------


" ----- ctags --------------------

" <F2> populates current git ctags database with current branch
fun GenCTags()
  let result = system('ctags -R -f /home/trey/.ctags/python_usr_lib /usr/local/lib/python2.6')
  let result = system('ctags -R -f /home/trey/.ctags/python_std_lib /usr/lib/python2.6')
  let path = system('git rev-parse --show-toplevel')
  if v:shell_error
      echo "not a git repo"
      return 0
  endif
  let result = system('ctags -R -f /home/trey/.ctags/current_branch ' . path)
endfun
nnoremap <silent> <F2> :call GenCTags()<cr>

"nnoremap ,bt :!ctags -R -o /home/trey/.tags/nova_current_branch /home/trey/nova/trunk<CR>

" path to tags db(s)
set tags=/home/trey/.ctags/current_branch,/home/trey/.ctags/python_std_lib,/home/trey/.ctags/python_usr_lib

" open ctag in new tab
"nnoremap <F4> :tab split<cr>:exec("tag ".expand("<cword>"))<cr>

" alt -> go to ctag under curser (2 for putty)
nnoremap <A-Right> <C-]>
nnoremap 2 <C-]>
" alt <- move back through ctags (1 for putty)
nnoremap <A-Left> <C-t>
nnoremap 1 <C-t>

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
inoremap <S-tab> <C-n>
inoremap <C-tab> <C-p>

" set tabs to insert tabs on line in normal mode
nnoremap <S-tab> <<
nnoremap <tab> >>
vnoremap <S-tab> <<
vnoremap <tab> >>


" omnicomplete
" set popup menu colors
" items are green on black
" selected item is red on black
" scrollbar is red on black
highlight Pmenu ctermbg=black ctermfg=green
highlight PmenuSel ctermbg=black ctermfg=red
highlight PmenuSbar ctermbg=black ctermfg=red
highlight PmenuThumb ctermfg=red

" set vimdiff colors
highlight DiffAdd ctermfg=black ctermbg=green
highlight DiffDelete ctermfg=black ctermbg=red
highlight DiffChange ctermfg=black ctermbg=yellow
highlight DiffText ctermfg=black ctermbg=magenta
highlight FoldColumn ctermfg=4 ctermbg=black
highlight Folded ctermfg=4 ctermbg=black

" only add up to the longest match into buffer
" show menu even if there is only one item
set completeopt=longest,menuone

" set term to xterm if inside screen
if &term == 'screen'
  exe "set term=xterm"
endif

" :w!! will save current file using sudo, (if you forgot)
cmap w!! %!sudo tee > /dev/null %

" use pathogen and shit
call pathogen#infect()

" config flake8
let g:syntastic_python_checker_args='--builtins=_'
