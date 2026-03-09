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
      settings = {
        experimental = true;
        asdf_compat = true;
      };
    };
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Ini akan memasukkan binary dari mise (termasuk node) ke dalam PATH kamu secara otomatis
      ${pkgs.mise}/bin/mise activate fish | source
    '';
  };
}
