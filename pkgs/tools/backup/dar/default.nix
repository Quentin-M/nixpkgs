{ lib, stdenv, fetchurl
, which
, attr, e2fsprogs
, curl, libargon2, librsync, libthreadar
, gpgme, libgcrypt, openssl
, bzip2, lz4, lzo, xz, zlib
}:

with lib;

stdenv.mkDerivation rec {
  version = "2.7.4";
  pname = "dar";

  src = fetchurl {
    url = "mirror://sourceforge/dar/${pname}-${version}.tar.gz";
    sha256 = "sha256-esti2QXoq+5bic639eG96vZOSJboMVHmD+oRNAI6ic4=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ which ];

  buildInputs = [
    curl librsync libthreadar
    gpgme libargon2 libgcrypt openssl
    bzip2 lz4 lzo xz zlib
  ] ++ optionals stdenv.isLinux [ attr e2fsprogs ];

  configureFlags = [
    "--disable-birthtime"
    "--disable-upx"
    "--disable-dar-static"
    "--disable-build-html"
    "--enable-threadar"
  ];

  postInstall = ''
    # Disable html help
    rm -r "$out"/share/dar
  '';

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "http://dar.linux.free.fr";
    description = "Disk ARchiver, allows backing up files into indexed archives";
    maintainers = with maintainers; [ izorkin ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
