class Atlas < Formula
  desc "Design recovery and architectural pattern extraction for large codebases"
  homepage "https://github.com/linkuistics/Atlas"
  version "1.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.1.0/atlas-v1.1.0-aarch64-apple-darwin.tar.xz"
      sha256 "c3d607e684a8111e1b1f41393ced3b4fadc016766e088e8ad70fc68fff6118b2"
    end
    on_intel do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.1.0/atlas-v1.1.0-x86_64-apple-darwin.tar.xz"
      sha256 "44a3ef987e8f6665bbf3371b83b15ca7d8b3e13b0021a0594edcc96bc9da3e5c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.1.0/atlas-v1.1.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1b60dace436b3a58f2d2dde363f3374616d62dda5a526952e5796dacc73c0f5b"
    end
    on_intel do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.1.0/atlas-v1.1.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0dfb61efba07ff06a4de4d52eb9662f27203ec8a4da3917fa5b39e3a3b893bc3"
    end
  end

  def install
    bin.install "atlas"
  end

  test do
    assert_match "atlas", shell_output("#{bin}/atlas --version")
  end
end
