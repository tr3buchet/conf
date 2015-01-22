" Wrapping and tabs.
" these are sane for everything, so I have these in .vimrc
""set textwidth=78        " (tw) number of columns before an automatic line break is inserted (see formatoptions)
""set tabstop=4           " (ts) width (in spaces) that a <tab> is displayed as
"set shiftwidth=4        " (sw) width (in spaces) used in each step of autoindent (aswell as << and >>)
""set smarttab            " (sta) 'shiftwidth' used in front of a line, but 'tabstop' used otherwise
"set expandtab           " (et) converts tabs to spaces
"set softtabstop=4       " (sts) amount of spaces to insert with tab keypress
"set autoindent          " (ai) turn on auto-indenting

" More syntax highlighting.
let python_highlight_all = 1

" Show long lines and highlight trailing whitespace
" for some reason just the long line by itself breaks the trailing whitespace
" set in the main .vimrc file, so have to match both here
"highlight LongLine guibg=red ctermbg=red
"match LongLine /\(\%>79v.\+\)\|\(\s\+$\)/
"match LongLine /\%>79v.\+/

" add longlines to the RedBG highlight defined in ~/.vimrc
let w:redbg2=matchadd("RedBG", '\%>79v.\+')

" remove NOTE from the todo hilighing
syn clear pythonTodo
syn keyword pythonTodo XXX TODO FIXME contained
