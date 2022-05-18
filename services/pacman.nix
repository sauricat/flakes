{ config, pkgs, ...}:
{
  # requirement: pkgs.pacman
  environment.etc."pacman.conf".text = ''
    [options]
    RootDir     = /pac
    #DBPath      = /var/lib/pacman/
    #CacheDir    = /var/cache/pacman/pkg/
    #LogFile     = /var/log/pacman.log
    #GPGDir      = /etc/pacman.d/gnupg/
    #HookDir     = /etc/pacman.d/hooks/
    HoldPkg     = pacman #glibc
    #XferCommand = /usr/bin/curl -L -C - -f -o %o %u
    #XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
    #CleanMethod = KeepInstalled
    Architecture = auto

    # Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
    #IgnorePkg   =
    #IgnoreGroup =

    NoUpgrade   = /etc/shadow /etc/fstab /etc/nixos /etc/passwd /etc/group
    #NoExtract   =

    # Misc options
    #UseSyslog
    #Color
    #TotalDownload
    CheckSpace
    #VerbosePkgLists

    # PGP signature checking
    #SigLevel = Optional
    #LocalFileSigLevel = Optional
    #RemoteFileSigLevel = Optional

    [core]
    Include = /etc/pacman.d/mirrorlist
    [extra]
    Include = /etc/pacman.d/mirrorlist
    [community]
    Include = /etc/pacman.d/mirrorlist
    #[multilib]
    #Include = /etc/pacman.d/mirrorlist

    # An example of a custom package repository.  See the pacman manpage for
    # tips on creating your own repositories.
    #[custom]
    #SigLevel = Optional TrustAll
    #Server = file:///home/custompkgs
  '';

  environment.etc."pacman.d/mirrorlist".text = 
    builtins.readFile (builtins.fetchurl {
      url = "https://archlinux.org/mirrorlist/all/https/";
      sha256 = "0jrncbm207rxnp8iyf51f8v76vb8vkj4fwj9qw4pdjrg57pnvh88"; 
    });
}