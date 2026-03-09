{
  description = "Ciiruu macOS system configuration";

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

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
  let
    system = "aarch64-darwin";

    configuration = { pkgs, ... }: {

      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = with pkgs; [

        # basic cli
        coreutils
        curl
        wget
        jq
        yq

        # utilities
        git
        vim
        stow

        # dev tools
        mise
        act
        cloudflared
      ];

      fonts.packages = with pkgs; [
        jetbrains-mono
        powerline-symbols
        openmoji-color
      ];

      homebrew = {
        enable = true;

        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "zap";
        };

        brews = [
          "autoconf"
          "bison"
          "pkg-config"
          "re2c"
        ];

        casks = [

          # browsers
          "google-chrome"

          # development
          "visual-studio-code"
          "docker-desktop"
          "postman"
          "datagrip"

          # networking
          "cloudflare-warp"
          "ngrok"
          "openvpn-connect"

          # utilities
          "the-unarchiver"
          "vlc"

          # communication
          "whatsapp"

          # apps you already use
          "antigravity"
        ];
      };

      system.primaryUser = "ciiruu";

      system.defaults = {

        dock = {
          autohide = true;
          mru-spaces = false;
          persistent-apps = [
            "/System/Applications/Apps.app"
            "/System/Applications/System Settings.app"
            "/System/Applications/Utilities/Activity Monitor.app"
            "/Applications/Google Chrome.app"
            "/Applications/Antigravity.app"
            "/Applications/WhatsApp.app"
          ];
        };

        NSGlobalDomain = {
          AppleInterfaceStyle = "Dark";
          AppleICUForce24HourTime = true;
          AppleShowAllExtensions = true;
          KeyRepeat = 2;
          InitialKeyRepeat = 15;
          ApplePressAndHoldEnabled = false;
        };

        finder = {
          FXPreferredViewStyle = "clmv";
          AppleShowAllExtensions = true;
        };

        screencapture.location = "~/Pictures/screenshots";

        loginwindow.GuestEnabled = false;
      };

      programs.fish.enable = true;

      users.users.ciiruu = {
        home = "/Users/ciiruu";
        shell = pkgs.fish;
      };

      environment.shells = with pkgs; [ fish ];

      nix.settings.experimental-features = "nix-command flakes";

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 5;

      nixpkgs.hostPlatform = system;
    };

  in {
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.ciiruu =
            import ./home.nix;
        }
      ];
    };
  };
}
