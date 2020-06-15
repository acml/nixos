{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "emacs-sandbox-1.0.0";
  hardeningDisable = [ "format" ];
  src = fetchFromGitHub {
    owner = "alphapapa";
    repo = "emacs-sandbox.sh";
    rev = "f3d2838b56b18ea3573adcf04effd25d57239a7a";
    sha256 = "0vnzyfz8y5p6l1llf9066fypbbdq0rvkqyacb14flzyw0v66iakg";
  };

  installPhase = ''
    mkdir -p $out/bin

    cp emacs-sandbox.sh $out/bin/
    chmod +x $out/bin/emacs-sandbox.sh
    '';
}
