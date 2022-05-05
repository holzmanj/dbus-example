{ mkDerivation, base, dbus, lib }:
mkDerivation {
  pname = "dbus-example";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base dbus ];
  license = "unknown";
  hydraPlatforms = lib.platforms.none;
}
