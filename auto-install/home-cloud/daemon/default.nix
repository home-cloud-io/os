with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "v0.0.23";
  vendorHash = "sha256-+TZk610sj+X1zpkflznPO/7VuGwQeDbqL1zpIGTXl+c=";

  meta = with lib; {
    description = "Home Cloud Host Daemon";
    homepage = "https://github.com/home-cloud-io/core";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.jgkawell ];
  };

  src = fetchFromGitHub {
    owner = "home-cloud-io";
    repo = "core";
    rev = "services/platform/daemon/${version}";
    hash = "sha256-BbDEHZUP/WZW0KtaTXau2erAqOU/Zrvy49q36w+Y4K8=";
  } + "/services/platform/daemon";
}
