{pkgs, ...}: {
  default = pkgs.mkShell {
    packages = [
      pkgs.alejandra
      pkgs.yarn-berry_4
      pkgs.yarn-berry_4.yarn-berry-fetcher
      pkgs.jq
      pkgs.wrangler
      pkgs.pkg-config
    ];
    shellHook = ''
      zsh
    '';
  };
}
