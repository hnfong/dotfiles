"**************************** Basic Global Settings ****************************"
" nocp must be first
set nocompatible

set autoindent
set background=dark
set backspace=2
set nojoinspaces " don't insert two spaces special characters like '.'
set ruler
set scrolloff=5 " scroll offset. don't have to be at top/bottom of the screen to scroll the page
set shiftwidth=4 " indentation stuff
set showcmd 
set showmatch
set showmode
set tabstop=4
set wildmenu
set wildmode=full
set winminheight=0
set sidescroll=1
set splitbelow
set splitright
set nostartofline " don't jump to line start when pgup/down etc.
set whichwrap=<,>
set t_mr=[0;1;37;41m " custom "reverse" terminal escape code
set hls
set ignorecase
set smartcase
syntax on

" workaround TERM=screen problem where some keys are not recognized (eg F[1-12] keys)
if ( $TERM == "screen" )
	set term=$REALTERM
endif

"**************************** Basic Global (Normal Mode) Mappings ****************************"
" <F1>:			remove the help, substitute with the 'find first line containing keyword'
" <F2>,<F3>:	compile and run shortcuts
" <F4>:			save
" <F7>:			toggle line number
" <F10>:		toggle highlight text under cursor
" <F11>:		toggle 'paste' mode
" <Ctrl-J>:		maximize the window below
" <Ctrl-K>:		maximize the window above
" <Ctrl-T>:		new tab
" <Ctrl-LEFT>:	Go to previous tab
" <Ctrl-RIGHT>:	Go to next tab

nmap <F1> [i
nmap <F2> <ESC>:w<CR>:make
nmap <F3> <ESC>:!time make run
nmap <F4> :w<CR>
nmap <F7> :set invnu<CR>
nmap <RETURN> :noh<CR>

" pressing once in normal mode changes to paste and enters insert mode
" pressing the second time disables paste
" pressing the third time change back to normal mode
" this behavior depends on how VIM intercepts pastetoggle.
nmap <F11> :set paste<CR>i
set pastetoggle=<F11>
imap <F11> <ESC>

nmap <C-T> :tabnew .<CR>
nmap <C-J> <C-W>j<C-W>_
nmap <C-K> <C-W>k<C-W>_

nmap <C-LEFT> gT
nmap <C-RIGHT> gt
nmap <C-B> <LEFT>
nmap <C-F> <RIGHT>

" quote the current word
nmap z( i(<ESC>lea)<ESC>
nmap z" i"<ESC>lea"<ESC>
nmap z' i'<ESC>lea'<ESC>
nmap z[ i[<ESC>lea]<ESC>
nmap z< i<<ESC>lea><ESC>
nmap z{ i{<ESC>lea}<ESC>

" insert variable in quotes
nmap z+ i"++"<ESC>hi
nmap z- i'++'<ESC>hi
nmap z. i'..'<ESC>hi

" for browing through ":make" results and ":grep" results, etc.
nmap <space> :cnext<CR>
nmap <backspace> :cprev<CR>

"**************************** Basic Global (Insert Mode) Mappings ****************************"
imap <C-L> <ESC>
imap <C-B> <LEFT>
imap <C-F> <RIGHT>


"**************************** Basic Global (Visual Mode) Mappings ****************************"
vmap <tab> >gv
vmap <s-tab> <gv

"**************************** SmartIndent ****************************"
au BufRead,BufNewFile *.php	set smartindent
au BufRead,BufNewFile *.js	set smartindent
au BufRead,BufNewFile *.java	set smartindent
au BufRead,BufNewFile *.pl	set smartindent

"**************************** Python ****************************"
func! SiliconPythonInit()
	" Indentation
	set softtabstop=4 tabstop=4 shiftwidth=4 smarttab expandtab autoindent
	set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
	" Compile/Run
	map <F3> :w<CR>:!time python %

	" ignore *.pyc
	set wildignore+=*.pyc

	" warn about tabs in the indentation
	highlight PythonTabIndents ctermbg=red guibg=red
	match PythonTabIndents /^\s*	/

	" hopefully make the include= thing work better
	set path+=..,../..
endfunction
au BufRead,BufNewFile *.py	call SiliconPythonInit()
"**************************** C/C++ ****************************"
" Compilation/Run (overriding global <F2>/<F3>)

func! SiliconCInit()
  set wildignore+=*.o
  map <F3> :!make run \|\| time ./%<
  " remap C-] to jump to the definition in new window
  map <C-]> <ESC>:new %<CR>:w<CR><C-W><C-W>[<C-I>
  map <F2>	:w<CR>:make

  " don't treat unrecognized strings as errors
  setlocal errorformat+=%-G%.%#
  set cindent
endfunction

au BufRead,BufNewfile *.c	call SiliconCInit()
au BufRead,BufNewfile *.cc	call SiliconCInit()
au BufRead,BufNewfile *.cpp	call SiliconCInit()
au BufRead,BufNewfile *.cxx	call SiliconCInit()
au BufRead,BufNewfile *.h	call SiliconCInit()

"**************************** Haskell ****************************"
au BufRead,BufNewFile *.hs map <F2> :w<CR>:!if [ -f Makefile ]; then make; else ghc -O % -o %<; fi
au BufRead,BufNewFile *.hs map <F3> :w<CR>:!ghci %

"**************************** Pascal ****************************"
au BufRead,BufNewFile *.pas map <F2> :w<CR>:!fpc -Cr -Co -So %
au BufRead,BufNewFile *.pas map <F3> :!time ./%<
au BufRead,BufNewFile *.pas map <F4> :w<CR>:!gpc -o %< %

"**************************** Perl ****************************"
au BufRead,BufNewFile *.pl map <F3> :w<CR>:!time perl %
au BufRead,BufNewFile *.pm map <F3> :w<CR>:!time perl %

"**************************** Javascript **************************** "
au BufRead,BufNewFile *.js	ab fx() function()
au BufRead,BufNewFile *.js	syn sync minlines=400  " attempt to fix javascript syntax problems (http://www.vim.org/tips/tip.php?tip_id=454)

"**************************** HTML/PHP ****************************"
func! SiliconHtmlAbbreviations ()
  abb htmlstrict <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
  
  abb html40 <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
  abb xhtmlstrict <?xml version="1.0"?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  abb xhtml <?xml version="1.0"?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
  syn sync minlines=400  " attempt to fix javascript syntax problems (http://www.vim.org/tips/tip.php?tip_id=454)
endfunction

au BufRead,BufNewFile *.html	call SiliconHtmlAbbreviations()
au BufRead,BufNewFile *.php		call SiliconHtmlAbbreviations()
au BufRead,BufNewFile *.jsp		call SiliconHtmlAbbreviations()
au BufRead,BufNewFile *.tt		call SiliconHtmlAbbreviations()

"**************************** Other ****************************"
au BufRead,BufNewFile *.prolog map <F3> :w<CR>:!time prolog %

"****************************** Tex ******************************"
au BufRead,BufNewFile *.tex	setlocal spell spelllang=en_us

"********************** Host Dependent Stuff *********************"
if (hostname() == "serv")
	" taglist plugins
	let Tlist_Ctags_Cmd = '/usr/bin/ctags'
	let Tlist_WinWidth = 25
	nnoremap <silent> <F8> :TlistToggle<CR>

	" vtreexplorer
	let g:treeExplVertical = 1
	function! ToggleTreeExplorer()
	  if bufexists('TreeExplorer')
		bwipeout TreeExplorer
	  else
		VSTreeExplore
	  endif
	endfunction
	map <F9>	:call ToggleTreeExplorer()<CR>
endif

"************************************* PLUGINS ************************************"
" FILE: /user/prince/Vim/Functions/Shell.vim
" AUTHOR: Janakiraman .S <prince@india.ti.com>
" Last Modified: Sat, 18 Aug 2001 10:34:07 (IST)
" Usage: Just source this file.
"        source Shell.vim
" LICENSE: No Warranties. Use at  your own risk. Add stuff to taste.
"          If you like this script type :help uganda<Enter>
"          If you want to show appreciation to the author, please
"          visit the UDAVUM KARANGAL website http://www.udavumkarangal.org/
" NOTES: Written to work with vim-5.7.

nmap \s :call InitShell()<cr>

func! InitShell ()
  if (expand("%:p:t")=="_vimshell.tmp")
    echo "Already there"
    call ShellInitSyntax()
    call PrintPrompt()
  else
    if ( bufexists ("_vimshell.tmp") )
      let a = bufwinnr("_vimshell.tmp")
      if ( a == -1 )
	sb _vimshell.tmp
	call ShellInitSyntax()
      else
	execute "normal ".a."\<C-w>w"
      endif
    else
      sp _vimshell.tmp
      call ShellInitSyntax()
    endif
    call PrintPrompt()
  endif
endfunction

func! PrintPrompt ()
  " If we had quit the window, The buffer might exist but its
  " contents are lost. Making sure there is a prompt in the last line
  " let @a = getline(".")
  let @a = getline("$")
  let foo = escape (@a,"\'")
  exec "let a = matchstr(\'".foo."\',\'".g:PROMPT."\')"
  if ( a == "" )
    if !( getline(".") == "" )
      execute "normal o"."\<Esc>"
    endif
    exec "normal "."i\<C-R>=g:PROMPT\<CR>\<Esc>"
  else
    " If the line we are on has only the prompt , place the cursor at the end.
    let @a = getline(".")
    let foo = escape (@a,"\'")
    exec "let b = matchstr(\'".foo."\',\'".g:PROMPT."\\s*$\')"
    if !( b == "" )
      normal $
    endif
  endif
  let &modified = 0
endfunction

func! ShellInitSyntax()
  if !( exists("g:PROMPT") )
    let g:PROMPT = "{Shell}"
  endif
  exec "syn match VimShellType " . "\"".g:PROMPT."\""
  exec "hi link VimShellType LineNr"
endfunction

func! ProcessEnter()
  normal 0
  normal "ayy 
  let foo = escape (@a,"\'")
  exec "let a = matchstr(\"".substitute(foo,'"','\\\"',"g")."\",\"".g:PROMPT."\")"
  " exec "let a = matchstr(\'".substitute(foo,'"','\\\"',"g")."\',\'".g:PROMPT."\')"
  " If the line does not match the prompt. It was probably the
  " output of a previously executed command. DONT execute those
  " as commands.
  if ( a == "" )
    echo "Not on the command line"
    normal j
  else
    exec "let @a = substitute(@a,\"".g:PROMPT."\",\"\",\"\")"
    if ( line(".") != line("$") )
      if ( ( @a =~ "\\w" ) && ( &modified == 0 ) )
	normal "aP
	exec "normal "."i\<C-R>=g:PROMPT\<CR>\<Esc>"
      endif
    endif
    " If the command is a cd, Change the working directory.
    let currline = 0
    if ( @a =~ "^cd\\>" )
      let @a = ":".@a
      normal @a
      if ( line(".") == line("$") )
	execute "normal o"."\<Esc>"
      endif
    " If it says clean, Clean up the screen.
    else
      if ( @a =~ "^clear\\>" )
	let @a = "ggdG"
	normal @a
      else
	if ( @a =~ "\\w" )
	  if ( @a =~ 'man' )
	    let currline = line(".")
	  else
	    let currline = 0
	  endif
	  let @a = ":r!".@a
          normal @a
          if ( line(".") == line("$") )
            execute "normal o"."\<Esc>"
          endif
	  if ( currline )
	    let lastline = line(".")
	    let Oldreport = &report
	    let &report = 10000
	    exec currline.",".lastline.'!col -b'
	    exec currline.",".lastline.'!uniq -u'
	    let &report = Oldreport
	    normal G
	  endif
	else
	  if ( line(".") == line("$") )
	    execute "normal o"."\<Esc>"
	  endif
	endif
      endif
    endif
    call PrintPrompt()
    " if ( currline )
    "   exec currline + 1
    " endif
  endif
endfunction

augroup VimShellStuff
  au!
  au BufEnter _vimshell.tmp let &swapfile=0
  au BufEnter _vimshell.tmp nnoremap <cr> :call ProcessEnter()<cr>
  au BufLeave _vimshell.tmp nun <cr>
  au BufEnter _vimshell.tmp inoremap <cr> <Esc>:call ProcessEnter()<cr>
  au BufLeave _vimshell.tmp iunmap <cr>
  au BufEnter _vimshell.tmp nm q :hide<CR>
  au BufLeave _vimshell.tmp nun q
augroup end
