class Testanyware < Formula
  desc "GUI testing tool for VMs, using tart, designed for LLM-driven testing"
  homepage "https://github.com/Linkuistics/TestAnyware"
  version "1.0.2"
  license "MIT"

  depends_on :macos
  depends_on arch: :arm64

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/TestAnyware/releases/download/v1.0.2/testanyware-v1.0.2-aarch64-apple-darwin.tar.xz"
      sha256 "193734af601f39d6122d7e316e1977c0b00016b328098c4112f130cb94960a99"
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
