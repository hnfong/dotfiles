"**************************** Basic Global Settings ****************************"
" nocp must be first
set nocompatible

set autoindent
set background=dark
set backspace=2
set completeopt-=preview
set expandtab
set foldlevel=999999
set foldmethod=syntax
set foldminlines=4
set hls
set indentkeys=
set laststatus=2
set lazyredraw
set modeline
set modelines=3
set mouse= " Disable 'helpful' mouse modes
set nojoinspaces " don't insert two spaces after special characters like '.'
set noshowmatch
set nostartofline " don't jump to line start when pgup/down etc.
set report=0
set ruler
set scrolloff=5 " scroll offset. don't have to be at top/bottom of the screen to scroll the page
set shiftwidth=4 " indentation stuff
set showcmd
set showmode
set sidescroll=1
set smartcase noignorecase
set softtabstop=4
set splitbelow
set splitright
set t_mr=[0;1;37;41m " custom "reverse" terminal escape code
set tabstop=4
set whichwrap=<,>
set wildmenu
set wildmode=full
set winminheight=0
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

set titlestring=vim:%f

set title

"**************************** Basic Global (Normal Mode) Mappings ****************************"
" <F1>:			remove the help, substitute with the 'find first line containing keyword'
" <F2>,<F3>:	compile and run shortcuts
" <F4>:			git/svn blame
" <F5>:			git/svn diff current file
" <F6>:			toggle copilot
" <F8>:			toggle nvimtree(??)
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

nmap <F6> :let b:copilot_enabled = v:true

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

nmap <LEFT> <C-W>h<C-W>\|
nmap <RIGHT> <C-W>l<C-W>\|
" This is alt-= in OSX Terminal
" nmap ≠ <C-W>\|
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

iabb {tick} ✓
iabb {star} ☆
iabb {cross} ✗
"**************************** SmartIndent ****************************"
au BufRead,BufNewFile *.php	setlocal smartindent
au BufRead,BufNewFile *.java	setlocal smartindent
au BufRead,BufNewFile *.java    let foldtoggledefault=1
au BufRead,BufNewFile *.pl	setlocal smartindent

"**************************** Highlight weird stuff ****************************"
highlight TrailingSpace ctermbg=red guibg=red
highlight OverLength ctermfg=white guifg=white ctermbg=red guibg=red
highlight TabIndents ctermbg=darkmagenta guibg=darkmagenta

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
	map <buffer> <F3> :w<CR>:!time python3 %
	map <buffer> OR :w<CR>:!time python3 %
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
" Seems to be a way to follow the file under the cursor?
map <leader>gf :e <cfile><cr>

"********************** Host Dependent Stuff *********************"
source ~/.config/nvim/fugitive.vim
set statusline=%f\ %h%m%r\ %<%y\ [%{&ff}]\ %{fugitive#statusline()}\ [%b,0x%B]%=Pos\ %c%V,\ Line\ %l\ of\ %L\ (%p%%)


" NeoVIM specific stuff
"
:tnoremap <Esc> <C-\><C-n>

" https://github.com/neovim/neovim/issues/8816
autocmd TermOpen term://* startinsert

nmap <F12> :vnew<CR>:terminal<CR>
set belloff=

" https://news.ycombinator.com/item?id=33040534
" Neovim's default terminal mode bindings aren't great.
" This makes them behave like vim's.
tnoremap <Esc> <C-\><C-n><C-w>
tnoremap <C-w> <C-\><C-n><C-w>

"Always enter the terminal in insert mode
autocmd BufWinEnter,WinEnter,BufEnter term://* startinsert
autocmd TermOpen,TermEnter * startinsert
command! -nargs=0 T :vsplit | term

" " Copilot
let g:copilot_filetypes = { '*': v:false, 'py': v:true, 'python': v:true, 'rs': v:true, 'rust': v:true }

imap <silent><script><expr> <RIGHT> copilot#Accept("")
let g:copilot_no_tab_map = v:true
imap <S-LEFT> <Plug>(copilot-previous)
imap <S-RIGHT> <Plug>(copilot-next)
imap <M-RIGHT> <Plug>(copilot-suggest)

lua require('init2')


" Generated by GPT-4
function AskVisualSelection(additional_args)
    " Save the current register and clipboard settings
    let l:save_reg = getreg('"')
    let l:save_regtype = getregtype('"')
    let l:save_cb = &clipboard

    " Prevent the clipboard from interfering with the operation
    " set clipboard=exclude:.*  # This line was generated by GPT4 but it seems to be invalid. Perhaps we could set clipboard= (empty value) instead?

    " Yank the current visual selection into the unnamed register
    normal! gvy

    " Restore the clipboard settings
    let &clipboard = l:save_cb

    " Write the content of the register to a temp file
    let l:tempfile = tempname()
    call writefile(split(getreg('"'), "\n"), l:tempfile)

    " Run wc on the temp file inside a terminal buffer
    " execute 'term ask.py -f ' . l:tempfile
    " Vertically split the window and run wc on the temp file inside a terminal buffer
    execute 'vsplit | term ask.py ' . a:additional_args . ' -f ' . shellescape(l:tempfile)

    " Optionally, delete the temp file after a short delay to allow wc to read it
    " This uses the timer_start function to introduce a delay
    call timer_start(500, { tid -> execute('silent !rm ' . l:tempfile) })


    " Restore the original register content and type
    call setreg('"', l:save_reg, l:save_regtype)
endfunction


" Define a function to send the current line's byte offset to a shell command
function! SendLineOffsetToShell()
    " Get the byte offset of the current line using line2byte
    let line_offset = line2byte(line("."))

    " Check if the line_offset is -1, which indicates an error (e.g., empty buffer)
    if line_offset == -1
        echo "Error: Could not get the byte offset of the line."
        return
    endif

    " execute '!python3 -c "import os, sys; f = open(sys.argv[2], ''rb''); f.seek(int(sys.argv[1])); line = f.readline(); print(line); print(line.decode(''utf-8''))" ' . (line_offset - 1) . ' ' . shellescape(expand('%:p'))
    execute 'vsplit | term ask.py -p code_generation -f ' . shellescape(expand('%:p')) . ' ' . (line_offset - 1)
endfunction

" Optional: You can map this function to a keybinding in normal mode
" For example, to map it to <leader>l:
nnoremap <leader>l :call SendLineOffsetToShell()<CR>



xnoremap <C-K> :<C-u>call AskVisualSelection('')<CR>
xnoremap <C-P> :<C-u>call AskVisualSelection('-p code_review')<CR>
nmap <C-CR> :<C-u>call SendLineOffsetToShell()<CR>
