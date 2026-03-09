{ config, pkgs, lib, ... }:

{
  home.stateVersion = "25.11";

  home.username = "ciiruu";
  home.homeDirectory = lib.mkForce "/Users/ciiruu";

  home.packages = with pkgs; [
    # Nix hanya bertugas menginstal binary aplikasinya saja
    php83
    php83Packages.composer 
    pkg-config
    coreutils
  ];

  programs.home-manager.enable = true;

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  # Konfigurasi Mise yang minimalis
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    # globalConfig dihapus agar file ~/.config/mise/config.toml 
    # tidak dikelola oleh Nix (menjadi writable)
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Tetap aktifkan mise agar PATH otomatis terupdate saat buka terminal
      ${pkgs.mise}/bin/mise activate fish | source
    '';
  };
}
