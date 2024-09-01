with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "0.0.12";
  vendorHash = "sha256-kcKwpYBQwv3GmR/1oDMDu/K3M9UbR/f2O3sQJgHHE2w=";

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
    rev = "services/platform/daemon/v${version}";
    hash = "sha256-9IXzZevT8QaA5DeKvpk3hD1I2zScamVezso2ZHyeh+M=";
  } + "/services/platform/daemon";
}
