class Atlas < Formula
  desc "Design recovery and architectural pattern extraction for large codebases"
  homepage "https://github.com/linkuistics/Atlas"
  version "1.0.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.0.1/atlas-v1.0.1-aarch64-apple-darwin.tar.xz"
      sha256 "d4cd26477c36648876314a97807ede013f774d4a8f34f33aba97d28e669e8020"
    end
    on_intel do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.0.1/atlas-v1.0.1-x86_64-apple-darwin.tar.xz"
      sha256 "3b7397657426c33497d50aebf3727913db05855b5efd34889741420545e4f864"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.0.1/atlas-v1.0.1-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "15c32d228e45bc34be00d89fcee207263681616a90f7f880efffacd5410c604a"
    end
    on_intel do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.0.1/atlas-v1.0.1-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "84344430f5542a142cc82a8d967f9923c41d342a41301d6a7cc429d626875dac"
    end
  end

  def install
    bin.install "atlas"
  end

  test do
    assert_match "atlas", shell_output("#{bin}/atlas --version")
  end
end
