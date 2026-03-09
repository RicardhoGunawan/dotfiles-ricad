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
      # 1. Inisialisasi Homebrew (WAJIB PERTAMA)
      if test -d /opt/homebrew/bin
        /opt/homebrew/bin/brew shellenv | source
      end

      # 2. Tambahkan PHP ke PATH secara eksplisit (Pake -p agar jadi prioritas)
      fish_add_path -p /opt/homebrew/opt/php@8.3/bin
      fish_add_path -p /opt/homebrew/opt/php@8.3/sbin

      # 3. Baru aktifkan mise
      ${pkgs.mise}/bin/mise activate fish | source
    '';
   };
}
