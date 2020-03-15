{ config, pkgs, ... }:

{
  # Enable TRIM Service (May have security concern here)
  services.fstrim.enable = true;

  # Enable GNU Agent in order to make GnuPG works.
  programs.gnupg.agent.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;

  # Libvirtd
  virtualisation.libvirtd.enable = true;
  users.extraGroups.libvirtd.members = [ "ash" ];

  # OpenGL 32 bit support for steam
  hardware.opengl.driSupport32Bit = true;

  # Configuration of pulseaudio to facilitate bluetooth headphones and Steam.
  hardware.pulseaudio = {
    enable = true;
    # 32 bit support for steam.
    support32Bit = true;
    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
  };

  # Enable fwupd service
  services.fwupd.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
}
