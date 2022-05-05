{ mkDerivation, base, containers, dbus, directory, lib }:
mkDerivation {
  pname = "dbus-example";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base containers dbus directory ];
  license = "unknown";
  hydraPlatforms = lib.platforms.none;
}
