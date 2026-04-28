class Testanyware < Formula
  desc "GUI testing tool for VMs, using tart, designed for LLM-driven testing"
  homepage "https://github.com/Linkuistics/TestAnyware"
  version "1.0.1"
  license "MIT"

  depends_on :macos
  depends_on arch: :arm64

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/TestAnyware/releases/download/v1.0.1/testanyware-v1.0.1-aarch64-apple-darwin.tar.xz"
      sha256 "eea2d1b8714b930be5042156864b976caa47fcd63de31e24c63a47e9fb65bd43"
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
