{
  description = "Standalone NVF neovim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };


outputs = {nixpkgs, ...} @ inputs: {
    packages.x86_64-linux = {
      default =
        (inputs.nvf.lib.neovimConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          modules = [
           ./default.nix 
          ];
        })
        .neovim;
    };
    
    nvfModule = import ./default.nix;
  };

}
