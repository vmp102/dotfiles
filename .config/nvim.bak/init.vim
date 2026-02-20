"plugin manager and nvim-treesitter /w nvim-tree and file icons
call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons' 

call plug#end()

lua << EOF
-- This "pcall" (protected call) prevents the crash if the plugin is missing
local ts_status, ts_configs = pcall(require, "nvim-treesitter.configs")
if ts_status then
    ts_configs.setup {
        ensure_installed = { "lua", "vim", "python", "javascript" },
        highlight = { enable = true },
    }
end

local tree_status, nvim_tree = pcall(require, "nvim-tree")
if tree_status then
    nvim_tree.setup()
end
EOF


syntax on
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set softtabstop=4
set clipboard+=unnamedplus
set termguicolors
colorscheme habamax

highlight Normal guibg=none
highlight NonText guibg=none

highlight LineNrAbove guifg=#5F86AE gui=bold
highlight LineNr      guifg=#BBBBBB gui=bold
highlight LineNrBelow guifg=#D65F86 gui=bold

set guicursor=a:block

nnoremap <C-b> :NvimTreeToggle<CR>
nnoremap <leader>nf :NvimTreeFindFile<CR>
let g:nvim_tree_auto_reload_on_write = 1
