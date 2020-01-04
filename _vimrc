"vim: set ft=vim ts=4 sw=2 tw=78 et :

" PRINCIPLES:
" keep vim as simple as possible
" plugins should be loaded as lazy as possible
" startup should be as fast as possible

source ~/.vread

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" save and reload ~/.vimrc
nnoremap <silent> <leader>v :w<CR>:source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
vnoremap <leader>vs y:@"<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set clipboard^=unnamed,unnamedplus
nnoremap <leader>p :set paste! <CR>
" C-j to insert a newline
nnoremap <NL> i<CR><ESC>
" remap D to remove line without x register, anyway I have cc
nnoremap D "_dd
vnoremap D "_d
" refresh if file in Vim is updated by external program,TODO
noremap <silent><F5> :checktime<CR>:exe ":echo 'file refreshed'"<CR>
inoremap <silent><F5> <C-O>:checktime<CR>:exe ":echo 'file refreshed'"<CR>
" substitute word under cursor with ...
nnoremap <Leader>S :%s/\<<C-r><C-w>\>/

" emacs like settings(insert mode)
inoremap <silent><C-x>0 <C-o>:hide<CR>
inoremap <silent><C-x>1 <C-o>:hide :only<CR>
inoremap <silent><C-x>k <C-o>:bd<CR>
inoremap <silent><C-x><C-s> <C-o>:w<CR><C-o>:exe ":echo 'saved' bufname(\"%\")"<CR>
inoremap <silent><C-x>s <C-o>:wall<CR>
inoremap <silent><C-x>i <C-o>:read<Space>
inoremap <silent><C-x><C-w> <C-o>:write<Space>
inoremap <silent><C-x><C-q> <C-o>:set invreadonly<CR>
inoremap <silent><C-x><C-c> <C-o>:wqall<CR>
inoremap <silent><C-x><C-J> <C-o>:e.<CR>
inoremap <silent><C-e> <C-o>$
inoremap <silent><C-a> <C-o>0
inoremap <silent><C-f> <Right>
inoremap <silent><C-b> <Left>
inoremap <silent><C-d> <Del>
inoremap <silent><M-n> <C-o>:cnext<CR>
inoremap <silent><M-p> <C-o>:cprevious<CR>

" terminal mode
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-v><Esc> <Esc>
  highlight! link TermCursor Cursor
  highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15
end

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" append modeline
function! AppendModeline()
  let l:modeline = printf(" vim: set ft=%s ts=%d sw=%d tw=%d %set :",
        \ &filetype, &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("0"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

set ttyfast
set colorcolumn=
set noautowrite               " Never write a file unless I request it.
set noautowriteall            " NEVER.
set autoread                  " automatically re-read changed files.
set confirm                   " Y-N-C prompt if closing with unsaved changes.
set laststatus=2              " Always show statusline, even if only 1 window.
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y%=%-16(\ %l,%c-%v\ %)%P
set complete-=t
set formatoptions=jql

autocmd FileType c,cpp,java,markdown autocmd BufWritePre <buffer> :%s/\s\+$//e
autocmd FileType html,eruby,rb,css,js,xml runtime! macros/matchit.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/bundle')

" Plug 'Superbil/llvm.vim', {'for': 'llvm'}
" Plug 'vim-scripts/scons.vim', {'for': 'scons'}
" Plug 'tomlion/vim-solidity', {'for': 'solidity'}
" Plug 'cespare/vim-toml', {'for': 'toml'}
" Plug 'plasticboy/vim-markdown'
Plug 'tell-k/vim-autopep8', {'for': 'python'}
autocmd FileType python set equalprg=autopep8\ -

"vim-g
Plug 'szw/vim-g'
let g:vim_g_f_command = "Gf"
let g:vim_g_command = "Go"

Plug 'editorconfig/editorconfig-vim'
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

Plug 'tpope/vim-obsession'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

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

Plug 'jremmen/vim-ripgrep'

Plug 'majutsushi/tagbar'
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tagbar
noremap <leader>t :TagbarToggle<CR>
let g:tagbar_autoclose=0
let g:tagbar_left = 1
let g:tagbar_width = 31
let g:tagbar_autofocus = 0
let g:tagbar_sort = 1
let g:tagbar_compact = 1
let g:tagbar_expand = 0
let g:tagbar_singleclick = 0
let g:tagbar_foldlevel = 5
let g:tagbar_autoshowtag = 0
let g:tagbar_updateonsave_maxlines = 10000
let g:tagbar_systemenc = 'encoding'
let g:tagbar_type_rust = {
      \ 'ctagstype' : 'rust',
      \ 'kinds' : [
      \'T:types,type definitions',
      \'f:functions,function definitions',
      \'g:enum,enumeration names',
      \'s:structure names',
      \'m:modules,module names',
      \'c:consts,static constants',
      \'t:traits,traits',
      \'i:impls,trait implementations',
      \]
      \}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plug 'mhinz/vim-startify'
let g:startify_custom_header = []
let g:startify_change_to_vcs_root = 1
let g:startify_enable_unsafe = 1
let g:startify_update_oldfiles = 1
let g:startify_files_number = 20
let g:startify_enable_special = 0

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
" let g:ale_open_list = 1
" let g:ale_keep_list_window_open = 1

if g:os != 'Darwin'
  Plug 'Valloric/YouCompleteMe'
  " Plug 'rdnetto/YCM-Generator', { 'branch': 'stable', 'for': 'c'}
endif

" color schemes
" Plug 'jacoborus/tender.vim'
" Plug 'tomasr/molokai'
" Plug 'd11wtq/macvim256.vim'

" latex
Plug 'lervag/vimtex'
Plug 'mhinz/neovim-remote'
let g:vimtex_compiler_progname='nvr'
let g:vimtex_quickfix_open_on_warning = 0
set conceallevel=1
let g:tex_conceal='abdmg'

Plug 'AndrewRadev/splitjoin.vim'
" Plug 'godlygeek/tabular'
" Plug 'tommcdo/vim-lion'
Plug 'junegunn/vim-easy-align'

Plug 'hotoo/pangu.vim'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if g:os == "Darwin"
  let g:ycm_path_to_python_interpreter='/usr/local/bin/python2'
else
  let g:ycm_path_to_python_interpreter='/usr/bin/python3'
endif
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_add_preview_to_completeopt=1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_min_num_of_chars_for_completion = 99
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_auto_trigger = 1
let g:ycm_collect_identifiers_from_tags_files = 0 " Let YCM read tags from Ctags file
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string
let g:ycm_rust_src_path = $RUST_SRC_PATH
let g:ycm_filetype_specific_completion_to_disable = {
      \ 'rust': 1
      \}
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'qf' : 1,
      \ 'notes' : 1,
      \ 'markdown' : 1,
      \ 'unite' : 1,
      \ 'text' : 1,
      \ 'vimwiki' : 1,
      \ 'gitcommit' : 1,
      \ 'rust' : 1,
      \}

" set shell=/usr/bin/bash

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set spellfile=~/.vim/spell/en.utf-8.add
" if g:os == "Darwin"
"   set background=light
"   colorscheme macvim256
" else
"   colorscheme molokai
" endif
