{...}:
{
  imports = [
    ./nogui.nix
    ./warnings.nix
    ./language-support/nix.nix
    ./language-support/markdown.nix
    ./themes

    ./org
    ./evil

    ./workarounds
    ./performance
    ./traits
  ];
}
