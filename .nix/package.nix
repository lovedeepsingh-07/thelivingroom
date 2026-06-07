{
  stdenv,
  src,
  gitignore,
  yarn_berry,
  nodejs,
}: let
  filtered_src = gitignore.lib.gitignoreSource src;
  package_json = builtins.fromJSON (builtins.readFile "${src}/package.json");
  missing_hashes = "${src}/missing-hashes.json";
in
  stdenv.mkDerivation {
    pname = package_json.name;
    version = package_json.version;
    src = filtered_src;
    nativeBuildInputs = [
      yarn_berry.yarnBerryConfigHook
      yarn_berry
	  nodejs
    ];
    missingHashes = missing_hashes;
    offlineCache = yarn_berry.fetchYarnBerryDeps {
      src = filtered_src;
      missingHashes = missing_hashes;
      hash = "sha256-ntJVWTuXMWZiT/Hna7kq2MW+jWMa7lnzYhWwf2vR8oM=";
    };
	# environment variable to let the build tools know the build is happening inside nix
	NIX_BUILD = true;
    buildPhase = ''
      yarn run build
    '';
    installPhase = ''
         mkdir -p $out/dist
         cp -r .svelte-kit node_modules .yarn $out/dist/
         cd $out/dist/
    '';
  }
