{ pkgs, ... }:
{
  # when using virtio gpu, regreet shows a flipped mis-aligned cursor.

  # similarly, in hyprland I can see the flipped cursor which doesn't
  # match the hyprland cursor which is where it should be.

  # by disabling hardware cursors we force software rendering the
  # cursor. this will still show the broken flipped cursor on the
  # host but at least we can see the real cursor in regreet.

  environment.variables = {
    WLR_NO_HARDWARE_CURSORS = "1"; # gets regreet to draw cursor
    ZED_ALLOW_EMULATED_GPU = "1"; # zed editor complains
  };

  # mpv spams va-api/vdpau errors because of virtio.
  environment.etc."mpv/mpv.conf".text = ''
    vo=gpu
    gpu-api=opengl
    gpu-context=wayland
    hwdec=no
  '';

  nixpkgs.overlays = [
    (final: prev: {
      celluloid = pkgs.symlinkJoin {
        name = "celluloid";
        paths = [ prev.celluloid ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/celluloid \
            --set LIBGL_ALWAYS_SOFTWARE 1 \
            --set MESA_GL_VERSION_OVERRIDE 3.3
        '';
      };
    })
  ];

}
