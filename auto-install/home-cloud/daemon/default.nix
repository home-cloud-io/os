with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "v0.0.21";
  vendorHash = "sha256-+BtJWngqcrC1ouFEw/Sn3RY8tgIBzgUq1rpWUFSZIoM=";

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
    hash = "sha256-JusNCwxu5jUmRScMJv97TUQaaGZfKTRwIm+1cFuSaa0=";
  } + "/services/platform/daemon";
}
