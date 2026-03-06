{ config, pkgs, lib, ... }:

{
  home.stateVersion = "25.11";

  home.username = "ciiruu";
  home.homeDirectory = lib.mkForce "/Users/ciiruu";

  home.packages = with pkgs; [
    mise
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

  programs.mise = {
    enable = true;
    enableFishIntegration = true;

    globalConfig = {
      tools = {
        node = "latest"; 
      };
      # Perbaikan struktur settings
      settings = {
        # Kita hapus autoinstall jika mise versi Anda belum mendukungnya
        # atau gunakan asdf_compat untuk stabilitas lebih baik
        asdf_compat = true;
        experimental = true;
      };
    };
  };
}
