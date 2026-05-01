class Atlas < Formula
  desc "Design recovery and architectural pattern extraction for large codebases"
  homepage "https://github.com/linkuistics/Atlas"
  version "1.2.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.2.0/atlas-v1.2.0-aarch64-apple-darwin.tar.xz"
      sha256 "ff0b13061a2131000560e88081c5a72a1bbef1013ab16bddfaf64ff5861e1ab7"
    end
    on_intel do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.2.0/atlas-v1.2.0-x86_64-apple-darwin.tar.xz"
      sha256 "2d895df40507a756657a15454167593d78c082f0e520b75805e055184d85bfb0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.2.0/atlas-v1.2.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2d638e01e81d7198e6fb5b74ba18bdc164bfb16bd008ca49981c341a5c0a30fa"
    end
    on_intel do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.2.0/atlas-v1.2.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "42e26eddef42e0fb8c0fe72d512aa1528aa10adc89d597d3da05fea55e544fe9"
    end
  end

  def install
    bin.install "atlas"
  end

  test do
    assert_match "atlas", shell_output("#{bin}/atlas --version")
  end
end
