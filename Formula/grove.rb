class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "5.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v5.0.0/grove-v5.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "c1a3321a386cca5d04668ad1e3a2aaf1b4c667e3b2fce6a19b75084e57c494ce"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v5.0.0/grove-v5.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cef9cf2bf80ee3b1631ca7db4aa6f01b874584345a141f0922f34eaa56b8e8c1"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v5.0.0/grove-v5.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "01af0f344120c2a27f9493488c27867b73f241c1875e9f1e47a5416481a9bdbd"
    end
  end

  def install
    bin.install "grove", "grove-llm"
  end

  test do
    assert_match "grove 5.0.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 5.0.0", shell_output("#{bin}/grove-llm --version")
  end
end
