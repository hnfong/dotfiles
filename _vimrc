"**************************** Basic Global Settings ****************************"
" nocp must be first
set nocompatible

" set smartcase
set autoindent
set background=dark
set backspace=2
set completeopt-=preview
set expandtab
set expandtab
set foldlevel=999999
set foldmethod=syntax
set foldminlines=4
set hls
set laststatus=2
set lazyredraw
set modeline
set modelines=3
set nojoinspaces " don't insert two spaces after special characters like '.'
set noshowmatch
set noshowmatch
set nostartofline " don't jump to line start when pgup/down etc.
set report=0
set ruler
set scrolloff=5 " scroll offset. don't have to be at top/bottom of the screen to scroll the page
set shiftwidth=4 " indentation stuff
set showcmd
set showmode
set sidescroll=1
set softtabstop=4
set splitbelow
set splitright
set t_mr=[0;1;37;41m " custom "reverse" terminal escape code
set tabstop=4
set tabstop=4
set whichwrap=<,>
set wildmenu
set wildmode=full
set winminheight=0
set winminwidth=20
set winminwidth=20
filetype indent off
syntax on

let foldtoggledefault=0

func Togglefold()
 if &foldlevel != g:foldtoggledefault
  let &foldlevel=g:foldtoggledefault
 else
  set foldlevel=999999
 endif
endfunc

" nmap \| :set errorformat=%f:%l%.%#<CR>:set makeprg=git\ grep\ -n\ 
nmap \| :set errorformat=%f:%l%m<CR>:set makeprg=git\ grep\ -n\ 

if has("gui_running")
	set shell=/bin/sh
endif

" don't treat unrecognized strings as errors (in make)
set errorformat+=%-G%.%#

" set nobomb for all files
au BufWinEnter setlocal nobomb

" workaround TERM=screen problem where some keys are not recognized (eg F[1-12] keys)
if ( $TERM == "screen" )
	set term=$REALTERM
endif

if ( $TERM == "screen" )
	set t_ts=k
	set t_fs=\
endif

set titlestring=vim:%f

if ( $TERM == "screen" )
    set t_ts=]0;
    set t_fs=
endif

set title

"**************************** Basic Global (Normal Mode) Mappings ****************************"
" <F1>:			remove the help, substitute with the 'find first line containing keyword'
" <F2>,<F3>:	compile and run shortcuts
" <F4>:			git/svn blame
" <F5>:			git/svn diff current file
" <F6>:			toggle line number
" <F7>:			toggle spellcheck
" <F10>:		toggle highlight text under cursor
" <F11>:		toggle 'paste' mode
" <Ctrl-J>:		maximize the window below
" <Ctrl-K>:		maximize the window above
" <Ctrl-T>:		new tab
" <Ctrl-LEFT>:	Go to previous tab
" <Ctrl-RIGHT>:	Go to next tab

" The unintelligble codes seem to be the ansi equivalents

nmap <F1> [I
nmap OP [I

" nmap <F1><F1> [i
" nmap OPOP [i

nmap <F2> :w<CR>:make
nmap OQ :w<CR>:make

nmap <F3> :!time make run
nmap OR :!time make run

nmap <F6> :set invnu<CR>
nmap [17~ :set invnu<CR>

nmap <F7> :set invspell<CR>
nmap [18~ :set invspell<CR>

nmap <F10> :set invhls<CR>:let @/="<C-r><C-w>"<CR>/<BS>
nmap [21~ :set invhls<CR>:let @/="<C-r><C-w>"<CR>/<BS>

nmap <F4> :Gblame<CR>
nmap OS :Gblame<CR>
nmap <F5> :Gdiff<CR>
nmap [15~ :Gdiff<CR>

set <F13>=[25~
set <F14>=[26~
set <F15>=[27~

nmap <F13> :q<CR>



nnoremap <C-c> <silent> <C-c>

" pressing once in normal mode changes to paste and enters insert mode
" pressing the second time disables paste
" pressing the third time change back to normal mode
" this behavior depends on how VIM intercepts pastetoggle.
nmap <F11> :r!pbpaste<CR>
nmap [23~ :r!pbpaste<CR>
set pastetoggle=<F11>
" imap <F11> <ESC>

" Windows and Tabs
nmap <C-T> :tabnew .<CR>
nmap <C-J> <C-W>j<C-W>_
nmap <C-K> <C-W>k<C-W>_
nmap <LEFT> <C-W>h<C-W>\|
nmap <RIGHT> <C-W>l<C-W>\|
" This is alt-= in OSX Terminal
nmap ≠ <C-W>\|
" nmap <UP> <C-W>\|
" Somehow this is too.....?
nmap <ESC>(0\|<ESC>(B <C-W>\|
nmap - 10<C-W><
nmap + 10<C-W>>
"map <UP> <C-W>k
"map <DOWN> <C-W>j

nmap <C-LEFT> gT
nmap <C-RIGHT> gt
map <C-F> :call Togglefold()<CR>

" quote the current word
nmap z( lbi(<ESC>ea)<ESC>
nmap z" lbi"<ESC>ea"<ESC>
nmap z' lbi'<ESC>ea'<ESC>
nmap z[ lbi[<ESC>ea]<ESC>
nmap z< lbi<<ESC>ea><ESC>
nmap z{ lbi{<ESC>ea}<ESC>

" insert variable in quotes
nmap z+ i"++"<ESC>hi
nmap z- i'++'<ESC>hi
nmap z. i'..'<ESC>hi

" for browing through ":make" results and ":grep" results, etc.
nmap <space> :cnext<CR>
nmap <backspace> :cprev<CR>

nmap <CR> :nohl<CR>
nmap <C-N> :vnew .<CR>

"**************************** Basic Global (Insert Mode) Mappings ****************************"
imap <C-L> <ESC>
imap <C-K> <ESC>
imap <C-B> <LEFT>
imap <C-F> <RIGHT>


"**************************** Basic Global (Visual Mode) Mappings ****************************"
vmap <tab> >gv
vmap <s-tab> <gv

"**************************** SmartIndent ****************************"
au BufRead,BufNewFile *.php	setlocal smartindent
au BufRead,BufNewFile *.java	setlocal smartindent
au BufRead,BufNewFile *.java    let foldtoggledefault=1
au BufRead,BufNewFile *.pl	setlocal smartindent

"**************************** Highlight weird stuff ****************************"
highlight TrailingSpace ctermbg=red guibg=red
highlight OverLength ctermfg=white guifg=white ctermbg=red guibg=red
highlight TabIndents ctermbg=darkmagenta guibg=darkmagenta

" func UnmatchTabIndents()
    " " For some reason, sometimes this is called more than once per loading...
    " if w:mtabindents > 0
        " call matchdelete(w:mtabindents)
    " endif
    " let w:mtabindents = -1
" endfunction

augroup highlights
    autocmd!
    au BufRead,BufNewFile * call matchadd('TrailingSpace', '\s\s*$', -1)
    au BufRead,BufNewFile * call matchadd('OverLength', '\%160v.', -1)
    au BufRead,BufNewFile * let w:mtabindents = matchadd('TabIndents', '^\s*	', -1)
    " au FileType make call UnmatchTabIndents()
    " au FileType help call UnmatchTabIndents()
augroup END

"**************************** Python ****************************"
func SiliconPythonInit()
	" Indentation
	setlocal smarttab autoindent
	setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
    filetype indent on
	" Compile/Run
	map <buffer> <F3> :w<CR>:!time python %
	map <buffer> OR :w<CR>:!time python %
    :inoremap # X#

	" ignore *.pyc
	setlocal wildignore+=*.pyc

	" warn about tabs in the indentation

	" hopefully make the include= thing work better
	setlocal path+=..,../..
endfunction
au BufRead,BufNewFile *.py	call SiliconPythonInit()
"**************************** Ruby ****************************"
func SiliconRubyInit()
    " Compile/Run
    map <buffer> <F3> :w<CR>:!time ruby %
    map <buffer> OR :w<CR>:!time ruby %
    setlocal softtabstop=2 tabstop=2 shiftwidth=2 smarttab expandtab autoindent
endfunction
au FileType ruby call SiliconRubyInit()
au BufRead,BufNewFile *.rb	call SiliconRubyInit()
"**************************** C/C++ ****************************"
" Compilation/Run (overriding global <F2>/<F3>)

func SiliconCInit()
  setlocal softtabstop=4 tabstop=4 shiftwidth=4 smarttab expandtab autoindent
  set wildignore+=*.o
  map <buffer> <F2>	:w<CR>:make
  map <buffer> OQ	:w<CR>:make
  map <buffer> <F3> :!make run \|\| time ./%<
  map <buffer> OR :!make run \|\| time ./%<
  " remap C-] to jump to the definition in new window
  " map <buffer> <C-]> <ESC>:new %<CR>:w<CR><C-W><C-W>[<C-I>

  setlocal errorformat+=%-G%.%#
  setlocal cindent
endfunction

func SiliconObjCInit()
  set wildignore+=*.o
  map <buffer> <F2>	:w<CR>:make
  map <buffer> OQ	:w<CR>:make
  " map <buffer> <F3> :!make run \|\| time ./%<
  " remap C-] to jump to the definition in new window
  " map <buffer> <C-]> <ESC>:new %<CR>:w<CR><C-W><C-W>[<C-I>

  setlocal errorformat+=%-G%.%#
  setlocal cindent
  setlocal filetype=objc " force objcpp to objc so that the objc plugin loads.
  " set syntax=objcpp
  " highlight ObjCMethods ctermfg=red
  " match ObjCMethods /\[[A-Za-z0-9][A-Za-z0-9]* [A-Za-z0-9][A-Za-z0-9]*/
  setlocal keywordprg=~/bin/vimkeywordprg
endfunction

au BufRead,BufNewfile *.c	call SiliconCInit()
au BufRead,BufNewfile *.cc	call SiliconCInit()
au BufRead,BufNewfile *.cpp	call SiliconCInit()
au BufRead,BufNewfile *.cxx	call SiliconCInit()
au BufRead,BufNewfile *.h	call SiliconCInit()
au BufRead,BufNewfile *.h	setlocal keywordprg=~/bin/vimkeywordprg

au BufRead,BufNewfile *.m call SiliconObjCInit()
au BufRead,BufNewfile *.mm call SiliconObjCInit()
"**************************** Haskell ****************************"
au BufRead,BufNewFile *.hs map <buffer> <F2> :w<CR>:!if [ -f Makefile ]; then make; else ghc -O % -o %<; fi
au BufRead,BufNewFile *.hs map <buffer> OQ :w<CR>:!if [ -f Makefile ]; then make; else ghc -O % -o %<; fi
au BufRead,BufNewFile *.hs map <buffer> <F3> :w<CR>:!ghci %
au BufRead,BufNewFile *.hs map <buffer> OR :w<CR>:!ghci %

"**************************** Pascal ****************************"
au BufRead,BufNewFile *.pas map <buffer> <F2> :w<CR>:!fpc -Cr -Co -So %
au BufRead,BufNewFile *.pas map <buffer> <F3> :!time ./%<
au BufRead,BufNewFile *.pas map <buffer> <F4> :w<CR>:!gpc -o %< %

au BufRead,BufNewFile *.pas map <buffer> OQ :w<CR>:!fpc -Cr -Co -So %
au BufRead,BufNewFile *.pas map <buffer> OR :!time ./%<
au BufRead,BufNewFile *.pas map <buffer> OS :w<CR>:!gpc -o %< %

"**************************** Perl ****************************"
au BufRead,BufNewFile *.pl map <buffer> <F3> :w<CR>:!time perl %
au BufRead,BufNewFile *.pl map <buffer> OR :w<CR>:!time perl %
au BufRead,BufNewFile *.pl set keywordprg=perldoc\ -f
au BufRead,BufNewFile *.pm map <buffer> <F3> :w<CR>:!time perl %
au BufRead,BufNewFile *.pm map <buffer> OR :w<CR>:!time perl %

"**************************** Javascript **************************** "
au BufRead,BufNewFile *.js	ab fx() function()
au BufRead,BufNewFile *.js	syn sync minlines=400  " attempt to fix javascript syntax problems (http://www.vim.org/tips/tip.php?tip_id=454)
au BufRead,BufNewFile *.js setlocal foldmethod=indent
au BufRead,BufNewfile *.js setlocal softtabstop=4 tabstop=4 shiftwidth=4 expandtab
au BufRead,BufNewFile *.js setlocal smartindent
au BufRead,BufNewfile *.js setlocal makeprg=jslint\ %
au BufRead,BufNewFile *.js let g:foldtoggledefault=1
au BufRead,BufNewFile *.js highlight LastCommaInHash ctermbg=red guibg=red
au BufRead,BufNewFile *.js match LastCommaInHash /,\_s*[}\]]/
au BufRead,BufNewFile *.js set keywordprg=~/bin/vimkeywordprg

"**************************** HTML/PHP ****************************"
func SiliconHtmlAbbreviations ()
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

"**************************** Java *****************************"
au BufRead,BufNewFile *.java    nmap <F3> :!javac % && time java %<
au BufRead,BufNewFile *.java    nmap OR :!javac % && time java %<


"**************************** Other ****************************"
au BufRead,BufNewFile *.prolog map <buffer> <F3> :w<CR>:!time prolog %
au BufRead,BufNewfile *.go	set syntax=d
au BufRead,BufNewFile *.gitlog set keywordprg=git\ show
au FileType make set noexpandtab

"****************************** Tex ******************************"
au BufRead,BufNewFile *.tex	setlocal spell spelllang=en_us

"*************************** Makefile ****************************"
au FileType make setlocal noexpandtab

"************************** Other ********************************"
au FileType gitrebase set keywordprg=git\ show
au BufRead,BufNewFile *.gitlog set keywordprg=git\ show
au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
au FileType yaml setlocal indentexpr=
au BufRead,BufNewFile *.v set filetype=vlang

"************************** Other ********************************"
au BufRead,BufNewFile *.jl setlocal syntax=julia


filetype plugin on

" au Filetype vimwiki nmap gf <Plug>VimwikiFollowLink
"
map <leader>gf :e <cfile><cr>

"********************** Host Dependent Stuff *********************"
source ~/.vim/plugin/fugitive.vim
set statusline=%f\ %h%m%r\ %<%y\ [%{&ff}]\ %{fugitive#statusline()}\ [%b,0x%B]%=Pos\ %c%V,\ Line\ %l\ of\ %L\ (%p%%)
