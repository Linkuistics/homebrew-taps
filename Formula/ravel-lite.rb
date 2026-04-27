class RavelLite < Formula
  desc "An orchestration loop for LLM development cycles"
  homepage "https://github.com/Linkuistics/Ravel-Lite"
  version "1.0.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/Ravel-Lite/releases/download/v1.0.3/ravel-lite-v1.0.3-aarch64-apple-darwin.tar.xz"
      sha256 "faf5fc723fc0b84bde4f372591b6409f8d1336595a13ea219ec82b1250257717"
    end
    on_intel do
      url "https://github.com/Linkuistics/Ravel-Lite/releases/download/v1.0.3/ravel-lite-v1.0.3-x86_64-apple-darwin.tar.xz"
      sha256 "1f7d0e6c3fffe44b813d6ae4e23647b9c94f13a90365d1b503b47e3768d0fba7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/Ravel-Lite/releases/download/v1.0.3/ravel-lite-v1.0.3-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "704a4c8bf57fb0e2bb9162bae71f7c8f074ed83d8e26bb9b01de47c11e5cbe35"
    end
    on_intel do
      url "https://github.com/Linkuistics/Ravel-Lite/releases/download/v1.0.3/ravel-lite-v1.0.3-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7e699767f695f3bfaac1e15f61a898f38b49679ee3a487a6be90a0f529a66bcc"
    end
  end

  def install
    bin.install "ravel-lite"
  end

  test do
    assert_match "ravel-lite", shell_output("#{bin}/ravel-lite --version")
  end
end
