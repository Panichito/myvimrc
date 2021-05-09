au GUIEnter * simalt ~x
set hls
set is
set cb=unnamed
set ts=4
set sw=4
set si
set cursorline

syntax on
call plug#begin('~/.vim/plugged')
"UI Plugins
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
"Themes
Plug 'altercation/vim-colors-solarized'
Plug 'gruvbox-community/gruvbox'
Plug 'phanviet/vim-monokai-pro'
Plug 'ayu-theme/ayu-vim'
Plug 'drewtempelmeyer/palenight.vim'
call plug#end()

let g:airline_powerline_fonts=1

"Monokai pro (more colors)
"colorscheme monokai_pro

"Palenight
"set background=dark
"colorscheme palenight

"Ayu
"set termguicolors     " enable true colors support
"let ayucolor="light"  " for light version of theme
"let ayucolor="mirage" " for mirage version of theme
"let ayucolor="dark"   " for dark version of theme
"colorscheme ayu

"Gruvbox
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

"Solarized
"set background=light
"let g:solarized_visibility='low'
"colorscheme solarized

inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {{ {
inoremap {} {}

set foldmethod=manual
set nowrap
set clipboard=unnamedplus
set nu
augroup numbertoggle
 autocmd!
 autocmd BufEnter,FocusGained,InsertLeave * set rnu
 autocmd BufLeave,FocusLost,InsertEnter * set nornu
augroup END
augroup remember_folds
  autocmd!
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent! loadview
augroup END

set diffexpr=MyDiff()
function MyDiff()
let opt = '-a --binary '
if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
let arg1 = v:fname_in
if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
let arg1 = substitute(arg1, '!', '!', 'g')
let arg2 = v:fname_new
if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
let arg2 = substitute(arg2, '!', '!', 'g')
let arg3 = v:fname_out
if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
let arg3 = substitute(arg3, '!', '!', 'g')
if $VIMRUNTIME =~ ' '
if &sh =~ '<cmd'
if empty(&shellxquote)
let l:shxq_sav = ''
set shellxquote&
endif
let cmd = '"' . $VIMRUNTIME . '\diff"'
else
let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
endif
else
let cmd = $VIMRUNTIME . '\diff'
endif
let cmd = substitute(cmd, '!', '!', 'g')
silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
if exists('l:shxq_sav')
let &shellxquote=l:shxq_sav
endif
endfunction
