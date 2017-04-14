" dotvIMRc by Gaël Chamoulaud <gchamoul@redhat.com>

" => Settings {{{

" ==> Vim-plug {{{
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'beloglazov/vim-online-thesaurus'
Plug 'benmills/vimux'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'dagwieers/asciidoc-vim'
Plug 'davidhalter/jedi-vim'
Plug 'dbakker/vim-lint'
Plug 'duff/vim-scratch'
Plug 'ervandew/supertab'
Plug 'FooSoft/vim-argwrap'
Plug 'garbas/vim-snipmate'
Plug 'gcmt/wildfire.vim'
Plug 'Glench/Vim-jinja2-Syntax'
Plug 'godlygeek/csapprox'
Plug 'godlygeek/tabular'
Plug 'honza/vim-snippets'
Plug 'jmcantrell/vim-virtualenv'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kien/ctrlp.vim'
Plug 'ktonga/vim-follow-my-lead'
Plug 'Lokaltog/vim-easymotion'
Plug 'majutsushi/tagbar'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'mileszs/ack.vim'
Plug 'miyakogi/conoline.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'nvie/vim-flake8'
Plug 'pbrisbin/vim-mkdir'
Plug 'pearofducks/ansible-vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree' , { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/syntastic'
Plug 'Shougo/neocomplete.vim'
Plug 'sjl/splice.vim'
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/autocorrect.vim'
Plug 'vim-scripts/bash-support.vim'
Plug 'vim-scripts/BufOnly.vim'
Plug 'vim-scripts/Tabmerge'
Plug 'vim-scripts/taglist.vim'
Plug 'vim-scripts/TextFormat'
Plug 'vim-scripts/unimpaired.vim'
Plug 'vim-scripts/vimwiki'
Plug 'wellle/targets.vim'
Plug 'wikitopian/hardmode'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'Yggdroot/indentLine'
"Plug 'morhetz/gruvbox'
"Plug '907th/vim-auto-save'
"Plug 'chriskempson/vim-tomorrow-theme'
"Plug 'vim-scripts/TaskList.vim'
"Plug 'chriskempson/vim-tomorrow-theme'
"Plug '907th/vim-auto-save'
"Plug 'Shougo/unite.vim'
"Plug 'flazz/vim-colorschemes'
"Plug 'junegunn/vim-github-dashboard'
"Plug 'KabbAmine/vCoolor.vim'
"Plug 'kien/rainbow_parentheses.vim'
"Plug 'mattn/emmet-vim'
"Plug 'mmozuras/vim-github-comment'
"Plug 'Quramy/vison'
"Plug 'rodjek/vim-puppet'
"Plug 'sjl/gundo.vim'
"Plug 'skammer/vim-css-color'
"Plug 't9md/vim-choosewin'
"Plug 'vim-ruby/vim-ruby'
"Plug 'vim-scripts/DrawIt'
"Plug 'vim-scripts/TaskList.vim'
"Plug 'vim-scripts/ZoomWin'
call plug#end()
" }}}

syntax on

" UTF encoding
set fenc=utf-8
scriptencoding utf-8
set encoding=utf-8
set termencoding=utf-8

" Use vim, not vi api
set nocompatible

" No backup files
set nobackup

set path+=**

" No write backup
set nowritebackup

" No swap file
set noswapfile

" Turn word wrap off
set nowrap

set updatetime=250

" Allow backspace to delete end of line, indent and start of line characters
set backspace=indent,eol,start

" Convert tabs to spaces
set expandtab

" Set tab size in spaces (this is for manual indenting)
set tabstop=4

" The number of spaces inserted for a tab (used for auto indenting)
set shiftwidth=4

" Turn on line numbers
set number

" Get rid of the delay when pressing O (for example)
" http://stackoverflow.com/questions/2158516/vim-delay-before-o-opens-a-new-line
set timeout timeoutlen=1000 ttimeoutlen=100

" Always show status bar
set laststatus=2

set pastetoggle=<F2>

" Invisible characters
map \ :set invlist<CR>
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:␣
set showbreak=↪

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=1200

" Use only 1 space after "." when joining lines instead of 2
set nojoinspaces

" Don't reset cursor to start of line when moving around
set nostartofline

" Use system clipboard
" http://stackoverflow.com/questions/8134647/copy-and-paste-in-vim-via-keyboard-between-different-mac-terminals
set clipboard+=unnamed

" Enable the mouse in all four modes
set mouse=a

" Better splits (new windows appear below and to the right)
set splitbelow
set splitright

" Command history
set history=700

" Maximum number of changes that can be undone.
set undolevels=700

" Show incomplete commands
set showcmd

" Incremental searching (search as you type)
set incsearch

" Highlight search matches
set hlsearch

" Ignore case in search
set smartcase

" Make sure any searches /searchPhrase doesn't need the \c escape character
set ignorecase

" A buffer is marked as ‘hidden’ if it has unsaved changes, and it is not
" currently loaded in a window if you try and quit Vim while there are hidden
" buffers, you will raise an error: E162: No write since last change for buffer
" “a.txt”
set hidden

" Highlight the current line
set cursorline

" Only show cursorline in the current window and in normal mode.
augroup cline
    au!
    au WinLeave * set nocursorline
    au WinEnter * set cursorline
    au InsertEnter * set nocursorline
    au InsertLeave * set cursorline
augroup END

" Ensure Vim doesn't beep at you every time you make a mistype
set visualbell

" Visual autocomplete for command menu (e.g. :e ~/path/to/file)
set wildmenu

" redraw only when we need to (i.e. don't redraw when executing a macro)
set lazyredraw

" highlight a matching [{()}] when cursor is placed on start/end character
set showmatch

" Set built-in file system explorer to use layout similar to the NERDTree plugin
let g:netrw_style=3

" Always highlight column 80 so it's easier to see where
" cutoff appears on longer screens
set colorcolumn=80

" Round indent to multiple of 'shiftwidth'
set shiftround

" Always show status bar
set laststatus=2

" Set the status line to something useful
set statusline=%f\ %=L:%l/%L\ %c\ (%p%%)

" If in Insert, Replace or Visual mode, don't put a message on the last line.
set noshowmode

if v:version >= 700
  set viminfo=!,'20,<50,s10,h
endif

if has('cmd_info')
    " Always show the current cursor position
    set ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " taken from spf13-vim

    " Show partial commands in statusline and selected chars/lines in
    " visual mode
    set showcmd
endif

" => Scrolling {{{
" Start scrolling when we are 8 lines away from margins
set scrolloff=8

" Minimum lines to keep above and below
set sidescrolloff=15

" Lines to scroll when cursor leaves screen
set scrolljump=5
set sidescroll=1

" }}}

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Using par program for formatting paragraph
set formatprg=par\ -w80q
set formatoptions+=t

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %
" }}}
" => Plugins {{{

filetype off
filetype plugin indent on

" Theme
set t_Co=256
set bg=dark
colorscheme PaperColor
"hi Normal ctermbg=none
"hi NonText ctermbg=none
hi ColorColumn cterm=none ctermfg=none ctermbg=236

" Allow to trigger background
function! ToggleBG()
    let s:tbg = &background
    " Inversion
    if s:tbg == "dark"
        set background=light
    else
        set background=dark
    endif
endfunction
noremap <leader>bg :call ToggleBG()<CR>

" My Map Leader
let mapleader = "\<Space>"

" Airline (status line)
let g:airline_powerline_fonts = 1
let g:airline_theme='minimalist'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1

let g:ansible_attribute_highlight = "ob"
let g:ansible_name_highlight = 'd'
let g:ansible_extra_keywords_highlight = 1

nmap <F5> :TagbarToggle<CR>

" ctrlp config
let g:ctrlp_map = '<leader>p'
let g:ctrlp_max_height = 30
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_history = 50
map <Leader>u :CtrlPMRU<CR>

set wildignore+=*.pyc,*.o,*.obj
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=*_build/*
set wildignore+=*/coverage/*

nmap <F3> :NERDTreeToggle<CR>
map <Leader>` :NERDTreeTabsFind<CR>
let g:NERDTreeShowBookmarks=0
let g:NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
let g:NERDTreeChDirMode=0
let g:NERDTreeQuitOnOpen=0
let g:NERDTreeShowHidden=1
let g:NERDTreeKeepTreeInNewTab=1
let g:NERDTreeWinSize = 30

map <F10> :SyntasticToggleMode<CR>
let g:syntastic_enable_signs=1
let g:syntastic_auto_jump=0
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=0
let g:syntastic_error_symbol='E'
let g:syntastic_warning_symbol='W'
let g:syntastic_check_on_wq=0
let g:syntastic_check_on_open=0
let g:syntastic_enable_perl_checker = 1
let g:syntastic_sh_shellcheck_checker = 1
let g:syntastic_sh_checkers = ['bashate', 'shellcheck']

let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#show_call_signatures = "2"

let g:conoline_auto_enable = 1
let g:conoline_use_colorscheme_default_normal=1
let g:conoline_use_colorscheme_default_insert=1

let g:vimwiki_ = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

let g:notes_directories = ['~/Documents/Notes']

" Private Gist by default
let g:gist_post_private = 1

" SnipMate Options
let g:snips_author = 'Gaël Chamoulaud'
let g:snips_email = 'gchamoul@redhat.com'
let g:snips_github = 'https://github.com/strider'

" Github Comments
let g:github_user = 'strider'

let g:github_dashboard = { 'username': 'strider' }

let g:splice_prefix = "<leader>t"

" Git gutter
let g:gitgutter_enabled = 1
let g:gitgutter_eager = 0
let g:gitgutter_sign_column_always = 1
let g:gitgutter_sign_added = '++'
let g:gitgutter_sign_modified = '--'
let g:gitgutter_sign_removed = 'xx'
let g:gitgutter_sign_modified_removed = 'ww'
highlight clear SignColumn

let Tlist_Show_Menu = 1
let Tlist_Auto_Update = 1
let Tlist_Use_Right_Window = 1
let Tlist_Show_One_File = 1

" IdentLine
let g:indentLine_char = '┆'
let g:indentLine_color_term = 184
let g:indentLine_enabled = 1

let g:tmux_navigator_no_mappings = 0

nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\\> :TmuxNavigatePrevious<cr>

nmap <leader>gv :GV<cr>

map <Leader>rc :VimuxPromptCommand<CR>
map <Leader>rl :VimuxRunLastCommand<CR>

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0

let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

nnoremap <leader>rp <Esc>:call ToggleHardMode()<CR>

" }}}
" => Mappings {{{
" Removes highlight of your last search
nmap <silent> <leader>; :silent :nohlsearch<CR>

" Bind tabnew
nmap T :tabnew<CR>

nmap <leader>q :split ~/.buffer<cr>
nmap <leader>v :tabnew $HOME/.vim/vimrc<CR>
nnoremap <leader>ev <C-w>s<C-w>j:e $MYVIMRC<cr>
nnoremap <leader>eg <C-w>s<C-w>j:e ~/.gitconfig<cr>
nnoremap <leader>ez <C-w>s<C-w>j:e ~/.zshrc<cr>
nnoremap <leader>et <C-w>s<C-w>j:e ~/.tmux.conf<cr>

" window
nmap <leader>sw<left>  :topleft  vnew<CR>
nmap <leader>sw<right> :botright vnew<CR>
nmap <leader>sw<up>    :topleft  new<CR>
nmap <leader>sw<down>  :botright new<CR>
" buffer
nmap <leader>s<left>   :leftabove  vnew<CR>
nmap <leader>s<right>  :rightbelow vnew<CR>
nmap <leader>s<up>     :leftabove  new<CR>
nmap <leader>s<down>   :rightbelow new<CR>

"" Quicksave command
noremap <C-Z> :update<CR>
vnoremap <C-Z> <C-C>:update<CR>
inoremap <C-Z> <C-O>:update<CR>
nnoremap <Leader>w :w<CR>

" Enter visual line mode with <Space><Space>:
nmap <Leader><Leader><Leader> V

" Quick quit command
noremap <Leader>e :quit<CR>  " Quit current window
noremap <Leader>E :qa!<CR>   " Quit all windows

" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
" Every unnecessary keystroke that can be saved is good for your health :)
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" map sort function to a key
nnoremap <Leader>s vip:!sort<CR>
vnoremap <Leader>s :!sort<CR>

" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

" underline the current line with : <F4><u>
" useful for asciidoc sections
"nn <F4>u yypVr-
nn <F4>u yyp<C-V>$r-

" Yank from current cursor position to end of line
map Y y$

" easier formatting of paragraphs
vmap Q gq
nmap Q gqap

" map git commands
map <leader>l :!clear && git log -p %<cr>

map <Leader>vb Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>
map <leader>da :echo 'Current Time is ' . strftime( '%c' )<CR>

"inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
"inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

"open tag in new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>"

" =========================================
"        Abreviation
" =========================================
iab gc -- Gaël
iab Me Gaël Chamoulaud
iab gcha Gaël Chamoulaud <gchamoul@redhat.com>
iab g@ gael@redhat.com
iab xdate <c-r>=strftime("%m/%d/%Y")
iab br Best Regards, Gaël.<c-r>
iab rh Red Hat
iab linux Linux
iab rdo RDO

function! Today()
  let today = strftime("%A %m\/%d\/%Y")
  exe "normal a". today
endfunction
command! Today :call Today()

nmap <leader>fd :se ff=dos<cr>
nmap <leader>fu :se ff=unix<cr>

" Switch to current dir
map <Leader>cdi :cd %:p:h<cr>
" Display Current time !!!
map <Leader>da :echo 'Current Time is ' . strftime( '%c' )<CR>

" Create a new window with directory ing of current buffer
nnoremap <Leader>wd :new <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <Leader>wn :new %:p:h<CR>
nnoremap <Leader>w. :new %:p:h<CR>

nnoremap <Leader>wtd :tabnew <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <Leader>wtn :tabnew %:p:h<CR>
nnoremap <Leader>wt. :tabnew %:p:h<CR>

nnoremap <Leader>vd :vnew <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <Leader>vn :vnew %:p:h<CR>
nnoremap <Leader>v. :vnew %:p:h<CR>
nnoremap <Leader>, :h<Space>
" \F to startup an ack search
map <leader>fa :Ack<space>
" open tabs with Leader-<tab number>
map <Leader>1 :tabn 1<CR>
map <Leader>2 :tabn 2<CR>
map <Leader>3 :tabn 3<CR>
map <Leader>4 :tabn 4<CR>
map <Leader>5 :tabn 5<CR>

" split vertically with <leader> v
" split horizontally with <leader> s
nmap <Leader>vs :vsplit<CR> <C-w><C-w>
nmap <Leader>sp :split<CR> <C-w><C-w>

"Print current path
"   'test'
cmap <C-e> <C-r>=expand('%:p:h')<CR>/

" Jump to the start or end of line without leaving the home row
noremap H ^
noremap L $

nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit -a -v -s<CR>
nnoremap <silent> <leader>gac :Gcommit -a --amend -v<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gr :Gread<CR>:GitGutter<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>:GitGutter<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
nnoremap <silent> <leader>gg :GitGutterToggle<CR>

autocmd FileType gitcommit set tw=68 spell
autocmd FileType gitcommit setlocal foldmethod=manual

" God Like mode. U can't use the arrow keys! Muahahah!
noremap <left> <nop>
noremap <up> <nop>
noremap <down> <nop>
noremap <right> <nop>
" Neither in insert mode! muahahah!
"inoremap <left> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <right> <nop>

" Using arrow keys in vim visual mode is for loosers!
vnoremap <left> <nop>
vnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <right> <nop>

" I do not know what o-mode stands for and now I'm feeling too lazy to
" check the wiki. But, no matter what o stand for and no matter in what
" mode do you are, you will never be allowed to use arrow keys for
" movements!
onoremap <left> <nop>
onoremap <up> <nop>
onoremap <down> <nop>
onoremap <right> <nop>

" Less god like mode - change the escape key to jj in
" command and insert mode and to v in visual mode
ino jj <esc>
cno jj <c-c>
vno v <esc>

" Always move through visual lines:
nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk

" Faster scrolling:
nmap J 5j
nmap K 5k
xmap J 5j
xmap K 5k

" argwrap binding
nnoremap <silent> <leader>a :ArgWrap<CR>

nnoremap g= gg=Gg``

" Use tab and shift-tab to cycle through windows.
nnoremap <Tab> <C-W>w
nnoremap <S-Tab> <C-W>W

nmap / <Plug>(easymotion-sn)
xmap / <Esc><Plug>(easymotion-sn)\v%V
omap / <Plug>(easymotion-tn)
" }}}
" => Commands {{{
" Close all folds when opening a new buffer
autocmd BufRead * setlocal foldmethod=marker
autocmd BufRead * normal zM

augroup filetype
  autocmd BufNewFile,BufRead */.Postponed/* set filetype=mail
  autocmd BufNewFile,BufRead *.txt setl textwidth=79
  autocmd BufRead,BufNewFile *mutt-* set filetype=mail
  autocmd FileType html,vim,javascript,dockbook,mail setl shiftwidth=2
  autocmd FileType html,vim,javascript,dockbook,mail setl softtabstop=2
  autocmd BufNewFile,BufRead *.markdown,*.md,*.mdown,*.mkd,*.mkdn
        \ if &ft =~# '^\%(conf\|modula2\)$' |
        \   set ft=markdown |
        \ else |
        \   setf markdown |
        \ endif
augroup END

autocmd FileType ruby,eruby,yaml set tw=80 ai sw=2 sts=2 et
autocmd FileType ruby,eruby,yaml setlocal foldmethod=manual
autocmd User Rails set tabstop=2 shiftwidth=2 softtabstop=2 expandtab


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fileformats
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Favorite filetypes
set ffs=unix

" detect kickstart filetype
autocmd BufNewFile,BufRead *.ks setl ft=kickstart

" Ruby
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

"autocmd BufWritePost *.py call Flake8()

" Awesome line number magic
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set nonumber
    set relativenumber
  endif
endfunction

nnoremap <leader>n :call NumberToggle()<cr>
:au FocusLost * set number
:au FocusGained * set relativenumber
autocmd InsertEnter * set number
autocmd InsertLeave * set relativenumber
set relativenumber

function! s:DisplayStatus(msg)
  echohl Todo
  echo a:msg
  echohl None
endfunction

" Cleaning of code
" - replace tabs with spaces;
" - delete char CTRL-M at end of line.
" - delete trailing whitespaces at the end of lines
" Generate CTRL-M in insert mode with <ctrl-v>+<return>
function! CleanCode()
  set expandtab
  %retab
  try
    %s///g
  catch /E486:/
  endtry
  try
    %s/\s\+$//
  catch /E486:/
  endtry
  call s:DisplayStatus('Code cleaned')
endfunction

" Use with :
" :CleanCode
command! -bar -range=% CleanCode call CleanCode()

" ASCIIDOC Specific
" Reformat paragraphs and .
nnoremap <Leader>r gq}

autocmd BufRead,BufNewFile *.txt,*.adoc,*.asciidoc,README,TODO,CHANGELOG,NOTES,ABOUT
        \ setlocal autoindent expandtab tabstop=8 softtabstop=2 shiftwidth=2 filetype=asciidoc
        \ textwidth=79 wrap formatoptions=tcqn
        \ formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\\|^\\s*<\\d\\+>\\s\\+\\\\|^\\s*[a-zA-Z.]\\.\\s\\+\\\\|^\\s*[ivxIVX]\\+\\.\\s\\+
        \ comments=s1:/*,ex:*/,://,b:#,:%,:XCOMM,fb:-,fb:*,fb:+,fb:.,fb:>

map <silent> <F7> <Esc> :w! <cr> :!python % <cr>
command! W w !sudo tee "%" > /dev/null

"delete all lines in the current buffer
"nmap <C-S-F2> ggdG
"nmap <C-S-F3> ggVG
"vmap <C-c> "*y<CR>
"vmap <C-v> "*gP<CR>

autocmd VimEnter * redraw!

noremap <silent> <Leader>h :call ToggleWrap()<CR>
function! ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

" Reset spellin  colours when reading a new buffer
" This works around an issue where the colorscheme is changed by .local.vimrc
fun! SetSpellingColors()
  highlight spellbad cterm=bold ctermfg=white ctermbg=red
  highlight jpellCap cterm=bold ctermfg=red ctermbg=white
endfun
autocmd BufWinEnter * call SetSpellingColors()
autocmd BufNewFile * call SetSpellingColors()
autocmd BufRead * call SetSpellingColors()
autocmd InsertEnter * call SetSpellingColors()
autocmd InsertLeave * call SetSpellingColors()

" Change colourscheme when diffing
fun! SetDiffColors()
  highlight DiffAdd    cterm=bold ctermfg=white ctermbg=DarkGreen
  highlight DiffDelete cterm=bold ctermfg=white ctermbg=DarkRed
  highlight DiffChange cterm=bold ctermfg=white ctermbg=DarkBlue
  highlight DiffText   cterm=bold ctermfg=white ctermbg=DarkRed
endfun
autocmd FilterWritePre * call SetDiffColors()

fun! RangerChooser()
    exec "silent !ranger --choosefile=/tmp/chosenfile " . expand("%:p:h")
    if filereadable('/tmp/chosenfile')
        exec 'edit ' . system('cat /tmp/chosenfile')
        call system('rm /tmp/chosenfile')
    endif
    redraw!
endfun
map <Leader>ra :call RangerChooser()<CR>

autocmd VimResized * :wincmd =
" }}}
" => Folding {{{
set foldmethod=marker
set foldmarker={{{,}}}
set foldlevelstart=0
set foldnestmax=3

nmap <Leader>zz :call <SID>ToggleFold()<CR>
function! s:ToggleFold()
    if &foldmethod == 'marker'
        let &l:foldmethod = 'syntax'
        let &l:foldlevelstart = '0'
        let &l:foldnestmax = '2'
    else
        let &l:foldmethod = 'marker'
    endif
    echo 'foldmethod is now ' . &l:foldmethod
endfunction
" }}

" _ Vim {{{
augroup ft_vim
    au!

    au FileType vim setlocal foldmethod=marker
    au FileType help setlocal textwidth=78
    au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END

" }}}
"
