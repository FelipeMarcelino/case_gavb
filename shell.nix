
with import <nixpkgs> {};
let 
  pythoEnv = python38.withPackages (ps: [
    ps.pynvim
    ps.pydocstyle
    ps.bandit
    ps.flake8
    ps.debugpy
    ps.matplotlib
    ps.numpy
    ps.pandas
    ps.pip
    ps.virtualenvwrapper
  ]);
in mkShell {
  name = "GAVB";
  buildInputs = [
    pythoEnv
    yarn
    cudatoolkit_11_0
    cudnn_cudatoolkit_11_0
    nodejs
    stdenv
    libpqxx
    zlib
    zlib.dev
    libffi
    libffi.dev
  ];
  shellHook = ''
    # Allow the use of wheels.
    SOURCE_DATE_EPOCH=$(date +%s)
    # Augment the dynamic linker path
    VENV=venv
    if test ! -d $VENV; then
      virtualenv $VENV
    fi
    source ./$VENV/bin/activate
    export PYTHONPATH=`pwd`/$VENV/${python.sitePackages}/:$PYTHONPATH
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [ glib stdenv.cc.cc.lib cudatoolkit_11_0 cudnn_cudatoolkit_11_0
    xorg.libX11 freeglut libGLU libGL linuxPackages.nvidia_x11 oracle-instantclient]}
    export LD_LIBRARY_PATH=$(nixGLNvidia printenv LD_LIBRARY_PATH):$LD_LIBRARY_PATH
    '';
}
