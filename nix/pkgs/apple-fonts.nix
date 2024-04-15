{ lib, stdenv, fetchurl, unzip, p7zip }:

stdenv.mkDerivation rec {
  pname = "apple-fonts";
  version = "1";

  pro = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
    sha256 = "sha256-Mu0pmx3OWiKBmMEYLNg+u2MxFERK07BQGe3WAhEec5Q=";
  };

  compact = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg";
    sha256 = "sha256-Mkf+GK4iuUhZdUdzMW0VUOmXcXcISejhMeZVm0uaRwY=";
  };

  mono = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
    sha256 = "sha256-tZHV6g427zqYzrNf3wCwiCh5Vjo8PAai9uEvayYPsjM=";
  };

  ny = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg";
    sha256 = "sha256-tn1QLCSjgo5q4PwE/we80pJavr3nHVgFWrZ8cp29qBk=";
  };

  nativeBuildInputs = [ p7zip ];

  sourceRoot = ".";

  dontUnpack = true;

  installPhase = ''
    7z x ${pro}
    cd SFProFonts 
    7z x 'SF Pro Fonts.pkg'
    7z x 'Payload~'
    mkdir -p $out/fontfiles
    mv Library/Fonts/* $out/fontfiles
    cd ..

    7z x ${mono}
    cd SFMonoFonts
    7z x 'SF Mono Fonts.pkg'
    7z x 'Payload~'
    mv Library/Fonts/* $out/fontfiles
    cd ..

    7z x ${compact}
    cd SFCompactFonts
    7z x 'SF Compact Fonts.pkg'
    7z x 'Payload~'
    mv Library/Fonts/* $out/fontfiles
    cd ..

    7z x ${ny}
    cd NYFonts
    7z x 'NY Fonts.pkg'
    7z x 'Payload~'
    mv Library/Fonts/* $out/fontfiles

    mkdir -p $out/usr/share/fonts/OTF $out/usr/share/fonts/TTF
    mv $out/fontfiles/*.otf $out/usr/share/fonts/OTF
    mv $out/fontfiles/*.ttf $out/usr/share/fonts/TTF
    rm -rf $out/fontfiles
  '';

  meta = {
    description = "Apple San Francisco, New York fonts";
    homepage = "https://developer.apple.com/fonts/";
    license = lib.licenses.unfree;
  };
}