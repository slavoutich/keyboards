{ pkgs, config, ... }:

let
  avr = pkgs.pkgsCross.avr.buildPackages;
in
{
  # A single Python for both QMK and ZMK. The qmk CLI goes in as a module
  # rather than as its own package: on its own it brings a separate python3
  # that could shadow this one on PATH, and Zephyr's CMake finds Python via
  # PATH. Zephyr's list is its requirements-base.txt (as in zmk-nix's dev
  # shell), plus protobuf/grpcio-tools for ZMK Studio-enabled builds.
  packages = [
    (pkgs.python3.withPackages (ps: [
      (ps.toPythonModule pkgs.qmk)

      ps.west
      ps.pyelftools
      ps.pyyaml
      ps.pykwalify
      ps.canopen
      ps.packaging
      ps.progress
      ps.psutil
      ps.pylink-square
      ps.pyserial
      ps.requests
      ps.anytree
      ps.intelhex
      ps.protobuf
      ps.grpcio-tools
    ]))

    # qmk's toolchains and flashers. Its package propagates these, but a
    # Python env only picks up Python modules, so they're listed again.
    pkgs.gcc-arm-embedded
    pkgs.gnumake
    avr.gcc
    avr.binutils
    pkgs.pkgsCross.avr.libc
    pkgs.avrdude
    pkgs.bootloadhid
    pkgs.dfu-programmer
    pkgs.dfu-util
    pkgs.teensy-loader-cli
    pkgs.wb32-dfu-updater

    # Zephyr build tools
    pkgs.cmake
    pkgs.ninja
    pkgs.protobuf
  ];

  # nixpkgs has no Zephyr SDK, so ZMK builds use Zephyr's gnuarmemb
  # toolchain variant with gcc-arm-embedded, as zmk-nix does.
  #
  # QMK paths are set here instead of via `qmk config` so they don't leak
  # into the global ~/.config/qmk/qmk.ini. A user.qmk_home set there takes
  # precedence over QMK_HOME, so it must stay unset.
  env = {
    ZEPHYR_TOOLCHAIN_VARIANT = "gnuarmemb";
    GNUARMEMB_TOOLCHAIN_PATH = "${pkgs.gcc-arm-embedded}";
    QMK_HOME = "${config.devenv.root}/bastardkb-qmk";
    QMK_USERSPACE = "${config.devenv.root}/qmk_userspace";
  };

  # The .uf2 lands in qmk_userspace/.
  scripts.charybdis.exec = ''
    qmk compile -c -kb bastardkb/charybdis/4x6/splinktegrated_rev1 -km slavoutich
  '';
}
