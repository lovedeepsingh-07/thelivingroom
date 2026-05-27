{
  stdenv,
  src,
  gitignore,
  yarn_berry,
  zip,
  nodejs,
}: let
  filtered_src = gitignore.lib.gitignoreSource src;
  package_json = builtins.fromJSON (builtins.readFile "${src}/package.json");
  missing_hashes = "${src}/missing-hashes.json";
in
  stdenv.mkDerivation rec {
    pname = package_json.name;
    version = package_json.version;
    src = filtered_src;
    nativeBuildInputs = [
      yarn_berry.yarnBerryConfigHook
      yarn_berry
	  nodejs
      zip
    ];
    missingHashes = missing_hashes;
    offlineCache = yarn_berry.fetchYarnBerryDeps {
      src = filtered_src;
      missingHashes = missing_hashes;
      hash = "sha256-3kW99dZb34Qrjtyj+/HX5Rr91eFho9IJshLkRJ3MpZM=";
    };
	# environment variable to let the build tools know the build is happening inside nix
	NIX_BUILD = true;
    buildPhase = ''
      yarn run build
    '';
    installPhase = ''
         mkdir -p $out/dist $out/zip
         cp -r .svelte-kit node_modules .yarn $out/dist/
         cd $out/dist/
      zip -r $out/zip/${pname}-${version}.zip .
    '';
  }
