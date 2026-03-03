{
  description = "Ricardho darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = inputs@{
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    ...
  }:
  let
    configuration = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        coreutils
        curl
        mkalias
        stow
        vim
        wget
        jq
        yq
      ];

      fonts.packages = with pkgs; [
        jetbrains-mono
        openmoji-color
        powerline-symbols
      ];

      homebrew = {
        enable = true;
        onActivation = {
          cleanup = "zap";
          autoUpdate = true;
          upgrade = true;
        };
        taps = [
          "ddev/homebrew-ddev"
          "symfony-cli/homebrew-tap"
        ];
        brews = [
          "act"
          "cloudflared"
          "mise"
          "autoconf"
          "re2c"
          "bison"
          "pkg-config"
          "libiconv"
          "gd"
          "gmp"
          "libsodium"
          "libpq"
          "readline"
          "gettext"
          "bzip2"
          "curl"
          "libffi"
          "libxml2"
          "libxslt"
          "zlib"
          "icu4c"
          "oniguruma"
          "libzip"
        ];
        casks = [
          "antigravity"
          "cloudflare-warp"
          "mysql-workbench" # Pindah ke sini agar tidak error
          "docker"           # Nama resmi di brew adalah 'docker'
          "ghostty"
          "google-chrome"
          "postman"
          "the-unarchiver"
          "visual-studio-code"
          "vlc"
          "whatsapp"
          "ngrok"
        ];
      };

      system.primaryUser = "ricardhogunawan";

      system.defaults = {
        dock = {
          autohide = true; # Sudah saya set ke true sesuai keinginanmu
          mru-spaces = false;
          persistent-apps = [
            "/System/Applications/System Settings.app"
            "/System/Applications/Utilities/Activity Monitor.app"
            "/Applications/Google Chrome.app"
            "/Applications/Ghostty.app"
            "/Applications/Antigravity.app"
            "/Applications/WhatsApp.app"
          ];
        };
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleShowAllExtensions = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.KeyRepeat = 2;
        NSGlobalDomain.InitialKeyRepeat = 15;
        NSGlobalDomain.ApplePressAndHoldEnabled = false;
        loginwindow.GuestEnabled = false;
        finder.FXPreferredViewStyle = "clmv";
        finder.AppleShowAllExtensions = true;
        screencapture.location = "~/Pictures/screenshots";
      };

      nix.settings.experimental-features = "nix-command flakes";

      programs.fish.enable = true;
      users.users.ricardhogunawan = {
          home = "/Users/ricardhogunawan";
          shell = pkgs.fish;
      };
      environment.shells = with pkgs; [
        fish
      ];

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 5;
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ricardhogunawan = import ./home.nix;
        }
      ];
    };
  };
}
