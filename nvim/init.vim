"**************************** Basic Global Settings ****************************"

set autoindent
set background=dark
set backspace=2
set completeopt-=preview
set expandtab
set foldlevel=999999
set foldmethod=syntax
set foldminlines=4
set hlsearch
" set indentkeys=
set laststatus=2
set lazyredraw
set modeline
set modelines=3
set mouse= " Disable 'helpful' mouse modes
set notermguicolors
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
set signcolumn=no
set smartcase noignorecase
set softtabstop=4
set spelllang=en_us
set splitbelow
set splitright
set t_mr=[0;1;37;41m " custom "reverse" terminal escape code
set tabstop=4
set whichwrap=<,>
set wildmenu
set wildmode=full
set winminheight=0
set winminwidth=20
colorscheme vim

let foldtoggledefault=0

func Togglefold()
 if &foldlevel != g:foldtoggledefault
  let &foldlevel=g:foldtoggledefault
 else
  set foldlevel=999999
 endif
endfunc

if has("gui_running")
	set shell=/bin/sh
endif

" set nobomb for all files (byte order mark)
au BufWinEnter setlocal nobomb

set titlestring=vim:%f

set title
autocmd BufEnter,BufNewFile * call system("tmux rename-window nvim:". expand('%:t'))


" https://askubuntu.com/questions/223018/vim-is-not-remembering-last-position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


"**************************** SmartIndent ****************************"
au BufRead,BufNewFile *.php	setlocal smartindent
au BufRead,BufNewFile *.java	setlocal smartindent
au BufRead,BufNewFile *.java	lua map_keyword_button_to_telescope()
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
augroup END

"**************************** Python ****************************"
func SiliconPythonInit()
	" Indentation
	setlocal smarttab autoindent
	setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
    filetype indent on
	" Compile/Run
	map <buffer> <S-F3> :w<CR>:!time python3 %
	map <buffer> <F3> :w<CR>:vsplit \| terminal python3 %
    :inoremap # X#

	" ignore *.pyc
	setlocal wildignore+=*.pyc

	" warn about tabs in the indentation

	" hopefully make the include= thing work better
	setlocal path+=..,../..

  " edit retriggers stuff regarding reloading the file...
  nmap <F7> :lua LspConfigManualTrigger()<CR>:edit<CR>
  nmap <S-F7> :!ruff check --fix %
endfunction
au BufRead,BufNewFile *.py	call SiliconPythonInit()
au FileType python call SiliconPythonInit()


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

  " don't treat unrecognized strings as errors (in make)
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

  " don't treat unrecognized strings as errors (in make)
  setlocal errorformat+=%-G%.%#
  setlocal cindent
  setlocal filetype=objc " force objcpp to objc so that the objc plugin loads.
  " set syntax=objcpp
  " highlight ObjCMethods ctermfg=red
  " match ObjCMethods /\[[A-Za-z0-9][A-Za-z0-9]* [A-Za-z0-9][A-Za-z0-9]*/
  lua map_keyword_button_to_telescope()
endfunction

func SiliconRustInit()
  lua map_keyword_button_to_telescope()
  map <buffer> <F2>	:w<CR>:make build
  nmap <F2> :w<CR>:make build

  " edit retriggers stuff regarding reloading the file...
  nmap <F7> :lua LspConfigManualTrigger()<CR>:edit<CR>
endfunction

au BufRead,BufNewfile *.c	call SiliconCInit()
au BufRead,BufNewfile *.cc	call SiliconCInit()
au BufRead,BufNewfile *.cpp	call SiliconCInit()
au BufRead,BufNewfile *.cxx	call SiliconCInit()
au BufRead,BufNewfile *.h	call SiliconCInit()
au BufRead,BufNewfile *.h	lua map_keyword_button_to_telescope()

au BufRead,BufNewfile *.rs	call SiliconRustInit()

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
au BufRead,BufNewFile *.js lua map_keyword_button_to_telescope()
  " edit retriggers stuff regarding reloading the file...
au BufRead,BufNewFile *.js nmap <F7> :lua LspConfigManualTrigger()<CR>:edit<CR>
au BufRead,BufNewFile *.js nmap <S-F7> :!ruff check --fix %

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

au BufRead,BufNewFile *.gitlog set keywordprg=git\ show
au BufRead,BufNewFile *.jl setlocal syntax=julia
au BufRead,BufNewFile *.prolog map <buffer> <F3> :w<CR>:!time prolog %
au BufRead,BufNewFile *.v set filetype=vlang
au BufRead,BufNewfile *.go	set syntax=d
au FileType gitrebase set keywordprg=git\ show
au FileType make set noexpandtab
au FileType yaml setlocal indentexpr=
au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

"****************************** Tex ******************************"
au BufRead,BufNewFile *.tex	setlocal spell spelllang=en_us
au BufRead,BufNewFile *.ly	setlocal syntax=tex
au BufRead,BufNewFile *.ly	nmap <F2> :!lilypond %
au BufRead,BufNewFile *.ly	nmap <F3> :!xpdf %<.pdf

"*************************** Makefile ****************************"
au FileType make setlocal noexpandtab

"*************************** Markdown ****************************"

function! MarkdownFolds()
    " Get the current line number
    let lnum = v:lnum
    " Loop from the current line upwards until we find a header or reach the start
    while lnum > 0
        let line = getline(lnum)
        " if line =~ '^\s*$' && lnum > 1 && getline(lnum - 1) =~ '^#'
        "     return 0
        " endif

        " Don't fold if the line is a separator
        if line =~ '^---'
            return 0
        endif

        if line =~ '^#'
            let level = matchend(line, '# ')
            " echomsg 'level ' . level
            if lnum == v:lnum
                return level - 1
            endif
            return level
        endif

        " Actually, we just return 999999 for non-header lines instead of
        " looping. You can comment out this line to revert to the original
        " behavior
        return 999999

        let lnum -= 1
    endwhile

    " If no header is found, do not fold
    return '0'

endfunction
" au FileType markdown setlocal spell
au FileType markdown setlocal foldexpr=MarkdownFolds()
au FileType markdown setlocal foldmethod=expr
au FileType markdown setlocal foldminlines=2
au FileType markdown let g:foldtoggledefault=3
au FileType markdown setlocal smartcase ignorecase


"****************************** Swift ******************************"
au BufRead,BufNewFile *.swift lua map_keyword_button_to_telescope()


"********************** Host Dependent Stuff *********************"
set statusline=%f\ %h%m%r\ %<%y\ [%{&ff}]\ %{fugitive#statusline()}\ [%b,0x%B]%=Pos\ %c%V,\ Line\ %l\ of\ %L\ (%p%%)

" Don't extend the comments when entering insert mode with newline (o in
" command mode)
autocmd FileType * setlocal formatoptions-=o


set belloff=

" Always enter the terminal in insert mode
" See https://github.com/neovim/neovim/issues/8816 and nvim help in :terminal
" This ensures that all entering events related to terminals will result in
" startinsert. The two separate lines are needed because otherwise ALL
" BufEnter events (for non-terminals) will also trigger insert mode
" The function ensures that if the Process has exited, we don't force insert
" mode and somehow trigger nvim to close the window. (We want to remain in
" normal (command) mode for movement and selection anyway)

function! StartInsertIfTerminalNotFinished()
    if &buftype ==# 'terminal'
        let buffer_content = join(getbufline(bufnr(), '$', '$'), '\n')
        if buffer_content !~# 'Process exited'
            startinsert
        endif
    endif
endfunction

autocmd BufWinEnter,WinEnter,BufEnter term://* call StartInsertIfTerminalNotFinished()
autocmd TermOpen,TermEnter * call StartInsertIfTerminalNotFinished()


" https://vi.stackexchange.com/questions/17816/solved-ish-neovim-dont-close-terminal-buffer-after-process-exit
autocmd TermClose * call feedkeys("\<C-\>\<C-n>")

" Defines a new 'T' command that opens a new term (obsolete?)
command! -nargs=0 T :vsplit | term

lua require('init2')
" load keysmaps.lua
lua require('keymaps')

" " Copilot
" let g:copilot_filetypes = { '*': v:false, 'py': v:true, 'python': v:true, 'rs': v:true, 'rust': v:true, 'html': v:true, 'vim': v:true }
let g:copilot_filetypes = { '*': v:false }
let g:copilot_no_tab_map = v:true

imap <silent><script><expr> <RIGHT> copilot#Accept("")
imap <S-LEFT> <Plug>(copilot-previous)
imap <S-RIGHT> <Plug>(copilot-next)
imap <M-RIGHT> <Plug>(copilot-suggest)



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
    execute 'vsplit  | vertical resize +50 | term ask.py -v -t 0.3 -c 8192 ' . a:additional_args . ' -f ' . shellescape(l:tempfile)

    " Optionally, delete the temp file after a short delay to allow wc to read it
    " This uses the timer_start function to introduce a delay
    call timer_start(500, { tid -> execute('silent !rm ' . l:tempfile) })


    " Restore the original register content and type
    call setreg('"', l:save_reg, l:save_regtype)
endfunction


" Define a function to send the current line's byte offset to a shell command
function! SendLineOffsetToShell()
    " Save the file first
    execute 'w'


    " Get the byte offset of the current line using line2byte
    let line_offset = line2byte(line("."))

    " Check if the line_offset is -1, which indicates an error (e.g., empty buffer)
    if line_offset == -1
        echo "Error: Could not get the byte offset of the line."
        return
    endif

    " execute 'vsplit | term ask.py -c 8192 -p code_generation -f ' . shellescape(expand('%:p')) . ' ' . (line_offset - 1)
    " Run as 'r!' instead of vsplitting a term
    execute 'r!ask.py -c 8192 -p code_generation -f ' . shellescape(expand('%:p')) . ' ' . (line_offset - 1)

endfunction

" Optional: You can map this function to a keybinding in normal mode
" For example, to map it to <leader>l:
nnoremap <leader>l :call SendLineOffsetToShell()<CR>

nnoremap <C-K> ggVG:<C-u>call AskVisualSelection('-p ask_user')<CR>
xnoremap <C-K> :<C-u>call AskVisualSelection('-p ask_user')<CR>
xnoremap <C-P> :<C-u>call AskVisualSelection('-p code_review')<CR>
nmap <C-CR> :<C-u>call SendLineOffsetToShell()<CR>

source ~/.config/nvim/fugitive.vim
