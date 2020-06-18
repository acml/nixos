# Fetch my wallpapers from git
with import <nixpkgs> {};

stdenv.mkDerivation {
  name    = "schmich-wallpapers";

  src = fetchGit {
    # url = "https://github.com/kijart/bing-daily-images-dl.git"
    # url = "https://github.com/facefruit/daily-bing-wallpaper.git"
    url = "https://github.com/schmich/wallpapers.git";
    ref = "wallpapers";
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
