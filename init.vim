call plug#begin('~/.local/share/nvim/site/plugged')

Plug 'tpope/vim-sensible'
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-rhubarb'
Plug 'moll/vim-node'
Plug 'mustache/vim-mustache-handlebars'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'leafgarland/typescript-vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'flazz/vim-colorschemes'
Plug 'w0rp/ale'
Plug 'sbdchd/neoformat'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kassio/neoterm'
Plug 'janko-m/vim-test'

" Initialize plugin system
call plug#end()

"" Use comma as leader
let mapleader = ","

""
"" Basic Setup
""
set nocompatible      " Use vim, no vi defaults
set number            " Show line numbers
set numberwidth=3     " Always use 3 characters for line number gutter
set ruler             " Show line and column number

syntax enable         " Turn on syntax highlighting allowing local overrides
set encoding=utf-8    " Set default encoding to UTF-8
set hidden            " allow buffer switching without saving
set history=1000      " Store a ton of history (default is 20)
set cursorline        " highlight current line

set timeout timeoutlen=1000 ttimeoutlen=100 " ensure that `O` does not cause a crazy delay

""
"" Whitespace
""
set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set backspace=indent,eol,start    " backspace through everything in insert mode
set autoindent                    " automatically indent to the current level

" Scrolling
set scrolloff=3                   " minimum lines to keep above and below cursor

" List chars
set list                          " Show invisible characters

set listchars=""                  " Reset the listchars
set listchars+=tab:▸\             " a tab should display as "▸ ", trailing whitespace as "."
set listchars+=trail:.            " show trailing spaces as dots
set listchars+=eol:¬              " show eol as "¬"
set listchars+=extends:>          " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen

""
"" Searching
""
set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

""
"" Wild settings
""
" TODO: Investigate the precise meaning of these settings
" set wildmode=list:longest,list:full

" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Disable temp and backup files
set wildignore+=*.swp,*~,._*,/tmp/

" Disable Ex mode from Q
nnoremap Q <nop>

" enable undo tracking per-file
set undofile

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=

set lazyredraw            " don't redraw while in macros

set conceallevel=2

" *******************************
" * file type setup 		*
" *******************************
"
" automatically trim whitespace for specific file types
autocmd FileType js,c,cpp,java,php,ruby,perl autocmd BufWritePre <buffer> :%s/\s\+$//e

" Remember last location in file, but not for commit messages.
" see :help last-position-jump
autocmd BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
\| exe "normal! g`\"" | endif

" *** Plugin Config ***

let g:javascript_conceal=1
let g:javascript_conceal_function   = "ƒ"
let g:javascript_conceal_null       = "ø"
let g:javascript_conceal_this       = "@"
let g:javascript_conceal_return     = "⇚"
let g:javascript_conceal_undefined  = "¿"
let g:javascript_conceal_NaN        = "ℕ"
let g:javascript_conceal_prototype  = "¶"
let g:javascript_conceal_static     = "•"
let g:javascript_conceal_super      = "Ω"

let g:ale_fixers = {
\   'javascript': ['eslint'],
\}
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5'

let g:ale_sign_column_always = 1

" If rg is available use it as filename list generator instead of 'find'
if executable("rg")
    set grepprg=rg\ --color=never\ --glob
endif

" tell nerdtree to ignore compiled files
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.rbc$', '\.rbo$', '\.class$', '\.o$', '\~$']
let NERDTreeHijackNetrw = 1

" Augmenting Ag command using fzf#vim#with_preview function
"   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
"     * For syntax-highlighting, Ruby and any of the following tools are required:
"       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
"       - CodeRay: http://coderay.rubychan.de/
"       - Rouge: https://github.com/jneen/rouge
"
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Command for git grep
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" setup strategy to be used by vim-test
let test#strategy = "neoterm"


" *******************************
" * status line                 *
" *******************************
set laststatus=2                               " always show status line
set statusline=%<%f\                           " Filename
set statusline+=%w%h%m%r                       " Options
set statusline+=\ [%{&ff}/%Y]                  " filetype
set statusline+=\ [%{split(getcwd(),'/')[-1]}] " current dir
set statusline+=%=%-14.(%l,%c%V%)\ %p%%        " Right aligned file nav info

" *******************************
" * key bindings 		            *
" *******************************
nmap <Leader>nt :NERDTreeToggle<CR>
nmap <Leader>nf :NERDTreeFind<CR>

" fugitive bindings
nmap <Leader>gs :Gstatus<CR>
nmap <Leader>gd :Gdiff<CR>

" fzf.vim mappings
map <C-P> :GFiles<CR>
map <C-F> :Files<CR>
map <C-B> :Buffers <cr>


" tabular
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a> :Tabularize /=><CR>
vmap <Leader>a> :Tabularize /=><CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
nmap <Leader>a<Space> :Tabularize whitespace<CR>
vmap <Leader>a<Space> :Tabularize whitespace<CR>

" edit files from within current directory
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Adjust viewports to the same size
map <Leader>= <C-w>=

" Allow auto-fixing linting errors
nmap <leader>d <Plug>(ale_fix)

" use :w!! to write to a file using sudo if you forgot to 'sudo vim file'
" (it will prompt for sudo password when writing)
cmap w!! %!sudo tee > /dev/null %

nnoremap <leader><leader> <c-^>

" pastetoggle (sane indentation on pastes)
set pastetoggle=<F12>

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Move row-wise instead of line-wise
nnoremap j gj
nnoremap k gk

" 'x is much easier to hit than `x and has more useful semantics: ie switching
" to the column of the mark as well as the row
nnoremap ' `

" No arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
noremap <C-w><Up> <NOP>
noremap <C-w><Down> <NOP>
noremap <C-w><Left> <NOP>
noremap <C-w><Right> <NOP>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>r :call RenameFile()<cr>

" Enable soft wrapping with `:Wrap`
" From: http://vimcasts.org/episodes/soft-wrapping-text/
"
command! -nargs=* SoftWrap set wrap linebreak nolist

" Use <CR> to clear text search, but unmap it when in the command window as
" <CR> there is used to run command
function s:install_enter_hook()
  nnoremap <CR> :nohl<CR>
endfunction

augroup EnterKeyManager
  autocmd!

  autocmd CmdwinEnter * nunmap <CR>
  autocmd CmdwinLeave * call s:install_enter_hook()
augroup end
call s:install_enter_hook()

" Useful neoterm mappings
"
let g:neoterm_autoinsert = 1

" show/open terminal
nnoremap <silent> <leader>ts :Topen<cr>
" hide/close terminal
nnoremap <silent> <leader>th :Tclose<cr>
" clear terminal
nnoremap <silent> <leader>tl :call neoterm#clear()<cr>
" kills the current job (send a <c-c>)
nnoremap <silent> <leader>tc :call neoterm#kill()<cr>

" Window-motion out of terminals
tnoremap <C-w>h <C-\><C-n><C-w>h
tnoremap <C-w><C-h> <C-\><C-n><C-w>h
tnoremap <C-w>j <C-\><C-n><C-w>j
tnoremap <C-w><C-j> <C-\><C-n><C-w>j
tnoremap <C-w>k <C-\><C-n><C-w>k
tnoremap <C-w><C-k> <C-\><C-n><C-w>k
tnoremap <C-w>l <C-\><C-n><C-w>l
tnoremap <C-w><C-l> <C-\><C-n><C-w>l

" Enable exiting terminal mode with Esc
tnoremap <C-\><C-\> <C-\><C-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Re-Running Terminal Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add support for re-running terminal commands
" Inside any terminal, go to visual mode and highlight some text (probably
" a command you just ran), then hit <leader>rr

" Now in any terminal in normal mode <leader>rr will repeat that command
" in the same terminal.
"
" This works for
"  - <leader>rr
"  - <leader>rd
"  - <leader>rt
"
" Which is useful eg for having a command for running tests and another
" for debugging a test.
"
" Politely stolen from @hjdivad: https://github.com/hjdivad/dotfiles/commit/9fd72080c79aedc6bd064e97e828be7d9752b3f3

function! s:GetVisual() range
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save
  return selection
endfunction

function! s:TerminalRun(mapping)
  let l:job_var = 'g:terminal_run_' . a:mapping . '_job'
  let l:job_cmd_var = 'g:terminal_run_' . a:mapping . '_cmd'

  if !exists(l:job_cmd_var)
    echom 'termianl command for ' . mapping . ' has not been set up yet'
    return
  endif

  call jobsend({l:job_var}, {l:job_cmd_var})
endfunction

function! s:SetupTerminalRun(mapping) range
  let l:job_var = 'g:terminal_run_' . a:mapping . '_job'
  let l:job_cmd_var = 'g:terminal_run_' . a:mapping . '_cmd'
  let l:selection = <SID>GetVisual()
  let l:terminal_cmd = [l:selection, '']

  let {l:job_var} = b:terminal_job_id
  let {l:job_cmd_var} = l:terminal_cmd
endfunction

function s:setup_terminal()
  setlocal winfixwidth
  vertical resize 50

  vmap <buffer> <leader>rr :call <SID>SetupTerminalRun('rr')<CR>
  vmap <buffer> <leader>rd :call <SID>SetupTerminalRun('rd')<CR>
  vmap <buffer> <leader>rt :call <SID>SetupTerminalRun('rt')<CR>
endfunction

nmap <leader>rr :call <SID>TerminalRun('rr')<CR>
nmap <leader>rd :call <SID>TerminalRun('rd')<CR>
nmap <leader>rt :call <SID>TerminalRun('rt')<CR>

augroup TermExtra
  autocmd!
  " When switching to a term window, go to insert mode by default (this is
  " only pleasant when you also have window motions in terminal mode)
  autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif " start! is better (append) but causes problems with my shell
  autocmd TermOpen * call <SID>setup_terminal()
  autocmd TermClose * setlocal nowinfixwidth
augroup end

set t_Co=256
set termguicolors
color Tomorrow-Night
highlight! default link Conceal Title
