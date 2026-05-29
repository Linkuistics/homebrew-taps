class Testanyware < Formula
  desc "GUI testing tool for VMs, using tart, designed for LLM-driven testing"
  homepage "https://github.com/Linkuistics/TestAnyware"
  version "1.2.0"
  license "MIT"

  depends_on :macos
  depends_on arch: :arm64

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/TestAnyware/releases/download/v1.2.0/testanyware-v1.2.0-aarch64-apple-darwin.tar.xz"
      sha256 "40293be65e5ee972f98ae697f64822d1b3ed27b3c7c4ee292c797bec2420d729"
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
