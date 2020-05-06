# Fetch my wallpapers from git
with import <nixpkgs> {};

stdenv.mkDerivation {
  name    = "schmich-wallpapers";

  src = fetchgit {
    url    = "https://github.com/schmich/wallpapers.git";
    rev    = "e09f3b279e59f261a78305d9bbfd1881820e4812";
    sha256 = "1yzz6v4iyah3crwxh3mfjwf833ssakfvnl1sc07accjyh3bdjgyr";
  };

  installPhase = ''
    mkdir -p $out/share/wallpapers
    cp -r $src/wallpapers/* $out/share/wallpapers
  '';

  meta = with stdenv.lib; {
    description = "schmich's wallpaper collection";
    platforms = platforms.all;
  };
}
