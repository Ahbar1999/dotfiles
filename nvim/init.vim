" Use (:execute 'edit' luaFile) to edit the lua config
" Moved lua import at the bottom because all the imports in lua need to be
" after 'plug#end'
" Set lua file's path according to OS filesystem
let luaFile = "~/AppData/Local/nvim/lua/config/init.lua"
if has('unix')
	luaFile = "/home/ahbar/.config/nvim/lua/config/init.lua"
endif

" Print some greeting messages 
echo "(^ - ^)/"

" Using multiline strings 
echo "Hello, Ahbar\n\r
\ ██╗░░░░░░░██╗███████╗██╗░░░░░░█████╗░░█████╗░███╗░░░███╗███████╗  ██████╗░░█████╗░░█████╗░██╗░░██╗██╗\n\r
\ ██║░░██╗░░██║██╔════╝██║░░░░░██╔══██╗██╔══██╗████╗░████║██╔════╝  ██╔══██╗██╔══██╗██╔══██╗██║░██╔╝██║\n\r
\ ╚██╗████╗██╔╝█████╗░░██║░░░░░██║░░╚═╝██║░░██║██╔████╔██║█████╗░░  ██████╦╝███████║██║░░╚═╝█████═╝░██║\n\r
\  ████╔═████║░██╔══╝░░██║░░░░░██║░░██╗██║░░██║██║╚██╔╝██║██╔══╝░░  ██╔══██╗██╔══██║██║░░██╗██╔═██╗░╚═╝\n\r
\  ╚██╔╝░╚██╔╝░███████╗███████╗╚█████╔╝╚█████╔╝██║░╚═╝░██║███████╗  ██████╦╝██║░░██║╚█████╔╝██║░╚██╗██╗\n\r
\   ╚═╝░░░╚═╝░░╚══════╝╚══════╝░╚════╝░░╚════╝░╚═╝░░░░░╚═╝╚══════╝  ╚═════╝░╚═╝░░╚═╝░╚════╝░╚═╝░░╚═╝╚═╝\n\r
\ \n\r\n\r
\ \n\r\n\r
\ \n\r\n\r
\ \n\r\n\r"

" Setting some editor variables
set number
set relativenumber
set ts=4
set sw=4
set autoindent
" Mapping keyboard bindings

" referenced by <leader>
let mapleader = "-"
" referenced by <localleader>
let localleader = "\\"

" Cut the current line and paste it below the current line, works in all the modes
nnoremap <leader>- ddp
" Same as above except moves the line upwards
nnoremap <leader>_ ddkP
" Dont use the above 2 commands at the first or last line, its not perfect ik 
" Delete the current line in insertion mode(Although the exact steps are longer) 
vnoremap <c-d> <esc>ddi 
inoremap <leader>s <esc>:w<cr>
" Open File Explorer with Ctrl+e
nnoremap <c-e> :vsplit<cr><esc>:execute('Explore')<cr>
" Open and edit $MYVIMRC file with keyboard shortcuts
" '<cr>' is carriage return, here basically it means to execute the command
" after entering it
nnoremap <leader>ovr :e $MYVIMRC<cr>
nnoremap <leader>ev  :vsplit $MYVIMRC<cr>
nnoremap <leader>sv  :source $MYVIMRC<cr><cr>:e<cr>
nnoremap <leader>olua :execute 'edit' luaFile<cr>
" Split window vertically and open the command prompt in one buffer 
nnoremap <leader>ot :vsplit<cr><esc>:terminal<cr>i 
inoremap <leader>e  <esc>eli
inoremap <leader>b  <esc>bi
nnoremap <leader>pfn <esc>:echo expand('%:t')<cr>

" SOME AUTOCOMMAND SETTINGS
" Comment Shortcuts
augroup comment_group
	autocmd FileType javascript nnoremap <buffer> <leader>cc I//<esc>
	autocmd FileType python     nnoremap <buffer> <leader>cc I#<esc>
	autocmd FileType python     nnoremap <buffer> <leader>cu I<esc>x<esc>
	" Go to the start of the line and comment and uncomment it 
	autocmd FileType rust	    nnoremap <buffer> <leader>cc I//<esc>
	autocmd FileType rust 	    nnoremap <buffer> <leader>cu ^xxi<esc>
augroup END


" fn stores stores the filename without extensions
let fn = expand('%:t:r')

function SetKotlinState(filename)
	echo "In a kotlin file"
	let b:compileCmdDotKt = "!kotlinc"." ".a:filename.".kt"." "."-include-runtime -d"." ".a:filename.".jar"
	let b:runCmdDotKt = "!java -jar"." ".a:filename.".jar"
	nnoremap <buffer> <leader>cp :execute(b:compileCmdDotKt)<cr>
	nnoremap <buffer> <leader>rp :execute(b:runCmdDotKt)<cr>
endfunction


augroup compile_run_group
	" Run program shortcuts
	" Generate commands from strings with execute/exec command and execute
	" them all in one go
	" exec introduces single whitespace be default between its arguments 
	autocmd FileType python inoremap <buffer> <F5> <esc>:w<cr>:exec "!python" fn.".py"
	autocmd FileType python nnoremap <buffer> <F5> :w<cr>:exec "!python" fn.".py"		
	autocmd FileType rust nnoremap <buffer> <F5> :w<cr>:exec "!cargo run" fn.".rs"	
	" Compile Shortcuts for Kotlin
	autocmd FileType kotlin call SetKotlinState(fn)
	" Compile Shortcuts for Scala
	" scalac compiles and scala compiles and executes
	autocmd FileType scala inoremap <buffer> <F5> <esc>:w<cr>:exec "!scala" fn.".scala"
	autocmd FileType scala nnoremap <buffer> <F5> :w<cr>:exec "!scala" fn.".scala"
	" autocmd BufWrite *.scala echo 'scala file written'
	
	" Compile/Build shortcuts for cpp
	autocmd FileType cpp inoremap <buffer> <F5> <esc>:w<cr>:exec "!g++" fn.".cpp -o" fn	
	autocmd FileType cpp nnoremap <buffer> <F5> :w<cr>:exec "!g++" fn.".cpp -o" fn
augroup END


"if expand('%:e') == 'kt' 
"	call SetKotlinState(fn)
" endif

augroup abbreviations
	autocmd FileType python iabbrev <buffer> iff if:<left>
	autocmd FileType python	iabbrev <buffer> forloop for i in range(n):<cr>	
	autocmd FileType python iabbrev <buffer> nameequalsmain if __name__ == '__main__':<cr>
	autocmd FileType python iabbrev <buffer> nameismain if __name__ == '__main__':<cr>	
	autocmd FileType javascript iabbrev <buffer> iff if ()<left>
augroup END


"START PLUG-IN MANAGER SETTINGS
call plug#begin('~/.vim/plugged')

" lsp config
Plug 'neovim/nvim-lspconfig'
" Plug 'neovim/nvim-lspconfig'
" Make sure you use single quotes
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'
Plug 'vim-airline/vim-airline'
Plug 'rust-lang/rust.vim'
" Dracula color scheme
Plug 'dracula/vim', { 'as': 'dracula' }
" Gruvbox color scheme
Plug 'morhetz/gruvbox'

" GOLANG Extension
Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries' }
Plug 'udalov/kotlin-vim'

" RUST Plugins
Plug 'rust-lang/rust.vim'

call plug#end()
"END PLUG-IN MANAGER SETTINGS

" Load the lua files in config folder and execute them
lua require('config')

" syntax enable
" set background=dark
colorscheme gruvbox 
syntax enable
filetype plugin indent on
