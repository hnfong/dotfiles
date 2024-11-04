-- * * * * * * * * * * Normal Mode Mappings * * * * * * * * * *
-- " <F1>:       remove the help, substitute with the 'find first line containing keyword'
-- " <F2>,<F3>:  compile and run shortcuts
-- " <F4>:       git/svn blame
-- " <F5>:       git/svn diff current file
-- " <F6>:       toggle copilot
-- " <F7>:       toggle spellcheck
-- " <F8>:       toggle nvimtree(??)
-- " <F9>:       telescope
-- " <F10>:      paste from macOS clipboard
-- " <F11>:      reserved (macOS uses it for showing desktop)
-- " <F12>:      open a new vertical split window with a terminal

vim.cmd [[
    " list all lines found in current and included files that contain the current word
    nmap <F1> [I

    " Saves the file and runs make
    nmap <F2> :w<CR>:make

    " Runs make run
    nmap <F3> :!time make run

    " git blame
    nmap <F4> :Gblame<CR>

    " git diff
    nmap <F5> :Gdiff<CR>

    " Toggles copilot
    nmap <F6> :let b:copilot_enabled = v:true

    " Toggles spellcheck
    nmap <F7> :set invspell<CR>

    " Toggles NvimTree
    nmap <F8> :NvimTreeToggle<CR>
    nmap <S-F8> :Portal jumplist backward<CR>

    " Opens telescope
    nmap <S-F9> :Telescope live_grep<CR>

    " Pastes from macOS clipboard
    nmap <F10> :r!pbpaste<CR>

    " Copies selected text to clipboard
    vmap <F10> :w !pbcopy<CR>

    " Opens a new vertical split window with a terminal
    nmap <F12> :vnew<CR>:terminal<CR>
    nmap <S-F12> :vnew<CR>:terminal 
]]

vim.keymap.set('n', '<F9>', require('telescope.builtin').git_files, {}) -- This is a special case that requires a function call

vim.cmd [[
    " +/- buttons increase/decrease the size of the split window by 10 units
    nmap - 10<C-W><
    nmap + 10<C-W>>

    " Ctrl-F toggles folding
    nmap <C-F> :call Togglefold()<CR>

    " for browsing through ":make" results and ":grep" results, etc.
    nmap <SPACE> :cnext<CR>
    nmap <BS> :cprev<CR>

    " Enter button removes the search highlight
    nmap <CR> :nohl<CR>

    " | will run git grep and set the errorformat to match the output
    nmap \| :set errorformat=%f:%l%m<CR>:set makeprg=git\ grep\ -n\ 

    " Move in display lines instead of actual lines for up and down
    nmap <UP> gk
    nmap <DOWN> gj
]]

-- " Left/right button moves cursor to the adjacent split window and maximizes it
-- The excessive <C-W> is an attempt to re-trigger BufEnter for terminal to make it enter insert mode.
-- The shift modifiers are to make it more consistent with the terminal mappings, where we cannot just use <LEFT> because it will make the terminal unusable
vim.api.nvim_set_keymap('n', '<LEFT>', '<C-W>h<C-W>|<C-W><C-W><C-W><C-P>', {})
vim.api.nvim_set_keymap('n', '<S-LEFT>', '<C-W>h<C-W>|<C-W><C-W><C-W><C-P>', {})
vim.api.nvim_set_keymap('n', '<RIGHT>', '<C-W>l<C-W>|<C-W><C-W><C-W><C-P>', {})
vim.api.nvim_set_keymap('n', '<S-RIGHT>', '<C-W>l<C-W>|<C-W><C-W><C-W><C-P>', {})

-- * * * * * * * * * * Visual Mode Mappings * * * * * * * * * *
vim.cmd [[
    " <tab> indents the selected text
    vmap <tab> >gv
    " <s-tab> unindents the selected text
    vmap <s-tab> <gv
]]

-- <F10> copies the selected text to the macOS clipboard as per above

-- * * * * * * * * * * Insert Mode Mappings * * * * * * * * * *

vim.cmd [[
    " type Ctrl-L and the last spelling mistake will be fixed and the cursor will hop back to where you were last typing. It's a super-fast way to fix typos -- https://www.reddit.com/r/vim/comments/1ac30kt/must_have_plugins/
    inoremap <C-L> <c-g>u<Esc>:set spell<CR>[s1z=`]a<c-g>u

    " Helpful abbreviations
    iabbrev {tick} ✓
    iabbrev {star} ☆
    iabbrev {cross} ✗
    iabbrev {robot} 🤖
]]

-- * * * * * * * * * * Termianl Mode Mappings * * * * * * * * * *
vim.cmd [[
    " https://news.ycombinator.com/item?id=33040534
    " Neovim's default terminal mode bindings aren't great.
    " This makes them behave like vim's.
    tnoremap <Esc><Esc><Esc> <C-\><C-n><C-w>
    tnoremap <C-w> <C-\><C-n><C-w>

    " The above makes it easier to switch windows by either <Esc> or <C-W> and a direction key
    " To just exit terminal mode, just double Esc(?)
    tnoremap <F12> <C-\><C-n>pA
    tnoremap <F1> <C-\><C-n><C-W>h<C-W>\|
    tnoremap <S-LEFT> <C-\><C-n><C-W>h<C-W>\|
]]
