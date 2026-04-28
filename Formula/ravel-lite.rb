class RavelLite < Formula
  desc "An orchestration loop for LLM development cycles"
  homepage "https://github.com/Linkuistics/Ravel-Lite"
  version "1.0.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/Ravel-Lite/releases/download/v1.0.4/ravel-lite-v1.0.4-aarch64-apple-darwin.tar.xz"
      sha256 "a0d443c364875a21591b323732d7a057141e7ce19a9559863e0e675edc2125e9"
    end
    on_intel do
      url "https://github.com/Linkuistics/Ravel-Lite/releases/download/v1.0.4/ravel-lite-v1.0.4-x86_64-apple-darwin.tar.xz"
      sha256 "b47ea768329eb5a1d1c4d9efc9a1cd16645e0cf0fb5d733de5a5edd4708feee7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/Ravel-Lite/releases/download/v1.0.4/ravel-lite-v1.0.4-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2d5cf3753781d01d1585c018ac3f164475f4612e6488989339c5961183703d44"
    end
    on_intel do
      url "https://github.com/Linkuistics/Ravel-Lite/releases/download/v1.0.4/ravel-lite-v1.0.4-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa9936de4b033315a6c943ab37696e61a3c2fd8ace8aa6dbcb3733e6882ea496"
    end
  end

  def install
    bin.install "ravel-lite"
  end

  test do
    assert_match "ravel-lite", shell_output("#{bin}/ravel-lite --version")
  end
end
