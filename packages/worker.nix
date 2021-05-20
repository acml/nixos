{ stdenv
, lib
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
  version = "4.8.1";

  src = fetchurl {
    url = "http://www.boomerangsworld.de/cms/worker/downloads/${pname}-${version}.tar.bz2";
    sha256 = "1071hyjmwgcbns1nnw705dhfzxvsyvid8yd5wqd4mlnfgmpbkly8";
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

  meta = with lib; {
    description = "A two-pane file manager with advanced file manipulation features";
    homepage = "http://www.boomerangsworld.de/cms/worker/index.html";
    license =  licenses.gpl2;
    maintainers = [];
  };
}
