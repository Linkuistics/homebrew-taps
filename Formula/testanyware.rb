class Testanyware < Formula
  desc "GUI testing tool for VMs, using tart, designed for LLM-driven testing"
  homepage "https://github.com/linkuistics/testanyware"
  url "https://github.com/linkuistics/testanyware.git", tag: "v0.10.0"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on "jq"
  depends_on :macos

  def install
    # RoyalVNCKit declares type: .dynamic, which produces a dylib that won't
    # be present at runtime after Homebrew installs just the binary.
    # Resolve deps first, then patch to use static linking.
    system "swift", "package", "resolve", "--disable-sandbox"
    inreplace ".build/checkouts/royalvnc/Package.swift", "type: .dynamic,\n", ""

    system "swift", "build", "-c", "release", "--disable-sandbox"

    bin.install ".build/release/testanyware"
    bin.install ".build/release/testanyware-query"

    # Install VM management scripts
    (libexec/"testanyware"/"vm").install Dir["vm/*.sh"]
  end

  test do
    assert_match "TestAnyware", shell_output("#{bin}/testanyware instructions")
    assert_match version.to_s, shell_output("#{bin}/testanyware-query --version").strip
  end
end
