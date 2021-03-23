{ stdenv, lib, fetchFromGitHub, makeWrapper
, xwininfo, xdotool, xprop, gawk, coreutils
, gnugrep, procps }:

stdenv.mkDerivation {
  pname = "tdrop";
  version = "unstable-2021-01-20";

  src = fetchFromGitHub {
    owner = "noctuid";
    repo = "tdrop";
    rev = "89938c1483821c3924ca4e298d38f85f63961781";
    sha256 = "1h6m9palxjpz05a3jxbszxriqgz8n4vz63zwkrdk2fkfdy427ccy";
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
