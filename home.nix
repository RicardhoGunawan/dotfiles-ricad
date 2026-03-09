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
        node = "20"; # Disarankan kunci ke versi spesifik daripada "latest" agar stabil
      };
      settings = {
        experimental = true;
        asdf_compat = true;
        # Tambahkan ini agar mise otomatis mendownload tanpa bertanya
        all_plugin_versions = true;
      };
    };
  };
}
