class Testanyware < Formula
  desc "GUI testing tool for VMs, using tart, designed for LLM-driven testing"
  homepage "https://github.com/Linkuistics/TestAnyware"
  version "1.1.0"
  license "MIT"

  depends_on :macos
  depends_on arch: :arm64

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/TestAnyware/releases/download/v1.1.0/testanyware-v1.1.0-aarch64-apple-darwin.tar.xz"
      sha256 "078f1db0a3b3d03d8269278e565e26391a152e33086fe283f9ac16d552635438"
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
