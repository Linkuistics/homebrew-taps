class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "6.2.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v6.2.1/grove-v6.2.1-aarch64-apple-darwin.tar.xz"
      sha256 "ceb399b260dbbc56adc841253af37c4d1d23be0734e10f7bfee0ab69f1a707c1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v6.2.1/grove-v6.2.1-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b7cd92b38bff78e3833e03291ebb2566bcffe3923d2cf251816f97e9cd55646e"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v6.2.1/grove-v6.2.1-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7b336135311f9fce347d0ef1dac86d3898f7d546a5816c6c2afeadaacfa4455f"
    end
  end

  def install
    bin.install "grove", "grove-llm"
  end

  test do
    assert_match "grove 6.2.1", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 6.2.1", shell_output("#{bin}/grove-llm --version")
  end
end
