au GUIEnter * simalt ~x
set hls
set is
set ts=4
set sw=4
set si
set cursorline

"Use a line cursor within insert mode and a block cursor everwhere else. Is neovim do it automatically?
"let &t_SI = "\e[6 q"
"let &t_EI = "\e[2 q"

syntax on
"src = https://evancalz.medium.com/setting-up-neovim-on-wsl2-bf634cac435f
call plug#begin(stdpath('config') . '/plugged')
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
"let g:solarized_visibility='high'
"colorscheme solarized

inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {{ {
inoremap {} {}

set foldmethod=manual
set nowrap
set clipboard=unnamedplus
set nu

"See numbertoggle in my github
augroup numbertoggle
 autocmd!
 autocmd BufEnter,FocusGained,InsertLeave * set rnu
 autocmd BufLeave,FocusLost,InsertEnter * set nornu
augroup END

augroup remember_folds
  autocmd!
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent! loadview  "you need to comment this first -> source -> uncomment
augroup END

"Highlight line number with no roughly cursorline
hi clear CursorLine
augroup CLClear
    autocmd! ColorScheme * hi clear CursorLine
augroup END

"Bold current line number
hi CursorLineNR cterm=bold
augroup CLNRSet
    autocmd! ColorScheme * hi CursorLineNR cterm=bold
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

"src= "https://github.com/mizlan/vim-and-cp/
"For detecting OS
if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

"Important option that should already be set!
set hidden

"Available options:
" * g:split_term_style
" * g:split_term_resize_cmd
function! TermWrapper(command) abort
	if !exists('g:split_term_style') | let g:split_term_style = 'vertical' | endif
	if g:split_term_style ==# 'vertical'
		let buffercmd = 'vnew'
	elseif g:split_term_style ==# 'horizontal'
		let buffercmd = 'new'
	else
		echoerr 'ERROR! g:split_term_style is not a valid value (must be ''horizontal'' or ''vertical'' but is currently set to ''' . g:split_term_style . ''')'
		throw 'ERROR! g:split_term_style is not a valid value (must be ''horizontal'' or ''vertical'')'
	endif
	exec buffercmd
	if exists('g:split_term_resize_cmd')
		exec g:split_term_resize_cmd
	endif
	exec 'term ' . a:command
	exec 'setlocal nornu nonu'
	exec 'startinsert'
	autocmd BufEnter <buffer> startinsert
endfunction

command! -nargs=0 CompileAndRun call TermWrapper(printf('g++ -std=c++17 %s && ./a.out', expand('%')))
command! -nargs=1 -complete=file CompileAndRunWithFile call TermWrapper(printf('g++ -std=c++11 %s && ./a.out < %s', expand('%'), <q-args>))
autocmd FileType cpp nnoremap <leader>fw :CompileAndRun<CR>

"Options
"choose between 'vertical' and 'horizontal' for how the terminal window is split (default is vertical)
"let g:split_term_style = 'horizontal'
let g:split_term_style = 'vertical'

"Add a custom command to resize the terminal window to your preference (default is to split the screen equally)
"let g:split_term_resize_cmd = 'resize 6'
let g:split_term_resize_cmd = 'vertical resize 40'
