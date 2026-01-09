{
  description = "CrossOver runtime wrapped in an FHS environment for NixOS";

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
        # Core system libs
        glibc
        gcc
        zlib
        dbus
        fuse
        coreutils

        # GTK stack
        gtk3
        gtk4
        gsettings-desktop-schemas
        libxkbcommon

        # XML + NSS
        libxml2
        libxslt
        nss
        nspr

        # Printing + audio
        cups
        alsa-lib
        pulseaudio

        # Graphics + Vulkan
        libGL
        libGLU
        mesa
        mesa_drivers
        vulkan-loader
        vulkan-tools
        vulkan-validation-layers

        # Fonts + images
        fontconfig
        freetype
        libpng
        libjpeg
        libtiff

        # X11 stack
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

        # Python + Perl
        python3
        perl

        # Fixes for CrossOver warnings
        openssl
        gobject-introspection
        pygobject3
        vte
        vte-gtk3
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
