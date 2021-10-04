{ pkgs ? import <nixpkgs> {}, packageSrc ? ./. }:

pkgs.stdenvNoCC.mkDerivation {
  name = "minirc";
  src = ./.;
  buildInputs = [pkgs.which];
  propagatedBuildInputs = [
    (pkgs.busybox.override { extraConfig = ''
        CONFIG_INSTALL_APPLET_DONT y
        CONFIG_INSTALL_APPLET_SYMLINKS n
        CONFIG_SH_IS_ASH y
        CONFIG_FEATURE_SH_STANDALONE y
        CONFIG_FEATURE_PREFER_APPLETS y
        CONFIG_FEATURE_SH_NOFORK y
    '';})
  ];
  installFlags = [ "prefix=/" "DESTDIR=$(out)" ];
  postInstall = ''
    mkdir -p "$out/bin"
    echo "#! ${pkgs.stdenv.shell}" >> "$out/bin/init_shell"
    echo "exec $(which busybox) ash" >> "$out/bin/init_shell"
    chmod +x "$out/bin/init_shell"
  '';
}
