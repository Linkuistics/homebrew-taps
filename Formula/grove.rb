class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "4.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v4.0.0/grove-v4.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "27915caeb55639b029f8638aecb544d0c1a6901a61aaa80e39e15ea30f649298"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v4.0.0/grove-v4.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1c4aa918f69854703e09b234566bf54d5d4534767fd8852ba80a96fc826b0e65"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v4.0.0/grove-v4.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d8d66a21a14273ff9eab2e5c1ffae8092842ac3e30978584a461d46a7968cca6"
    end
  end

  def install
    bin.install "grove", "grove-llm"
  end

  test do
    assert_match "grove 4.0.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 4.0.0", shell_output("#{bin}/grove-llm --version")
  end
end
