with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "0.0.8";
  vendorHash = "sha256-lSe0P/nqCnRvP6nUZG5d9oXQ0Q+hKet1v0rhTrtapx4=";

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
    hash = "sha256-HywVvXdpMhEvGP7zTen3WRzbW8iZhutlg+YY7owPNWQ=";
  } + "/services/platform/daemon";
}
