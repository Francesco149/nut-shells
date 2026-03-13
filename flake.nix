{
  description = "flake templates based on nuts";
  outputs =
    { ... }:
    {
      templates = import ./templates.nix;
    };
}
