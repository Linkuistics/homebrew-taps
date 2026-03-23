class Lgt < Formula
  desc "GUI testing tool for macOS VMs, designed for LLM-driven testing"
  homepage "https://github.com/linkuistics/lgt"
  url "https://github.com/linkuistics/lgt.git", tag: "v0.5.0"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on "jq"
  depends_on :macos

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    bin.install ".build/release/lgt"
    bin.install ".build/release/lgt-query"

    # Install VM management scripts
    (libexec/"lgt"/"vm").install Dir["vm/*.sh"]
  end

  test do
    assert_match "LGT", shell_output("#{bin}/lgt instructions")
    assert_match version.to_s, shell_output("#{bin}/lgt-query --version").strip
  end
end
