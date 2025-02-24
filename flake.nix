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
                  name = "tokyonight";
                  style = "night";
                };

                statusline.lualine.enable = true;
                telescope.enable = true;
                autocomplete.nvim-cmp.enable = true;
                languages = {
                  enableLSP = true;
                  enableTreesitter = true;

                  nix.enable = true;
                  ts.enable = true;
                  rust.enable = true;
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

                # Enable image.nvim integration with Neorg
                utility.images.image-nvim = {
                  setupOpts = {
                    integrations = {
                      neorg = {
                        enable = true;  # Enable image.nvim in Neorg files
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