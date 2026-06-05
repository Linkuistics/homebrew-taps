class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "6.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v6.1.0/grove-v6.1.0-aarch64-apple-darwin.tar.xz"
      sha256 "9da36ed310a0915793b20c26e4c11bea5c1f86f7818d9696a7c84d821958067f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v6.1.0/grove-v6.1.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dc526e1d6981da72035adc6ab877f87c96b7dfb073c001228ab3da14c0157d0b"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v6.1.0/grove-v6.1.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d681cc401c9fbeb2ac9bf3dd0d76669f9e8c34ab3524292811e9f2d18a362bac"
    end
  end

  def install
    bin.install "grove", "grove-llm"
  end

  test do
    assert_match "grove 6.1.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 6.1.0", shell_output("#{bin}/grove-llm --version")
  end
end
