{ config, pkgs, lib, ... }:

{
  home.stateVersion = "25.11";
  home.username = "ciiruu";
  home.homeDirectory = lib.mkForce "/Users/ciiruu";

  home.packages = with pkgs; [
    # PHP dan Composer dihapus dari sini agar tidak bentrok dengan mise
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
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${pkgs.mise}/bin/mise activate fish | source
    '';
  };
}
