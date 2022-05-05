{ pkgs ? import <nixpkgs> {} }:
pkgs.haskellPackages.callPackage ./dbus-example.nix { }
