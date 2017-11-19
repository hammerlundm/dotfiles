syntax on
set hlsearch
set autoindent
set mouse=a
set number
set shiftwidth=4
set softtabstop=4
set expandtab
set termguicolors
set title
let g:airline_powerline_fonts = 1
nnoremap <C-n> :NERDTreeToggle<CR>
function! UpdateColors()
    :so ~/.vim/colors.vim
endfunction
nnoremap <C-r> :call UpdateColors()<CR>
autocmd VimEnter * :call UpdateColors()
