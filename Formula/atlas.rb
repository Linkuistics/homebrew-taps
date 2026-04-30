class Atlas < Formula
  desc "Design recovery and architectural pattern extraction for large codebases"
  homepage "https://github.com/linkuistics/Atlas"
  version "1.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.0.0/atlas-v1.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "33bce87c204cd9779b860ad46260bc86897b8d281b0f6205bfb258bccb3e11a5"
    end
    on_intel do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.0.0/atlas-v1.0.0-x86_64-apple-darwin.tar.xz"
      sha256 "e9357cf60d6f5aaed01e3c8bacee33b56185106ff5cb336a1045ae2fa04cf6df"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.0.0/atlas-v1.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6257b5faa47304ce7b080d8b59992df90d5c7a05cd51a4ac855763b7209204f4"
    end
    on_intel do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.0.0/atlas-v1.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "733d61bf1058b1a3979039e1934b1114914ea95669fb1a8002ca33b9320810d9"
    end
  end

  def install
    bin.install "atlas"
  end

  test do
    assert_match "atlas", shell_output("#{bin}/atlas --version")
  end
end
