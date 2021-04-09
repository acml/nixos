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
  version = "4.8.0";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/${pname}-${version}.tar.bz2";
    sha256 = "0rb57dv0hs51sfkjs24icyy1xny0rb67q6jjq8rimawdjpyp9c7n";
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
