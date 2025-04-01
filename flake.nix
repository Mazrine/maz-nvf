{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    tidalcycles.url = "github:mitchmindtree/tidalcycles.nix";  # Add the tidalcycles input
  };

  outputs = { nixpkgs, tidalcycles, nvf, ... } @ inputs: {
    packages.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux.extend tidalcycles.overlays.default;  # Use overlays.default
    in {
      # Set the default package to the wrapped instance of Neovim.
      default =
        (nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            {
              config.vim = {
                theme = {
                  enable = true;
                  name = "base16";  # Ativa o suporte a cores personalizadas
                   base16-colors = {
                    base00 = "#1c0c28"; # Deep aubergine background (unchanged)
                    base01 = "#301b4d"; # Rich deep purple background
                    base02 = "#432775"; # Bold purple mid-background
                    base03 = "#5c3a9e"; # Vivid purple for comments
                    base04 = "#7b52c7"; # Bright medium purple for highlights
                    base05 = "#00D2F7"; # Bright cyan for primary text (unchanged)
                    base06 = "#59c7ff"; # Sky blue for soft highlights
                    base07 = "#ffffff"; # Pure white for maximum contrast
                    base08 = "#8f45ff"; # Bold violet-purple for warnings/errors
                    base09 = "#8AA3FE"; # Deep azure-cyan for accents
                    base0A = "#6d4db8"; # Royal purple for highlights/warnings
                    base0B = "#00D974"; # Deep cyan for success
                    base0C = "#00ddff"; # Bright cyan for additional accent
                    base0D = "#4264d9"; # Indigo blue for links/selections
                    base0E = "#9963ff"; # Bright purple for emphasis/keywords
                    base0F = "#7640cc"; # Deep violet-purple for special elements
                  };
                  transparent = false;  # Define se o fundo deve ser transparente
                };

                statusline.lualine.enable = true;
                tabline.nvimBufferline.enable = true;
                assistant.codecompanion-nvim.enable = true;
                telescope.enable = true;
                filetree.neo-tree.enable = true;
                autocomplete.nvim-cmp.enable = true;
                languages = {
                  enableLSP = true;
                  enableTreesitter = true;

                  nix.enable = true;
                  ts.enable = true;
                  rust.enable = true;
                  markdown.enable = true;
                };

                # Add the vim-tidal plugin
                startPlugins = [
                  pkgs.vimPlugins.vim-tidal  # Use the vim-tidal plugin from the tidalcycles overlay
                ];

                # Enable and configure Neorg
                notes.neorg = {
                  enable = true;  # Enable Neorg
                  setupOpts = {
                    load = {
                      "core.defaults" = {
                        enable = true;  # Enable core.defaults for a "just works" experience
                        config.disable = [];  # Optionally disable specific modules if needed
                      };
                    };
                  };
                  treesitter = {
                    enable = true;  # Enable Neorg treesitter
                    norgPackage = pkgs.vimPlugins.nvim-treesitter.builtGrammars.norg;  # Use the norg treesitter package
                  };
                };
                utility.vim-wakatime.enable = true;

                # Enable image.nvim integration with Neorg
                utility.images.image-nvim = {
                  setupOpts = {
                    integrations = {
                      neorg = {
                        enable = true;  # Enable image.nvim in Neorg filesh
                        clearInInsertMode = false;  # Whether to clear images in insert mode
                        downloadRemoteImages = false;  # Whether to download remote images
                        filetypes = [ "neorg" ];  # Filetypes to enable image.nvim in
                        onlyRenderAtCursor = false;  # Whether to only render images at the cursor
                      };
                    };
                  };
                };
              };
            }
          ];
        })
        .neovim;
    };
  };
}
