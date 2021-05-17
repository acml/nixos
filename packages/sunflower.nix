{ python3
, lib
, fetchFromGitHub
, fetchpatch
, gtk3
, glib
, libnotify
, vte
, gvfs
, gsettings-desktop-schemas
, gnome3
, gobject-introspection
, wrapGAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sunflower";
  version = "2021-03-08-unstable";

  src = fetchFromGitHub {
    owner = "MeanEYE";
    repo = "Sunflower";
    rev = "be06112aa9023f2a7ca5c9fc1fcb86e4c752b439";
    sha256 = "0xbx27i81qp9xfzhngy8xfimm81c1zgx0j8yfsiwb1xn6h6s5gm8";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libnotify
    vte
    gvfs
    gsettings-desktop-schemas # for font settings
    gnome3.libgnome-keyring
  ];

  propagatedBuildInputs = [
    python3.pkgs.pygobject3
    python3.pkgs.chardet
  ];

  # See https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  # There are no tests.
  doCheck = false;

  postPatch = ''
    # Outside of Nix, Python modules are installed under Python’s prefix
    # or into a virtual environment, that overrides sys.prefix.
    # https://docs.python.org/3/library/sys.html#sys.prefix
    # We do neither so we need to override the variable ourselves.
    echo "import sys; sys.prefix = '${placeholder "out"}'" | cat - sunflower/__init__.py > temp && mv temp sunflower/__init__.py
  '';

  meta = with lib; {
    description = "Small and highly customizable twin-panel file manager for Linux with support for plugins";
    homepage = "https://sunflower-fm.org/";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
