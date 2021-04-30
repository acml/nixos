{ config, pkgs, lib, ... }:

let
  inherit (config.icebox.static.lib.configs) devices system;
  iceLib = config.icebox.static.lib;

  toPlugin = n: v: pkgs.vimUtils.buildVimPluginFrom2Nix { name = n; src = v; };

  myPlugins = lib.mapAttrsToList toPlugin {
    # https://github.com/neovim/neovim/issues/12587
    "FixCursorHold.nvim" = pkgs.fetchFromGitHub {
      owner = "antoinemadec";
      repo = "FixCursorHold.nvim";
      rev = "d932d56b844f6ea917d3f7c04ff6871158954bc0";
      hash = "sha256-Kqk3ZdWXCR7uqE9GJ+zaDMs0SeP/0/8bTxdoDiRnRTo=";
    };
  };

  readFile = file: ext: builtins.readFile (./. + "/${file}.${ext}");
  readVimSection = file: (readFile file "vim");
  readLuaSection = file: wrapLuaConfig (readFile file "lua");

  # For plugins configured with lua
  wrapLuaConfig = luaConfig: ''
    lua<<EOF
    ${luaConfig}
    EOF
  '';
  pluginWithLua = plugin: {
    inherit plugin;
    config = readLuaSection plugin.pname;
  };
  pluginWithCfg = plugin: {
    inherit plugin;
    config = readVimSection plugin.pname;
  };

in {
  config.home-manager.users = iceLib.functions.mkUserConfigs' (name: cfg: {

    imports = [ ./plugins ];
    home.packages = [ pkgs.tree-sitter pkgs.luajit ];
    programs.neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      # nvim plugin providers
      withNodeJs = true;
      withRuby = true;
      withPython = true;
      withPython3 = true;

      # share vim plugins since nothing is specific to nvim
      plugins = with pkgs.nixos-unstable.vimPlugins; [
        # basics
        vim-sensible
        vim-fugitive
        vim-surround
        vim-commentary
        vim-sneak
        vim-closetag
        kotlin-vim

        # vim addon utilities
        direnv-vim
        ranger-vim
      ];
      extraConfig = ''
      ${readVimSection "settings"}
    '';
    };

    # home.packages = with pkgs.nixos-unstable; [ fzf ];
    # xdg.configFile."nvim/init.lua".source = system.dirs.dotfiles + "/${name}/neovim/init.lua";
    # programs.neovim = {
    #   enable = true;
    #   package = pkgs.neovim-nightly;
    #   viAlias = true;
    #   vimAlias = true;
    #   vimdiffAlias = true;
    #   withNodeJs = true;

    #   # plugins = myPlugins ++ (with pkgs.nixos-unstable.vimPlugins; [
    #   #   ale               # Asynchronous Lint Engine
    #   #   coc-explorer      # LSP
    #   #   coc-go
    #   #   coc-html
    #   #   coc-json
    #   #   coc-markdownlint
    #   #   coc-nvim
    #   #   coc-python
    #   #   coc-rust-analyzer
    #   #   coc-vimlsp
    #   #   commentary        # comment stuff out
    #   #   fugitive          # Git
    #   #   rainbow           # Rainbow paranthesis, brackets
    #   #   sensible          # Defaults everyone can agree on
    #   #   skim-vim          # File lookup
    #   #   vim-airline       # Statusbar
    #   #   vim-airline-themes
    #   #   vim-buffergator   # Buffer
    #   #   vim-indent-guides # visually displaying indent levels
    #   #   vim-signify       # Gutter with  mode
    #   #   vim-which-key     # Show key completion
    #   #   vista-vim         # Shows symbol with LSP

    #   #   # Language
    #   #   vim-nix
    #   #   #vim-addon-nix
    #   #   polyglot

    #   #   #
    #   #   # vim-indent-object
    #   #   #
    #   #   gruvbox-community
    #   #   palenight-vim
    #   #   onedark-vim

    #   #   nvim-tree-lua
    #   #   nvim-web-devicons

    #   #   plenary-nvim
    #   #   popup-nvim
    #   #   telescope-frecency-nvim
    #   #   telescope-fzf-writer-nvim
    #   #   telescope-fzy-native-nvim
    #   #   telescope-nvim
    #   #   telescope-symbols-nvim
    #   #   telescope-z-nvim
    #   # ]);

    #   # extraConfig = ''
    #   #   " Default settings
    #   #   set nocompatible
    #   #   set nobackup
    #   #   " Yup, I live on the edge
    #   #   set noswapfile
    #   #   set updatetime=100

    #   #   let g:mapleader = "\<Space>"
    #   #   let g:maplocalleader = ','

    #   #   " Colors/Theme
    #   #   set termguicolors
    #   #   colorscheme gruvbox
    #   #   let g:airline_theme = 'gruvbox'
    #   #   " let g:airline#extensions#tabline#left_sep = ' '
    #   #   " let g:airline#extensions#tabline#left_alt_sep = '|'
    #   #   " let g:airline#extensions#tabline#formatter = 'default'
    #   #   let g:airline_powerline_fonts = 1
    #   #   " let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
    #   #   " Display all buffers when only one tab is open
    #   #   let g:airline#extensions#tabline#enabled = 1


    #   #   " Basics
    #   #   syntax on

    #   #   set hidden      " Allows hidden buffer
    #   #   set hlsearch
    #   #   set smartcase
    #   #   filetype plugin on
    #   #   set listchars=tab:>-,trail:*
    #   #   set tabstop=2 softtabstop=2 shiftwidth=2
    #   #   set expandtab
    #   #   set number
    #   #   set relativenumber
    #   #   set scrolloff=5             " keep 5 lines of context when scrolling
    #   #   set lazyredraw              " do not redraw screen while executing a macro
    #   #   set splitbelow splitright
    #   #   set mouse=nv                " Enable mouse usage except in insert mode

    #   #   set formatoptions+=j   " remove a comment leader when joining lines.
    #   #   set formatoptions+=o   " insert the comment leader after hitting 'o'

    #   #   " Enable autocompletion
    #   #   set wildmode=longest,list,full

    #   #   " Live substitution
    #   #   set inccommand=nosplit

    #   #   " Disables automatic commenting on newline
    #   #   autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

    #   #   " Quick exit with `:Q`
    #   #   command Q qa

    #   #   nnoremap <leader>si :set spell!<CR>
    #   #   nnoremap <leader>l :set list!<CR>
    #   #   nnoremap <leader>S :%s//g<Left><Left>
    #   #   nnoremap <leader>m :set number!<CR>
    #   #   nnoremap <leader>n :set relativenumber!<CR>

    #   #   nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

    #   #   " FZF
    #   #   let g:fzf_command_prefix = 'Fzf'
    #   #   let g:fzf_buffers_jump = 1
    #   #   nnoremap <C-t> :FzfFiles!
    #   #   nnoremap <leader><space> :FzfFiles<CR>
    #   #   nnoremap <leader>. :FzfFiles %:p:h<CR>


    #   #   " Insert line above
    #   #   nnoremap [o O<Esc>j
    #   #   " Insert line below
    #   #   nnoremap ]o o<Esc>k
    #   #   " Copy till eol
    #   #   nnoremap Y y$
    #   #   " Comment lines with commentary.vim
    #   #   inoremap <silent> <M-;> <C-o>:Commentary<CR>
    #   #   nmap <silent> <M-;> gcc
    #   #   vmap <silent> <M-;> gc
    #   #   nmap <silent> <leader>; gcc
    #   #   vmap <silent> <leader>; gc
    #   #   " Buffer management
    #   #   autocmd VimEnter * silent! nunmap <leader>b
    #   #   nnoremap <leader>, <C-^>
    #   #   nnoremap <leader>b, <C-^>
    #   #   nnoremap <leader>bd :bd<CR>
    #   #   nnoremap <leader>bn :bnext<CR>
    #   #   nnoremap <leader>bN :enew<CR>
    #   #   nnoremap <leader>bp :bprevious<CR>
    #   #   nnoremap <leader>bi :FzfBuffers<CR>
    #   #   " Window management
    #   #   nnoremap <leader>w <C-w>

    #   #   " Finding things
    #   #   nnoremap <leader>ss :FzfBLines<CR>
    #   #   nnoremap <leader>sp :FzfRg<CR>

    #   #   " Git
    #   #   nnoremap <silent> <leader>gg :Gstatus<CR>
    #   #   nnoremap <silent> <leader>gd :Gdiff<CR>
    #   #   nnoremap <silent> <leader>gc :Gcommit<CR>
    #   #   nnoremap <silent> <leader>gb :Gblame<CR>
    #   #   nnoremap <silent> <leader>ge :Gedit<CR>

    #   #   " Enable rainbow paranthesis globally
    #   #   let g:rainbow_active = 1

    #   #   " Polyglot
    #   #   let g:polyglot_disabled = ['markdown']

    #   #   " Vista
    #   #   let g:vista_fzf_preview = ['right:30%']
    #   #   let g:vista#renderer#enable_icon = 1
    #   #   let g:vista#renderer#icons = {
    #   #   \   "function": "\uf794",
    #   #   \   "variable": "\uf71b",
    #   #   \  }

    #   #   autocmd! FileType which_key
    #   #   autocmd  FileType which_key set laststatus=0 noshowmode noruler
    #   #     \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

    #   #   au FileType gitcommit setlocal tw=68 colorcolumn=69 spell

    #   #   " nvim_tree
    #   #   let g:nvim_tree_side = 'left' "left by default
    #   #   let g:nvim_tree_width = 40 "30 by default
    #   #   let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
    #   #   let g:nvim_tree_gitignore = 1 "0 by default
    #   #   let g:nvim_tree_auto_open = 1 "0 by default, opens the tree when typing `vim $DIR` or `vim`
    #   #   let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
    #   #   let g:nvim_tree_auto_ignore_ft = [ 'startify', 'dashboard' ] "empty by default, don't auto open tree on specific filetypes.
    #   #   let g:nvim_tree_quit_on_open = 0 "0 by default, closes the tree when you open a file
    #   #   let g:nvim_tree_follow = 1 "0 by default, this option allows the cursor to be updated when entering a buffer
    #   #   let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
    #   #   let g:nvim_tree_hide_dotfiles = 1 "0 by default, this option hides files and folders starting with a dot `.`
    #   #   let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
    #   #   let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
    #   #   let g:nvim_tree_tab_open = 1 "0 by default, will open the tree when entering a new tab and the tree was previously open
    #   #   let g:nvim_tree_width_allow_resize  = 1 "0 by default, will not resize the tree when opening a file
    #   #   let g:nvim_tree_disable_netrw = 0 "1 by default, disables netrw
    #   #   let g:nvim_tree_hijack_netrw = 0 "1 by default, prevents netrw from automatically opening when opening directories (but lets you keep its other utilities)
    #   #   let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
    #   #   let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
    #   #   let g:nvim_tree_lsp_diagnostics = 1 "0 by default, will show lsp diagnostics in the signcolumn. See :help nvim_tree_lsp_diagnostics
    #   #   let g:nvim_tree_special_files = [ 'README.md', 'Makefile', 'MAKEFILE' ] " List of filenames that gets highlighted with NvimTreeSpecialFile
    #   #   let g:nvim_tree_show_icons = {
    #   #       \ 'git': 1,
    #   #       \ 'folders': 1,
    #   #       \ 'files': 1,
    #   #       \ }
    #   #   "If 0, do not show the icons for one of 'git' 'folder' and 'files'
    #   #   "1 by default, notice that if 'files' is 1, it will only display
    #   #   "if nvim-web-devicons is installed and on your runtimepath

    #   #   " default will show icon by default if no icon is provided
    #   #   " default shows no icon by default
    #   #   let g:nvim_tree_icons = {
    #   #       \ 'default': '',
    #   #       \ 'symlink': '',
    #   #       \ 'git': {
    #   #       \   'unstaged': "✗",
    #   #       \   'staged': "✓",
    #   #       \   'unmerged': "",
    #   #       \   'renamed': "➜",
    #   #       \   'untracked': "★",
    #   #       \   'deleted': "",
    #   #       \   'ignored': "◌"
    #   #       \   },
    #   #       \ 'folder': {
    #   #       \   'default': "",
    #   #       \   'open': "",
    #   #       \   'empty': "",
    #   #       \   'empty_open': "",
    #   #       \   'symlink': "",
    #   #       \   'symlink_open': "",
    #   #       \   },
    #   #       \   'lsp': {
    #   #       \     'hint': "",
    #   #       \     'info': "",
    #   #       \     'warning': "",
    #   #       \     'error': "",
    #   #       \   }
    #   #       \ }

    #   #   nnoremap <C-n> :NvimTreeToggle<CR>
    #   #   nnoremap <leader>r :NvimTreeRefresh<CR>
    #   #   nnoremap <leader>n :NvimTreeFindFile<CR>
    #   #   " NvimTreeOpen and NvimTreeClose are also available if you need them

    #   #   set termguicolors " this variable must be enabled for colors to be applied properly

    #   #   " a list of groups can be found at `:help nvim_tree_highlight`
    #   #   " highlight NvimTreeFolderIcon guibg=blue
    #   # '';
    # };

  }) config.icebox.static.users.ahmetde;

}
