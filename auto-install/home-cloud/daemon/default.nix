with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "v0.0.29";
  vendorHash = "sha256-krte40y6rGq95UUg8WfVubDOnZUK6f9XsZ5uJA9j/h4=";

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
    hash = "sha256-nnOSH+qEpO9EYWDqjNfFoAw/sqSlRI3ku6wiNTdLF5A=";
  } + "/services/platform/daemon";
}
