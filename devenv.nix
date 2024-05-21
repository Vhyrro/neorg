{
  pkgs,
  lib,
  config,
  inputs,
  gen-luarc,
  ...
}: let
  neorg-dependencies = builtins.fromJSON (builtins.readFile ./res/deps.json);
  luarc = pkgs.mk-luarc {
    plugins = builtins.attrNames neorg-dependencies;
  };
in {
  name = "neorg";

  env.NVIM_APPNAME = "nvimneorg";

  languages.lua = {
    enable = true;
    package = pkgs.luajit;
  };

  # Set up packages for the developer and testing environment. Explanation of some packages:
  # - `tree-sitter` - for `tree-sitter-build` to work
  # - `imagemagick` - for testing `image.nvim` integrations
  packages = with pkgs; [imagemagick git wget tree-sitter gcc luajitPackages.luarocks luajitPackages.magick neovim];

  enterShell =
    # TODO(vhyrro): Hook these up to the user's Neovim instance (somehow) | lib.attrsets.foldlAttrs (acc: name: version: "luarocks install --force-lock --local ${name} ${version}" + "\n" + acc) "" neorg-dependencies +
    ''
      ln -fs ${pkgs.luarc-to-json luarc} .luarc.json
    '';

  enterTest = ''
    echo "* Hello World!" > example.norg

    # Open example.norg to trigger all of Neorg's features
    nvim --headless -u ./.github/kickstart.lua -c wq example.norg

    rm example.norg

    if [ ! -f success ]; then
      echo "Integration test failed!"
      exit 1
    fi

    rm success
  '';
}
