with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "v0.0.34";
  vendorHash = "sha256-FqzosyTCmAdKedbRn4yISu1Z7B595f6L+E3qRJit5UA=";

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
    hash = "sha256-SjVaMsNQEG7Ds0X+B/1eMVRsOw6Q8WeP9mNWUXwGuuo=";
  } + "/services/platform/daemon";
}