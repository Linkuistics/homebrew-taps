class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "5.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v5.1.0/grove-v5.1.0-aarch64-apple-darwin.tar.xz"
      sha256 "38d1d898a0b58362ccf7c85d48ad7bb3989d4ff16ee306d25db374a6e6fc4e10"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v5.1.0/grove-v5.1.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0aec54093e7b80bdad574d27dba543bd33e50d04a573e120e865e97e56707222"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v5.1.0/grove-v5.1.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1a7c097c4298776cbcdde534a461cdc18d9762c4077cbe6b5aaafda65f1afef5"
    end
  end

  def install
    bin.install "grove", "grove-llm"
  end

  test do
    assert_match "grove 5.1.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 5.1.0", shell_output("#{bin}/grove-llm --version")
  end
end
