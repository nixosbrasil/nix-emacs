{pkgs ? import <nixpkgs> {}}:
let
  example = pkgs.callPackage ./example.nix {};
  optionsDoc =  pkgs.nixosOptionsDoc {
    inherit (example) options;
  };
in pkgs.runCommandNoCC "doc.html" {
  buildInputs = with pkgs; [ pandoc ];
} ''
  pandoc ${optionsDoc.optionsDocBook} -o $out -f docbook -t html
''
