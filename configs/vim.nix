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

    " Easy Align
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)
  '';
  # https://breuer.dev/blog/nixos-home-manager-neovim
  customVimPluginGit = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}"; 
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };
  customVimPluginGitLatest = customVimPluginGit "HEAD";
in {
  programs.vim = {
    enable = true;
    extraConfig = scriptVim;
  };
  programs.neovim = {
    enable = true;
    extraConfig = builtins.concatStringsSep "\n" [
      scriptVim
      scriptNeovim
      ''
      luafile ${builtins.toString ./nvim/completion.lua}
      luafile ${builtins.toString ./nvim/lualine.lua}
      ''
    ];

    plugins = with pkgs.vimPlugins; [
      vim-sexp
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
      nvim-lspconfig
      rust-tools-nvim
      vim-ocaml
      # neodev-nvim
      # (customVimPluginGitLatest "ms-jpq/coq.thirdparty")
      # (customVimPluginGitLatest "ms-jpq/coq.artifacts")
      # (customVimPluginGitLatest "janet-lang/janet.vim")
      # (customVimPluginGitLatest "Olical/conjure")
      # (customVimPluginGitLatest "bakpakin/fennel.vim")
    ];
  };
}
