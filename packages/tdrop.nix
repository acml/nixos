{ stdenv, lib, fetchFromGitHub, makeWrapper
, xwininfo, xdotool, xprop, gawk, coreutils
, gnugrep, procps }:

stdenv.mkDerivation {
  pname = "tdrop";
  version = "unstable-2021-01-20";

  src = fetchFromGitHub {
    owner = "noctuid";
    repo = "tdrop";
    rev = "bae687d38584824a61e34f12be0a298d74bcb411";
    sha256 = "162i17974g02mwg8a1s5z3i29h9ykpnsnd27cwmrzq3g7b1qgsfn";
  };

  dontBuild = true;

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = let
    binPath = lib.makeBinPath [
      xwininfo
      xdotool
      xprop
      gawk
      coreutils
      gnugrep
      procps
    ];
  in ''
    wrapProgram $out/bin/tdrop --prefix PATH : ${binPath}
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "A Glorified WM-Independent Dropdown Creator";
    homepage = "https://github.com/noctuid/tdrop";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wedens ];
  };
}
