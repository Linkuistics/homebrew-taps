class Testanyware < Formula
  desc "GUI testing tool for VMs, using tart, designed for LLM-driven testing"
  homepage "https://github.com/Linkuistics/TestAnyware"
  version "1.0.0"
  license "MIT"

  depends_on :macos
  depends_on arch: :arm64

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/TestAnyware/releases/download/v1.0.0/testanyware-v1.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "c69e5904dba4b6942584f7c7cf41498b4a57b3bb9b9533daebd52560152c4ffc"
    end
  end

  def install
    bin.install Dir["bin/*"]
    pkgshare.install Dir["share/testanyware/*"]
  end

  test do
    assert_match "testanyware", shell_output("#{bin}/testanyware --help")
  end
end
