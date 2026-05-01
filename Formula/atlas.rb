class Atlas < Formula
  desc "Design recovery and architectural pattern extraction for large codebases"
  homepage "https://github.com/linkuistics/Atlas"
  version "1.3.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.3.0/atlas-v1.3.0-aarch64-apple-darwin.tar.xz"
      sha256 "4600bf7b0432507faf966f5c0471c687441bab6634d5c7e50ba4706b276f4215"
    end
    on_intel do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.3.0/atlas-v1.3.0-x86_64-apple-darwin.tar.xz"
      sha256 "e013bf6656fc191f72e54d1f0b98ea7bca662a5e9ae32132f6d07c9df000da0e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.3.0/atlas-v1.3.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "80be5e9d0b82d593d226d1513350520de5ab4780692715e01c757fb27d88cc85"
    end
    on_intel do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.3.0/atlas-v1.3.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "63510350374496f33617bf9d597c3d5a82b4761596c4b7fe46e6f3ff4f246bb7"
    end
  end

  def install
    bin.install "atlas"
  end

  test do
    assert_match "atlas", shell_output("#{bin}/atlas --version")
  end
end
