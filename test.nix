#!/usr/bin/env -S nix repl --file
{ flake = builtins.getFlake (toString ./.); } // (import <nixpkgs> { })
