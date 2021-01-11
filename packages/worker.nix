{ stdenv
, fetchurl
, avfs
, dbus-glib
, file
, libX11
, libXft
, libXinerama
, lua
, openssl
, pkgconfig
, udisks
}:

stdenv.mkDerivation rec {
  pname = "worker";
  version = "4.6.1";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/${pname}-${version}.tar.bz2";
    sha256 = "0vj3ankz9z15ndc1yjxc0sv1g0s4p868dh5pwl8nwjhyp8gb6xg3";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    # avfs
    dbus-glib
    file
    lua
    openssl
    udisks
    libX11
    libXft
    libXinerama
  ];

  meta = with stdenv.lib; {
    description = "A two-pane file manager with advanced file manipulation features";
    homepage = "http://www.boomerangsworld.de/cms/worker/index.html";
    license =  licenses.gpl2;
    maintainers = [];
  };
}
