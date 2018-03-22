set nowrap          " do not wrap text
set number          " display line number

" tab settings
set autoindent
set expandtab       " convert tabs to spaces
set softtabstop=4   " number of spaces to insert when tab is pressed in insert mode, use with 'set expandtab'
"set tabstop=4       " sets how wide to display tabs
set shiftwidth=4    " number of spaces to insert with reindent operations (<< and >>) and automatic C-style indentation

set showmatch       " highlights all matches when searching
set hlsearch        " sets highlighting of all search terms
set incsearch       " vim starts searching immediately and updates as you type

set nofoldenable       " disables folds/folding
set foldminlines=99999 " disables the folding even in vimdiff

set nocompatible
"set mouse=a

" some leader+key maps (leader defaults to '\')
set pastetoggle=<leader>p
imap <leader><leader> <esc>
map <leader>x :x<return>
imap <leader>x <esc>:x<return>
map <leader>w :w<return>
imap <leader>w <esc>:w<return>
map <leader>q :qa<return>
imap <leader>q <esc>:qa<return>
nmap <leader>n O# NOTE(trey): 
nmap <leader>s :%s/\<<c-r><c-w>\>//gc<left><left><left>
vmap <leader>s :s/\<\>//gc<left><left><left><left><left><left>

" ctrl-/ clear search highlighting in normal mode
nmap  :noh<cr>:<cr>

set laststatus=2      " always display status line
if filereadable(glob("~/.vim/bundle/syntastic/plugin/syntastic.vim"))
    set statusline=%<%F\ %h%m%r%=%-24.(%{SyntasticStatuslineFlag()}%)%-14.(%l,%c%V%)\ %P    " same as default status but absolute path instead of relative
else
    set statusline=%<%F\ %h%m%r%=%-14.(%l,%c%V%)\ %P    " same as default status but absolute path instead of relative
endif

"set t_Co=256 " explicitly tell vim that the terminal supports 256

set visualbell      " no more beeps!
set showcmd

" centralized backup directory for swp files
set backupdir=~/.vim/tmp
set directory=~/.vim/tmp

" copy/paste between sessions
vmap <silent> <F5> y:call writefile(split(@0, "\n"), $HOME . "/.vim/copy_tmp")<cr>
nmap <silent> <F5> yy:call writefile(split(@0, "\n"), $HOME . "/.vim/copy_tmp")<cr>
nmap <F6> :r ~/.vim/copy_tmp<CR>

set title titlestring=%{v:progname}\ %F
"set title titlestring=[%{$PWD}]%%\ %{v:progname}\ %F

" 0 switches to next window
nnoremap 0 <C-w><C-w>

" remember cursor location in file
if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"zz" | endif
endif

" space centers current line
nmap <space> zz

" set tabs to insert tabs on line in normal mode
nnoremap <S-tab> <<
nnoremap <tab> >>
vnoremap <S-tab> <
vnoremap <tab> >


" ------- vundle --------------------------------------------------------------------------------------------------
if filereadable(glob("~/.vim/bundle/vundle/autoload/vundle.vim"))
    filetype off                  " required

    " set the runtime path to include Vundle and initialize
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()
    " alternatively, pass a path where Vundle should install bundles
    "let path = '~/some/path/here'
    "call vundle#rc(path)

    " let Vundle manage Vundle, required
    Bundle 'gmarik/vundle'

    " The following are examples of different formats supported.
    " Keep bundle commands between here and filetype plugin indent on.
    " scripts on GitHub repos
    Bundle 'tr3buchet/vimgitgrep'
    Bundle 'scrooloose/syntastic'
    " ...

    filetype plugin indent on     " required
    " ------- end vundle --------------------------------------

    " ------- vimgitgrep --------------------------------------
    nmap <silent> <F2> :call Gr3p()<cr>
    nmap <silent> <F3> :call GitGr3p(0)<cr>
    nmap <silent> <F4> :call ToggleLList()<cr>
    nmap <silent> <A-Up> :call Previousresult()<cr>
    nmap <silent> <A-Down> :call Nextresult()<cr>
    nmap <silent> <A-Left> :call GoBackSearch()<cr>
    nmap <silent> <A-Right> :call GitGr3p(1)<cr>
    let g:gitgreppathexcludes = '^doc/\|\/doc/\|^locale/\|/locale/\|.sample$'
    " ------- end vimgitgrep ----------------------------------

    " ------- syntastic settings ------------------------------
    " config flake8 setup in the syntastic plugin
    " leader e populates location list with errors
    nnoremap <silent> <leader>e :SyntasticSetLoclist<cr>
    let g:syntastic_python_checkers = ['flake8']
    let g:syntastic_python_flake8_args='--builtin=_'
    let g:syntastic_check_on_open = 1                  " run syntastic check on file open
    let g:syntastic_aggregate_errors = 1               " run all checkers and aggregate results
    let g:syntastic_always_populate_loc_list = 0       " put errors into the location list
    let g:syntastic_auto_loc_list = 0                  " don't open or close the loc list
    let g:syntastic_stl_format = '[err: %e][warn: %w]' " yep
    let g:syntastic_enable_highlighting = 0            " highlight the errors is off
    let g:syntastic_enable_signs = 0                   " disable the white bar on the left showing errors
    " ------- end syntastic settings --------------------------
endif
" ------- end vundle ----------------------------------------------------------------------------------------------

" ------- swapfile dealing with -----------------------------------------------------------------------------------
" g:newvim starts as 1 when .vimrc is sourced.
" g:newvim is set to 0 when vim finishes loading (VimEnter fires)
" when vim starts, if opening a file where there is a swap file, g:newvim = 1 and it will prompt.
" once is running, g:newvim = 0, and it will no longer prompt, instead it
" opens read-only for ease of bouncing around with vimgitgrep.
let g:newvim = 1
augroup swaps
    autocmd VimEnter * let g:newvim = 0
    autocmd SwapExists * call Swapper(expand('<afile>:p'), v:swapname)
augroup END

fun Swapper(filename, swapname)
    if g:newvim == 1
        let v:swapchoice = ''
    else
        let v:swapchoice = 'o'
    endif
endfun
" ------- end swapfile dealing with -------------------------------------------------------------------------------


" ------- gist making! --------------------------------
fun Gister(...)
  let gister_call = "gister -v"
  for flag in a:000
    let gister_call = gister_call . " " . flag
  endfor
  let result = system(gister_call, expand("%:t") . "\n" . getreg("\""))
  echo result
endfun
" secret gist on public github from selection or single line
vnoremap <F9> y:call Gister()<cr>
nnoremap <F9> yy:call Gister()<cr>

" secret gist on private github from selection or single line
vnoremap <F10> y:call Gister("-p")<cr>
nnoremap <F10> yy:call Gister("-p")<cr>
" ------- end gist making! ---------------------------


" ------- white space time -------------------------------------------------------------
" show trailing whitespace
"autocmd ColorScheme * highlight RedBG ctermbg=red guibg=red
"highlight RedBG ctermbg=red guibg=red
"let w:m1=matchadd("RedBG", '\s\+$')

" show trailing whitespace, but not when i am typing (cause that's annoying right?)
" see http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight RedBG ctermbg=red guibg=red
augroup TrailingWhitespaceMatch
  " Remove ALL autocommands for the TrailingWhitespaceMatch group.
  autocmd!
  autocmd BufWinEnter * let w:redbg1 =
        \ matchadd('RedBG', '\s\+$')
  autocmd InsertEnter * call s:ToggleWhitespaceMatch('i')
  autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
augroup END
function! s:ToggleWhitespaceMatch(mode)
  " first pattern is match trailing whitespace except when typing at end of line
  " we want this in insert mode
  " second pattern is match any trailing whitespace
  " want this in normal mode
  let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
  if exists('w:redbg1')
    call matchdelete(w:redbg1)
    call matchadd('RedBG', pattern, 10, w:redbg1)
  else
    " Something went wrong, try to be graceful.
    let w:redbg1 = matchadd('RedBG', pattern)
  endif
endfunction
" ------- end white space time ---------------------------------------------------------

" set vimdiff colors
highlight DiffAdd ctermfg=black ctermbg=green
highlight DiffDelete ctermfg=black ctermbg=red
highlight DiffChange ctermfg=black ctermbg=yellow
highlight DiffText ctermfg=black ctermbg=magenta
highlight FoldColumn ctermfg=4 ctermbg=black
highlight Folded ctermfg=4 ctermbg=black

" set term to xterm if inside screen
"if &term == 'screen'
"  exe "set term=xterm"
"endif

" :w!! will save current file using sudo, (if you forgot)
cmap w!! %!sudo tee > /dev/null %

" because golang is stupid
au BufRead,BufNewFile *.go set noet ts=4 sw=4
