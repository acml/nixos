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
in {
  config.home-manager.users = iceLib.functions.mkUserConfigs' (name: cfg: {

    # home.packages = with pkgs.nixos-unstable; [ fzf ];
    programs.neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;

      plugins = myPlugins ++ (with pkgs.nixos-unstable.vimPlugins; [
        ale               # Asynchronous Lint Engine
        coc-explorer      # LSP
        coc-go
        coc-html
        coc-json
        coc-markdownlint
        coc-nvim
        coc-python
        coc-rust-analyzer
        coc-vimlsp
        commentary        # comment stuff out
        defx-nvim         # File tree
        fugitive          # Git
        rainbow           # Rainbow paranthesis, brackets
        sensible          # Defaults everyone can agree on
        skim-vim          # File lookup
        vim-airline       # Statusbar
        vim-airline-themes
        vim-buffergator   # Buffer
        vim-indent-guides # visually displaying indent levels
        vim-signify       # Gutter with  mode
        vim-which-key     # Show key completion
        vista-vim         # Shows symbol with LSP

        # Language
        vim-nix
        #vim-addon-nix
        polyglot

        #
        # vim-indent-object
        #
        gruvbox-community
        palenight-vim
        onedark-vim
      ]);

      extraConfig = ''
        " Default settings
        set nocompatible
        set nobackup
        " Yup, I live on the edge
        set noswapfile
        set updatetime=100

        let g:mapleader = "\<Space>"
        let g:maplocalleader = ','

        " Colors/Theme
        set termguicolors
        colorscheme gruvbox
        let g:airline_theme = 'gruvbox'
        " let g:airline#extensions#tabline#left_sep = ' '
        " let g:airline#extensions#tabline#left_alt_sep = '|'
        " let g:airline#extensions#tabline#formatter = 'default'
        let g:airline_powerline_fonts = 1
        " let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
        " Display all buffers when only one tab is open
        let g:airline#extensions#tabline#enabled = 1


        " Basics
        syntax on

        set hidden      " Allows hidden buffer
        set hlsearch
        set smartcase
        filetype plugin on
        set listchars=tab:>-,trail:*
        set tabstop=2 softtabstop=2 shiftwidth=2
        set expandtab
        set number
        set relativenumber
        set scrolloff=5             " keep 5 lines of context when scrolling
        set lazyredraw              " do not redraw screen while executing a macro
        set splitbelow splitright
        set mouse=nv                " Enable mouse usage except in insert mode

        set formatoptions+=j   " remove a comment leader when joining lines.
        set formatoptions+=o   " insert the comment leader after hitting 'o'

        " Enable autocompletion
        set wildmode=longest,list,full

        " Live substitution
        set inccommand=nosplit

        " Disables automatic commenting on newline
        autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

        " Quick exit with `:Q`
        command Q qa

        nnoremap <leader>si :set spell!<CR>
        nnoremap <leader>l :set list!<CR>
        nnoremap <leader>S :%s//g<Left><Left>
        nnoremap <leader>m :set number!<CR>
        nnoremap <leader>n :set relativenumber!<CR>

        nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

        " FZF
        let g:fzf_command_prefix = 'Fzf'
        let g:fzf_buffers_jump = 1
        nnoremap <C-t> :FzfFiles!
        nnoremap <leader><space> :FzfFiles<CR>
        nnoremap <leader>. :FzfFiles %:p:h<CR>


        " Insert line above
        nnoremap [o O<Esc>j
        " Insert line below
        nnoremap ]o o<Esc>k
        " Copy till eol
        nnoremap Y y$
        " Comment lines with commentary.vim
        inoremap <silent> <M-;> <C-o>:Commentary<CR>
        nmap <silent> <M-;> gcc
        vmap <silent> <M-;> gc
        nmap <silent> <leader>; gcc
        vmap <silent> <leader>; gc
        " Buffer management
        autocmd VimEnter * silent! nunmap <leader>b
        nnoremap <leader>, <C-^>
        nnoremap <leader>b, <C-^>
        nnoremap <leader>bd :bd<CR>
        nnoremap <leader>bn :bnext<CR>
        nnoremap <leader>bN :enew<CR>
        nnoremap <leader>bp :bprevious<CR>
        nnoremap <leader>bi :FzfBuffers<CR>
        " Window management
        nnoremap <leader>w <C-w>

        " Finding things
        nnoremap <leader>ss :FzfBLines<CR>
        nnoremap <leader>sp :FzfRg<CR>

        " Git
        nnoremap <silent> <leader>gg :Gstatus<CR>
        nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>ge :Gedit<CR>

        " Enable rainbow paranthesis globally
        let g:rainbow_active = 1

        " Polyglot
        let g:polyglot_disabled = ['markdown']

        " Vista
        let g:vista_fzf_preview = ['right:30%']
        let g:vista#renderer#enable_icon = 1
        let g:vista#renderer#icons = {
        \   "function": "\uf794",
        \   "variable": "\uf71b",
        \  }

        autocmd! FileType which_key
        autocmd  FileType which_key set laststatus=0 noshowmode noruler
          \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

        au FileType gitcommit setlocal tw=68 colorcolumn=69 spell
      '';
    };

  }) config.icebox.static.users.ahmetde;

}
