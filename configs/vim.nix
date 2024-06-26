{ config, pkgs, lib, ... }:
let
  scriptVim = ''
    " Essential
    set number                        " nu   ; show line number
    set relativenumber                " rnu  ; show relative line number
    set scrolloff=999                 " so   ; always put the cursor between screen vertically
    " set sidescrolloff=999           " siso ; always put the cursor between screen horizontally
    set textwidth=80                  " tw   ; set line length to 80
    set colorcolumn=80                " cc   ; highlight the maximal line length
    highlight ColorColumn ctermbg=238 "      ; set the highlighting color to red
    set nowrap                        "      ; make sure that text is not line-wrapped

    " Indentation
    set autoindent    " ai  ; copy indent from current line when starting a new line
    set smartindent   " si  ; do smart autoindenting when starting a new line
    set expandtab     " et  ; convert tab to spaces
    set tabstop=4     " ts  ; number of spaces a <Tab> in the file counts for
    set softtabstop=4 " sts ; number of spaces a <Tab> counts for while performing editing operations
    set shiftwidth=4  " sw  ; number of spaces to use for each step of (auto)indent

    " Windows
    set splitbelow " sb
    set splitright " spr

    " Syntax Highlighting
    syntax on
    filetype plugin on
    filetype plugin indent on

    " Other Options
    set background=dark " ; To fix Vim color within tmux

    " Clipboard Related
    function! s:setClipboard()
        set clipboard=unnamedplus
    endfunction
    function! s:unsetClipboard()
        set clipboard=unnamedplus
    endfunction

    command! SetClipboard :call s:setClipboard()
    command! UnsetClipboard :call s:unsetClipboard()
  '';
  scriptNeovim = ''
    " Neovim Specific
    set nohlsearch " nohl ; no highlight on searching
    nnoremap Y yy

    " Colorscheme Nord
    let g:nord_disable_background = v:true
    colorscheme nord

    " Lualine
    lua << END
    require('lualine').setup()
    END

    " Vim Slime
    let g:slime_target = "tmux"
    let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
    let g:slime_dont_ask_default = 1
    autocmd FileType markdown let g:slime_cell_delimiter = "```"
    autocmd FileType scheme let g:slime_cell_delimiter = ";;;"
    nmap <c-c><c-s> <Plug>SlimeSendCell

    " Easy Align
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)
  '';
  # https://breuer.dev/blog/nixos-home-manager-neovim
  customVimPluginGit = repo: rev: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}"; 
    version = rev;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      rev = rev;
    };
  };
in {
  programs.vim = {
    enable = true;
    extraConfig = scriptVim;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = builtins.concatStringsSep "\n" [
      scriptVim
      scriptNeovim
      ''
      luafile ${builtins.toString ./nvim/completion.lua}
      luafile ${builtins.toString ./nvim/lualine.lua}
      luafile ${builtins.toString ./nvim/firenvim.lua}
      ''
    ];

    plugins = with pkgs.vimPlugins; [
      vim-sexp
      # (customVimPluginGit "vim-slime" "d762ef02947cf2f4cebdc6ccbdd90ffcc0c11a1b")
      vim-slime
      vim-nix
      vim-commentary
      vim-exchange
      vim-repeat
      vim-surround
      vim-ReplaceWithRegister
      vim-easy-align
      vim-obsession
      fzf-vim
      auto-pairs
      nord-nvim
      lualine-nvim
      coq_nvim
      # coq-thirdparty
      nvim-lspconfig
      rust-tools-nvim
      vim-ocaml
      (customVimPluginGit "rvmelkonian/move.vim" "d762ef02947cf2f4cebdc6ccbdd90ffcc0c11a1b")
      # (customVimPluginGit "nvim-treesitter/nvim-treesitter" "f2778bd1a28b74adf5b1aa51aa57da85adfa3d16")
      nvim-treesitter.withAllGrammars
      go-nvim
      firenvim
      typst-vim
      # codeium-vim
      # Run this afterwards
      #
      #   nvim --headless "+call firenvim#install(0) | q"

      # nvim-dap
      # nvim-dap-go
      # neodev-nvim
      # (customVimPluginGitLatest "ms-jpq/coq.thirdparty")
      # (customVimPluginGitLatest "ms-jpq/coq.artifacts")
      # (customVimPluginGitLatest "janet-lang/janet.vim")
      # (customVimPluginGitLatest "bakpakin/fennel.vim")
      (customVimPluginGit "hwayne/tla.vim" "0d6d453a401542ce1db247c6fd139ac99b8a5add")
    ];
  };
}
