self: super: {
  fprintd = (super.callPackage ../packages/fprintd.nix {
    libpam-wrapper = (super.callPackage ../packages/libpam-wrapper.nix { });
  });
  libfprint = (super.callPackage ../packages/libfprint.nix { });
  howdy = (super.callPackage ../packages/howdy.nix { });
  pam_python = (super.callPackage ../packages/pam_python.nix { });
  ir_toggle = (super.callPackage ../packages/ir_toggle.nix { });
  simple-obfs = (super.callPackage ../packages/simple-obfs.nix { });
}