class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "6.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v6.0.0/grove-v6.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "a4bc68396003ad42867360a8fd1d141c10deeb357ad7925e3f7400351c07ec8e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v6.0.0/grove-v6.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6a1ba4cb77ceba309b9d9b752e9272df1144b4e04baa433bd7a621be6b45d5ea"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v6.0.0/grove-v6.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "357762ef31705e5477981ed3883705984bc735483865d6da2587c549986ba95a"
    end
  end

  def install
    bin.install "grove", "grove-llm"
  end

  test do
    assert_match "grove 6.0.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 6.0.0", shell_output("#{bin}/grove-llm --version")
  end
end
