class RavelLite < Formula
  desc "An orchestration loop for LLM development cycles"
  homepage "https://github.com/Linkuistics/Ravel-Lite"
  version "1.0.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/Ravel-Lite/releases/download/v1.0.2/ravel-lite-v1.0.2-aarch64-apple-darwin.tar.xz"
      sha256 "6aeec866f737a62cbe34e4e1db3f69beeaa8f9f04f79fcc50ac434354c4d0876"
    end
    on_intel do
      url "https://github.com/Linkuistics/Ravel-Lite/releases/download/v1.0.2/ravel-lite-v1.0.2-x86_64-apple-darwin.tar.xz"
      sha256 "92f098227b3382944f36a8a357742d980e6bf4848ba49af0644504cf819aa37f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/Ravel-Lite/releases/download/v1.0.2/ravel-lite-v1.0.2-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fad18cf26b766c124d580a7ab6ad5cd7e7dc080ec38029a84591af137e902c0e"
    end
    on_intel do
      url "https://github.com/Linkuistics/Ravel-Lite/releases/download/v1.0.2/ravel-lite-v1.0.2-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fc963337c6bad00a3047c48691bf165b7b5249e35d8d1fb56b06774fbdb5567c"
    end
  end

  def install
    bin.install "ravel-lite"
  end

  test do
    assert_match "ravel-lite", shell_output("#{bin}/ravel-lite --version")
  end
end
