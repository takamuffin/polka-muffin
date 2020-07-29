call pathogen#infect()
syntax on
filetype plugin indent on

execute pathogen#infect()
syntax enable

"Settings
set ic
set colorcolumn=132
set backup
set backupdir={{ DOTFILES_HOME_DIRECTORY }}/{{ VIM_TMP_DIR }}
set swapfile
set wrap
set number
set t_Co=256

"Sets how many lines of history VIM has to remember
set history=700

"2 spaces tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set viminfo='20,<1000,s10,h
set backspace=2
set autoindent
set nocompatible
set showmatch
"Do not redraw between macros (speed)
set lazyredraw
"No beeps
set vb t_vb=
"Highlights search
set hls
"Shows line and column number at the bottom
set ruler
"Incremental search
set incsearch
"Ignore case sensitivity on searches
set ignorecase
"Shows that you are typing as command
set showcmd
"highlight current line
if v:version > 700
    set cursorline
    hi CursorLine cterm=NONE ctermbg=237
	" hi CursorLine		gui=bold,reverse	cterm=NONE ctermbg=17 guibg=17
	" hi CursorColumn gui=bold,reverse	cterm=NONE ctermbg=17 guibg=17
endif
"Statusline
set laststatus=2
"Scroll from the center
set scrolloff=1000
"Remember the last editing position
autocmd BufReadPost *
    \ if ! exists("g:leave_my_cursor_position_alone") |
    \     if line("'\"") > 0 && line ("'\"") <= line("$") |
    \         exe "normal g'\"" |
    \     endif |
    \ endif
"light solarized is blinding
set background=dark
"Solarized theme
colorscheme solarized
" Salt states are yaml
au BufRead,BufNewFile *.sls set filetype=yaml

highlight SignColumn ctermbg=0
highlight ColorColumn ctermbg=237
highlight ExtraWhitespace ctermbg=81 guibg=red

match ExtraWhitespace /\s\+$/

autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"Mappings
nnoremap ; :
nnoremap <silent> <C-l> :nohl<CR><C-l>

let g:jsx_ext_required = 0
let g:jedi#force_pycmd='python'
let g:jedi#popup_on_dot=0
let g:jedi#show_call_signatures=0
let g:gitgutter_max_signs=10000
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_lost=1
let g:syntastic_enable_signs=1
let g:sparkupExecuteMapping = '<C-e>'
let g:vim_json_syntax_conceal=0

