require 'formula'
 
class Oclint < Formula
homepage 'http://oclint.org'
url 'http://archives.oclint.org/releases/0.7/oclint-0.7-x86_64-apple-darwin-10.tar.gz'
version '0.7'
sha1 '867751f9e1b73515c22a014b22592b31c92f81bb'
 
depends_on 'llvm'
 
def install
lib.install Dir['lib/oclint']
bin.install Dir['bin/*']
end
 
def test
system "oclint -h"
end
end