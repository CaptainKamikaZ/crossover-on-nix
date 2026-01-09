{
  description = "Launch installed CrossOver runtime inside FHS sandbox";

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
      name = "crossover-runtime";

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

        perl
        python3
        coreutils
      ];

      runScript = ''
        ~/cxoffice/bin/crossover
      '';
    };

    apps.${system}.crossover = {
      type = "app";
      program = "${self.packages.${system}.crossover}/bin/crossover-runtime";
    };
  };
}
