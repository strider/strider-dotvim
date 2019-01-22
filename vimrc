" dotvIMRc by Gaël Chamoulaud <gchamoul@redhat.com>

" => Vim-plug {{{
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'lifepillar/vim-solarized8'
Plug 'thaerkh/vim-workspace'
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'dagwieers/asciidoc-vim'
Plug 'davidhalter/jedi-vim' , {'for': 'python'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'dbakker/vim-lint'
Plug 'ervandew/supertab'
Plug 'FooSoft/vim-argwrap'
Plug 'gcmt/wildfire.vim'
Plug 'Glench/Vim-jinja2-Syntax'
Plug 'godlygeek/tabular'
Plug 'honza/vim-snippets'
Plug 'garbas/vim-snipmate'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'Lokaltog/vim-easymotion'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'mileszs/ack.vim'
Plug 'miyakogi/conoline.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'pbrisbin/vim-mkdir'
Plug 'pearofducks/ansible-vim'
Plug 'vim-python/python-syntax'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/denite.nvim'
Plug 'zchee/deoplete-jedi', {'for': 'python'}
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors'
Plug 'tomtom/tlib_vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
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
Plug 'xolox/vim-session'

Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesEnable' }
autocmd! User indentLine doautocmd indentLine Syntax

Plug 'mhinz/vim-startify'
Plug 'chrisbra/vim-diff-enhanced'
call plug#end()
" }}}
" => Settings {{{
syntax on
set fenc=utf-8
scriptencoding utf-8
set encoding=utf-8
set termencoding=utf-8
set nocompatible
set nobackup
set path+=**
set nowritebackup
set noswapfile
set nowrap
set updatetime=250
set backspace=indent,eol,start
set expandtab
set tabstop=4
set shiftwidth=4
set number
set laststatus=2
set undofile
set undodir=~/.vim_undodir
set synmaxcol=1200
set nojoinspaces
set nostartofline
set pastetoggle=<F2>
set mouse=a
set splitbelow
set splitright
set history=700
set undolevels=700
set showcmd
set incsearch
set hlsearch
set smartcase
set ignorecase
set hidden
set cursorline
set visualbell
set wildmenu
set lazyredraw
set showmatch
set colorcolumn=80
set shiftround
set laststatus=2
set statusline=%f\ %=L:%l/%L\ %c\ (%p%%)
set noshowmode
set scrolloff=8
set sidescrolloff=15
set scrolljump=5
set sidescroll=1
set so=7
set formatprg=par\ -w80q
set formatoptions+=t

let g:workspace_undodir='~/.vim_undodir'

" Get rid of the delay when pressing O (for example)
" http://stackoverflow.com/questions/2158516/vim-delay-before-o-opens-a-new-line
set timeout timeoutlen=1000 ttimeoutlen=100

" Invisible characters
map \ :set invlist<CR>
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:␣
set showbreak=↪
set clipboard+=unnamed

" Only show cursorline in the current window and in normal mode.
augroup cline
  au!
  au WinLeave * set nocursorline
  au WinEnter * set cursorline
  au InsertEnter * set nocursorline
  au InsertLeave * set cursorline
augroup END

" Set built-in file system explorer to use layout similar to the NERDTree plugin
let g:netrw_style=3

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

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %
" }}}
" => Plugins {{{

filetype off
filetype plugin indent on

" Theme
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
let g:airline_theme= 'deus'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1

let g:ansible_attribute_highlight = "a"
let g:ansible_name_highlight = 'd'
let g:ansible_extra_keywords_highlight = 1
let g:ansible_normal_keywords_highlight = 'Constant'
let g:ansible_with_keywords_highlight = 'Constant'

nmap <F5> :TagbarToggle<CR>
nmap <F9> :GitGutterLineHighlightsToggle<CR>

set wildignore+=*.pyc,*.o,*.obj
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=*_build/*
set wildignore+=*/coverage/*

nmap <F3> :NERDTreeToggle<CR>
map <Leader>` :NERDTreeFind<CR>
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

if (has("python3"))
  let g:jedi#force_py_version = 3
endif

let g:python_highlight_all = 1

let g:conoline_auto_enable = 1
let g:conoline_use_colorscheme_default_normal=1
let g:conoline_use_colorscheme_default_insert=1

let g:vimwiki_ = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" Private Gist by default
let g:gist_post_private = 1

" SnipMate Options
let g:snips_author = 'Gaël Chamoulaud'
let g:snips_email = 'gchamoul@redhat.com'
let g:snips_github = 'https://github.com/strider'

"" Github Comments
"let g:github_user = 'strider'

" Git gutter
let g:gitgutter_enabled = 1
let g:gitgutter_eager = 0
let g:gitgutter_sign_added = '++'
let g:gitgutter_sign_modified = '--'
let g:gitgutter_sign_removed = 'xx'
let g:gitgutter_sign_modified_removed = 'ww'
"let g:gitgutter_highlight_lines = 1
highlight clear SignColumn

let Tlist_Show_Menu = 1
let Tlist_Auto_Update = 1
let Tlist_Use_Right_Window = 1
let Tlist_Show_One_File = 1

" IdentLine
let g:indentLine_char = '┆'
"let g:indentLine_setColors = 0
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2
"let g:indentLine_color_term = 184
let g:indentLine_enabled = 1
let g:indentLine_fileTypeExclude = ['help', 'nerdtree']

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

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_complete_start_length = 1

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
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/plugged/vim-snippets/snippets'

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
 \ smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#popup_select_first = 0
let g:jedi#show_call_signatures = "1"

nnoremap <leader>rp <Esc>:call ToggleHardMode()<CR>

let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

let g:session_directory = "~/.vim/sessions"
let g:session_autoload = "no"
let g:session_autosave = "no"

let g:startify_session_dir = "~/.vim/sessions"

" started In Diff-Mode set diffexpr (plugin not loaded yet)
if &diff
    let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
endif

" }}}
" => Mappings {{{
" Removes highlight of your last search
nmap <silent> <leader>; :silent :nohlsearch<CR>

" Bind tabnew
nmap T :tabnew<CR>

"delete all lines in the current buffer
nmap <leader>daa ggdG
nmap <leader>caa ggVG

nmap <leader>q :split ~/.buffer<cr>
nmap <leader>v :tabedit $HOME/.vim/vimrc<CR>
nmap <leader>t :source ~/.vimrc<CR>
nnoremap <leader>ev <C-w>s<C-w>j:e $MYVIMRC<cr>

" vv to generate new vertical split
nnoremap <silent> vv <C-w>v

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
nmap <leader>sw<down>  :botright new<CR>
nmap <leader>sw<left>  :topleft  vnew<CR>
nmap <leader>sw<right> :botright vnew<CR>
nmap <leader>sw<up>    :topleft  new<CR>
" window

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

" make the view port scroll faster
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>
nnoremap <C-p> 5<C-p>

" map sort function to a key
nnoremap <Leader>s vip:!sort<CR>
xnoremap <Leader>s :!sort<CR>

" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
" then press ``>`` several times.
vnoremap < <gv  " better indentation
xnoremap > >gv  " better indentation

" Move visual block
xnoremap R :m '>+1<CR>gv=gv
xnoremap T :m '<-2<CR>gv=gv

" underline the current line with : <F4><u>
" useful for asciidoc sections
"nn <F4>u yypVr-
nn <F4>u yyp<C-V>$r-

" Yank from current cursor position to end of line
map Y y$

" Yank content in OS's clipboard. `o` stands for "OS's Clipoard".
xnoremap <leader>yo "*y
" Paste content from OS's clipboard
nnoremap <leader>po "*p

" easier formatting of paragraphs
xmap Q gq
nmap Q gqap

" map git commands
map <leader>l :!clear && git log -p %<cr>

map <Leader>vb Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>
map <leader>da :echo 'Current Time is ' . strftime( '%c' )<CR>

" pull word under cursor into Ack for a global search
map <leader>za :Ack "<C-r>=expand("<cword>")<CR>"

" =========================================
"        Abreviation
" =========================================
function! EatChar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunction

function! MakeSpacelessIabbrev(from, to)
    execute "iabbrev <silent> ".a:from." ".a:to."<C-R>=EatChar('\\s')<CR>"
endfunction
function! MakeSpacelessBufferIabbrev(from, to)
    execute "iabbrev <silent> <buffer> ".a:from." ".a:to."<C-R>=EatChar('\\s')<CR>"
endfunction

call MakeSpacelessIabbrev('gh/',  'http://github.com/')
call MakeSpacelessIabbrev('ghs/', 'http://github.com/strider/')

iabbrev todo TODO
iabbrev gc -- Gaël
iabbrev Me Gaël Chamoulaud
iabbrev gcha Gaël Chamoulaud <gchamoul@redhat.com>
iabbrev g@ gael@redhat.com
iabbrev xdate <c-r>=strftime("%m/%d/%Y")
iabbrev br Best Regards, Gaël.<c-r>
iabbrev rh Red Hat
iabbrev linux Linux
iabbrev rdo RDO
iabbrev tv tripleo-validations

cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev Wqa wqa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

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

autocmd FileType gitcommit set tw=79 spell
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

" Less god like mode - change the escape key to C-k in
" command and insert mode and to v in visual mode
"ino <C-k> <esc>
"cno <C-k> <c-c>
"xno v <esc>

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

"" Use tab and shift-tab to cycle through windows.
"nnoremap <Tab> <C-W>w
"nnoremap <C-i> <C-W>w
"nnoremap <S-Tab> <C-W>W

nmap / <Plug>(easymotion-sn)
xmap / <Esc><Plug>(easymotion-sn)\v%V
omap / <Plug>(easymotion-tn)

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Quickly move current line
nnoremap [e  :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap ]e  :<c-u>execute 'move +'. v:count1<cr>

" Quickly add empty lines
nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

" Find lines >80 chars long
nmap <Leader><F8> /^.\{-}\zs.\%>81v<CR>
" Find multiple newlines together
nmap <Leader>fi /^\(^}\n\)\@<!\n\n<CR>
" Fix commas without a following space unless they're in strings
nmap <silent> <Leader>x, :silent! %s/\(\(^\([^"']*\(["'][^"']*["']\)\)*[^"']*\)\@<=\)\+,\ze\S/& /g<CR>
" Fix , with leading spaces
nmap <silent> <Leader>xx, :silent! %s/\s\+,/,/g<CR>

nmap ; :Buffers<CR>
nmap ,, :Files<CR>

let g:fzf_prefer_tmux = 1
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

"" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~20%:' }

" You can set up fzf window using a Vim command (Neovim or latest Vim 8 required)
"let g:fzf_layout = { 'window': 'enew' }
"let g:fzf_layout = { 'window': '-tabnew' }
"let g:fzf_layout = { 'window': '30split enew' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

nnoremap <silent> <Leader>C :call fzf#run({
\   'source':
\     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
\         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
\   'sink':    'colo',
\   'options': '+m',
\   'left':    30
\ })<CR>

function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader><Enter> :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>

" }}}
" => Commands {{{
" Close all folds when opening a new buffer
autocmd BufRead * setlocal foldmethod=marker
autocmd BufRead * normal zM

augroup filetype
  autocmd BufNewFile,BufRead */.Postponed/* set filetype=mail
  autocmd BufNewFile,BufRead *.txt setl textwidth=80
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

" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml.ansible
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fileformats
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Favorite filetypes
set ffs=unix

" detect kickstart filetype
autocmd BufNewFile,BufRead *.ks setl ft=kickstart

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
au FocusLost * set number
au FocusGained * set relativenumber
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

autocmd BufRead,BufNewFile *.txt,*.adoc,*.asciidoc,README,TODO,CHANGELOG,ABOUT
      \ setlocal autoindent expandtab tabstop=8 softtabstop=2 shiftwidth=2 filetype=asciidoc
      \ textwidth=80 wrap formatoptions=tcqn
      \ formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\\|^\\s*<\\d\\+>\\s\\+\\\\|^\\s*[a-zA-Z.]\\.\\s\\+\\\\|^\\s*[ivxIVX]\\+\\.\\s\\+
      \ comments=s1:/*,ex:*/,://,b:#,:%,:XCOMM,fb:-,fb:*,fb:+,fb:.,fb:>

map <silent> <F7> <Esc> :w! <cr> :!python3 % <cr>
command! W w !sudo tee "%" > /dev/null

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
  au FileType help setlocal textwidth=80
  au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END

" }}}
"
