{
  description = "Ciiruu darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Optional: Declarative tap management
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
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      # Search available package. visit https://search.nixos.org/packages
      # $ nix search nixpkgs pkg_name
      nixpkgs.config.allowUnfree = true;
	  nixpkgs.config.permittedInsecurePackages = [
	        "openssl-1.1.1w"
      ];
      environment.systemPackages = with pkgs; [
        coreutils
        curl
        mkalias
        stow
        vim
        wget
        jq
        yq
		openssl_1_1
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
        brews = [
          "mise"
          "mkcert"
 		  # Compiling PHP
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
          "docker-desktop"
          "google-chrome"
          "postman"
	      "android-studio"
          "the-unarchiver"
          "visual-studio-code"
          "whatsapp"
          "ngrok"
          "openvpn-connect"
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

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;

	  programs.fish.shellInit = ''
        # Setup Homebrew PATH
        if test -f /opt/homebrew/bin/brew
          eval (/opt/homebrew/bin/brew shellenv)
        end

        # Inisialisasi mise
        if command -v mise > /dev/null
          mise activate fish | source
        end

        # --- FIX PHP 7.3 DENGAN NIX OPENSSL ---
        # Kita arahkan ke profile default nix yang berisi openssl_1_1
        if test -d /run/current-system/sw/include/openssl
            set -gx PHP_BUILD_CONFIGURE_OPTS "--with-openssl=/run/current-system/sw"
        end
      '';
      users.users.ciiruu = {
          home = "/Users/ciiruu";
          shell = pkgs.fish;
      };
      environment.shells = with pkgs; [
        fish
      ];

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mac
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ciiruu = import ./home.nix;
        }
      ];
    };
  };
}
