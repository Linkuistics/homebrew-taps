class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "1.0.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v1.0.1/grove-v1.0.1-aarch64-apple-darwin.tar.xz"
      sha256 "8813e70cfb8a379ebe588931739fe1de06de49ab0d35546ca52c324386be9532"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v1.0.1/grove-v1.0.1-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "27cf751ea6c34b94e082d0f25f8f85fdeadd862218ffe1d79ad4e7cfcd24c4de"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v1.0.1/grove-v1.0.1-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "203abb7787c9296a6b5b599cb3fa807a2a133a86d6370d29aaf75f9624b08625"
    end
  end

  def install
    bin.install "grove"
  end

  test do
    assert_match "grove cli 1.0.1", shell_output("#{bin}/grove version")
  end
end
