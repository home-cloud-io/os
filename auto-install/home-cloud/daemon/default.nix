with import <nixpkgs> {};

buildGoModule rec {
  pname = "home-cloud-daemon";
  version = "v0.0.38";
  vendorHash = "sha256-/oS6TkTUP9V3fEy0YqLErzxOa+mXVZcXVhYSUTYr8IE=";

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
    hash = "sha256-rtMYj19DfdSuSW7K1qqgpfl+sa7QRXlKwguVEYO1rUg=";
  } + "/services/platform/daemon";
}