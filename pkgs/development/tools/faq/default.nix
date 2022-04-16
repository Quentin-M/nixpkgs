#with import <nixpkgs> {};
{ buildGoModule, pkgs, lib, fetchFromGitHub }:

# Get sha256: nix-prefetch-url --unpack https://github.com/jzelinskie/faq/archive/594bb8e15dc4070300f39c168354784988646231.tar.gz
# Build with: nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'
# Build env with: nix-shell --pure -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'
# Get vendorSha256: build, get it from error

buildGoModule rec 
{
  pname = "faq";
  version = "0.0.8-rc";

  nativeBuildInputs = with pkgs; [
    git
    jq
    oniguruma
  ];

  src = fetchFromGitHub {
    owner = "jzelinskie";
    repo = "faq";
    rev = "594bb8e15dc4070300f39c168354784988646231";
    sha256 = "1lqrchj4sj16n6y5ljsp8v4xmm57gzkavbddq23dhlgkg2lfyn91";
  };
  vendorSha256 = "sha256-731eINkboZiuPXX/HQ4r/8ogLedKBWx1IV7BZRKwU3A";

  buildPhase = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -L${pkgs.jq.lib}/lib -L${pkgs.oniguruma}/lib"
    cp ${pkgs.jq.dev}/include/*.h ./internal/jq
    make build
  '';

  # Otherwise it depends on 'getGoDirs', which is normally set in buildPhase
  doCheck = false;

  postInstall = ''
    mkdir -p $out/bin/
    cp ./faq-* $out/bin/faq
  '';

  meta = with lib; {
    description = "faq is a tool intended to be a more flexible jq, supporting additional formats.";
    homepage = "https://github.com/jzelinskie/faq";
    license = licenses.asl20;
    maintainers = with maintainers; [ quentin-m ];
  };
}
