" vim: set ft=vim ts=2 sw=2 tw=78 et :

" PRINCIPLES:
" keep vim as simple as possible
" plugins should be loaded as lazy as possible
" startup should be as fast as possible

""" read-only settings
source ~/.vread

""" MISC settings
" save and reload $MYVIMRC
nnoremap <silent> <leader>v :w<CR>:source $MYVIMRC<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
" C-j to insert a newline
nnoremap <NL> i<CR><ESC>
" refresh if file in Vim is updated by external program
noremap <silent><F5> :checktime<CR>:exe ":echo 'file refreshed'"<CR>
inoremap <silent><F5> <ESC>:checktime<CR>:exe ":echo 'file refreshed'"<CR>

""" Insert-mode keybindings
inoremap <silent><C-x>0 <C-o>:hide<CR>
inoremap <silent><C-x>1 <C-o>:hide :only<CR>
inoremap <silent><C-e> <C-o>$
inoremap <silent><C-a> <C-o>0
inoremap <silent><C-f> <Right>
inoremap <silent><C-b> <Left>
inoremap <silent><C-d> <Del>
inoremap <silent><M-n> <C-o>:cnext<CR>
inoremap <silent><M-p> <C-o>:cprevious<CR>

""" command-line mode navigation
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
cnoremap <c-d> <del>
cnoremap <silent><C-g> <ESC><ESC>

""" terminal mode
" http://vimcasts.org/episodes/neovim-terminal-mappings/
if has('nvim')
  autocmd TermOpen * tnoremap <Esc> <C-\><C-n>
  autocmd TermOpen * tnoremap <C-v><Esc> <Esc>
  highlight! link TermCursor Cursor
  highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15
end

""" append modeline
function! AppendModeline()
  let l:modeline = printf(" vim: set ft=%s ts=%d sw=%d tw=%d %set :",
        \ &filetype, &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("0"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

set ttyfast
set nojoinspaces              " no join spaces for '.', '?' and '!'
set clipboard^=unnamed,unnamedplus
set colorcolumn=
set noautowrite               " Never write a file unless I request it.
set noautowriteall            " NEVER.
set autoread                  " automatically re-read changed files.
set autowrite                 " automatically write files when switching buffers
set confirm                   " Y-N-C prompt if closing with unsaved changes.
set laststatus=2              " Always show statusline, even if only 1 window.
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y%=%-16(\ %l,%c-%v\ %)%P
set complete-=t
set formatoptions=jql
set spellfile=~/.vim/spell/en.utf-8.add
set background=light
set inccommand=split " incrementally see the updates of current commands
set cursorline

autocmd FileType c,cpp,java,markdown autocmd BufWritePre <buffer> :%s/\s\+$//e
autocmd FileType html,eruby,rb,css,js,xml runtime! macros/matchit.vim
augroup MyTermGroup
  autocmd!
  autocmd TermOpen,BufWinEnter,WinEnter term://* startinsert
augroup END

""" {{{
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/bundle')

" Plug 'Superbil/llvm.vim', {'for': 'llvm'}
" Plug 'vim-scripts/scons.vim', {'for': 'scons'}
" Plug 'tomlion/vim-solidity', {'for': 'solidity'}
" Plug 'cespare/vim-toml', {'for': 'toml'}
" Plug 'plasticboy/vim-markdown'

Plug 'voldikss/vim-translator'
let g:translator_default_engines=['youdao']
cnoreabbrev Translate TranslateW

" color schemes: default dark, optional light
Plug 'endel/vim-github-colorscheme'
" colorscheme github
colorscheme desert

Plug 'lifepillar/vim-cheat40'

Plug 'axvr/zepl.vim'

Plug 'sk1418/HowMuch'

augroup MyZeplGroup
  autocmd!
  autocmd FileType python     let b:repl_config = { 'cmd': 'python3' }
  autocmd FileType javascript let b:repl_config = { 'cmd': 'node' }
  autocmd FileType clojure    let b:repl_config = { 'cmd': 'clj' }
  autocmd FileType scheme     let b:repl_config = { 'cmd': 'rlwrap csi' }
  autocmd FileType lisp       let b:repl_config = { 'cmd': 'sbcl' }
  autocmd FileType julia      let b:repl_config = { 'cmd': 'julia' }
augroup END

" tag list
Plug 'majutsushi/tagbar'

"vim-g
Plug 'szw/vim-g'
let g:vim_g_f_command = "Gf"
let g:vim_g_command = "Go"

Plug 'editorconfig/editorconfig-vim'
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*', 'term://.*']
let g:EditorConfig_preserve_formatoptions=1

" enhanced netrw
Plug 'tpope/vim-vinegar'
" enhance Vim UNIX experience
Plug 'tpope/vim-eunuch'
" git relevant
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'
autocmd BufReadPost fugitive://* set bufhidden=delete
set statusline^=%{fugitive#statusline()}
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'
" enhance on surroundings
Plug 'tpope/vim-surround'
" pairs
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<M-b>'

Plug 'tpope/vim-commentary'
autocmd FileType cmake setl cms=#%s
autocmd FileType gdb setl cms=#%s
autocmd FileType c setl cms=//%s
autocmd FileType cpp setl cms=//%s
autocmd FileType lisp setl cms=;;%s
autocmd FileType scala setl cms=//%s
autocmd FileType tablegen setl cms=//%s
autocmd FileType unix setl cms=#%s
autocmd FileType xdefaults setl cms=!%s
autocmd FileType apache setlocal commentstring=#\ %s

Plug 'tpope/vim-scriptease'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
let g:fzf_buffers_jump = 1

Plug 'w0rp/ale'
let g:ale_sign_column_always = 1
let g:ale_sign_error = 'x'
let g:ale_sign_warning = '!'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_keep_list_window_open = 0
" let g:ale_open_list = 1
let g:ale_linters = {
      \   'csh': ['shell'],
      \   'elixir': ['credo', 'dialyxir', 'dogma'],
      \   'go': ['gofmt', 'golint', 'go vet'],
      \   'hack': ['hack'],
      \   'help': [],
      \   'perl': ['perlcritic'],
      \   'perl6': [],
      \   'python': [],
      \   'rust': ['cargo'],
      \   'spec': [],
      \   'text': [],
      \   'vue': ['eslint', 'vls'],
      \   'zsh': ['shell'],
      \}

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'cespare/vim-toml'

""" latex
Plug 'lervag/vimtex'
Plug 'mhinz/neovim-remote'
let g:vimtex_compiler_progname='nvr'
let g:vimtex_quickfix_open_on_warning = 0
if g:os == 'Darwin'
  let g:vimtex_view_general_viewer = 'open'
else
  let g:vimtex_view_general_viewer = 'atril'
endif
let g:vimtex_quickfix_latexlog = {'default' : 0}
set conceallevel=1
let g:tex_conceal='abdmg'
let g:vimtex_compiler_callback_hooks = ['MyTestHook']
let g:tex_flavor = 'latex'
function! MyTestHook(status)
  echom a:status
endfunction

Plug 'AndrewRadev/splitjoin.vim'
" alignment
Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" Chinese typesetting
Plug 'hotoo/pangu.vim'

" for testing
Plug 'junegunn/vader.vim'

call plug#end()
""" }}}

""" always follow symlink {{{
" https://github.com/blueyed/dotfiles/blob/ab2850675bbfcf0db18dbf81a31b90e65aaae7f8/vimrc#L1247-L1278
function! MyFollowSymlink(...)
  if exists('w:no_resolve_symlink') && w:no_resolve_symlink
    return
  endif
  let fname = a:0 ? a:1 : expand('%')
  if fname =~ '^\w\+:/'
    " Do not mess with 'fugitive://' etc.
    return
  endif
  let fname = simplify(fname)

  let resolvedfile = resolve(fname)
  if resolvedfile == fname
    return
  endif
  let resolvedfile = fnameescape(resolvedfile)
  let sshm = &shm
  set shortmess+=A  " silence ATTENTION message about swap file (would get displayed twice)
  exec 'file ' . resolvedfile
  let &shm=sshm

  " Re-init fugitive.
  call FugitiveDetect(resolvedfile)
  if &modifiable
    " Only display a note when editing a file, especially not for `:help`.
    redraw  " Redraw now, to avoid hit-enter prompt.
    echomsg 'Resolved symlink: =>' resolvedfile
  endif
endfunction
command! FollowSymlink call MyFollowSymlink()
command! ToggleFollowSymlink let w:no_resolve_symlink = !get(w:, 'no_resolve_symlink', 0) | echo "w:no_resolve_symlink =>" w:no_resolve_symlink
au BufReadPost * nested call MyFollowSymlink(expand('%'))
""" }}}

""" configurations for coc {{{
set nobackup
" Some servers have issues with backup files, see #649
set nowritebackup
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=400
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>ShowDocumentation()<CR>

function! s:ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup MyCocGroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
""" }}}

" forbid simultaneous edits; make it default to readonly
augroup MySwapEditGroup
  autocmd!
  autocmd SwapExists * let v:swapchoice = 'o'
  autocmd SwapExists * echo 'Duplicate edit session (readonly)'
  autocmd SwapExists * setlocal nomodifiable
  autocmd SwapExists * echohl None
augroup END

cnoreabbrev mks exec printf('mksession! %s%s%s', "~/.vim/ss-", strftime("%Y-%b-%d-%H-%M-%S"), ".vim")
cnoreabbrev mksession exec printf('mksession! %s%s%s', "~/.vim/ss-", strftime("%Y-%b-%d-%H-%M-%S"), ".vim")

""" questions:
" disable undo from certain checkpoint
" disable certain command line mode commands
