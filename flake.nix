{
  description = "CrossOver wrapper for NixOS using FHS environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

  in {
    packages.${system}.crossover = pkgs.buildFHSEnvBubblewrap {
      name = "crossover";

      targetPkgs = pkgs: with pkgs; [
        glibc
        gcc
        zlib
        dbus
        fuse
        gtk3
        gtk4
        gsettings-desktop-schemas
        libxkbcommon
        libxml2
        libxslt
        nss
        nspr
        cups
        alsa-lib
        pulseaudio
        libGL
        libGLU
        mesa
        mesa_drivers
        vulkan-loader
        vulkan-tools
        vulkan-validation-layers

        fontconfig
        freetype
        libpng
        libjpeg
        libtiff

        xorg.libXrandr
        xorg.libXrender
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXfixes
        xorg.libXext
        xorg.libX11
        xorg.libXi
        xorg.libXcursor
        xorg.libXinerama
        xorg.libXxf86vm
      ];

      runScript = ''
        bash /home/justin/packages/crossover-on-nix/install-crossover-24.0.6.bin
      '';
    };

    apps.${system}.crossover = {
      type = "app";
      program = "${self.packages.${system}.crossover}/bin/crossover";
    };
  };
}
