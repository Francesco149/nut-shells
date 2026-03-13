#
# this allows us to do:
# 
#   ns foo bar github:some/flake#baz
#
# instead of:
#
#   nix shell nixpgks#foo nixpkgs#bar github:some/flake#baz
#

set -l pkgs
for arg in $argv
  if string match -q '*#*' -- $arg
    set -a pkgs $arg
  else
    set -a pkgs "nixpkgs#$arg"
  end
end
nix shell $pkgs
