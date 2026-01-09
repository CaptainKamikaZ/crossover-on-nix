{
  description = "CrossOver wrapper for NixOS using FHS environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";

    # Import nixpkgs with overlays to expose buildFHSUserEnv
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (final: prev: {
          buildFHSUserEnv = import "${nixpkgs}/nixos/lib/build-fhs-user-env.nix" final;
        })
      ];
    };
  in {
    packages.${system}.crossover = pkgs.buildFHSUserEnv {
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
        libxrandr
        libxrender
        libxcomposite
        libxdamage
        libxfixes
        libxext
        libx11
        libxi
        libxcursor
        libxinerama
        libxxf86vm
      ];

      runScript = ''
        bash /home/justin/packages/crossover-on-nix/install-crossover-24.0.6.bin
      '';

      extraMounts = [
        {
          source = "/home/justin/.cxoffice";
          target = "/home/justin/.cxoffice";
        }
      ];
    };

    apps.${system}.crossover = {
      type = "app";
      program = "${self.packages.${system}.crossover}/bin/crossover";
    };
  };
}
