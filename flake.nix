{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {nixpkgs, ...} @ inputs: {
    packages.x86_64-linux = {
      # Set the default package to the wrapped instance of Neovim.
      # This will allow running your Neovim configuration with
      # `nix run` and in addition, sharing your configuration with
      # other users in case your repository is public.
      default =
        (inputs.nvf.lib.neovimConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
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
              };
            }
          ];
        })
        .neovim;
    };
  };
}