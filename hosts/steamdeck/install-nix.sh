#!/usr/bin/env bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
# Home Manager
nix --extra-experimental-features "nix-command flakes" run home-manager/master -- init