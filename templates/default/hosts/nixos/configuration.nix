{
  assertions = [
    {
      assertion = false;
      message = ''
        =========================================================================
        please provide your machine's hosts/nixos/configuration.nix

        copy it over or run this on the target machine:

          nixos-generate-config --dir ./hosts/nixos/ --force

        just make sure to migrate over any customization from your /etc/nixos one
        =========================================================================
      '';
    }
  ];

  # example of what this file usually looks like from a graphical install

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  system.stateVersion = "25.11";
}
