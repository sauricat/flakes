#!/usr/bin/env -S nix repl
{ flake = builtins.getFlake (toString ./.); } // (import <nixpkgs> {})
