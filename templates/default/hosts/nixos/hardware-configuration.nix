{
  assertions = [
    {
      assertion = false;
      message = ''
        =========================================================================
        please provide your machine's hosts/nixos/hardware-configuration.nix

        copy it over or run this on the target machine:

          nixos-generate-config --dir ./hosts/nixos/ --force

        =========================================================================
      '';
    }
  ];
}
