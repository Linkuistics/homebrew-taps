class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v0.1.0/grove-darwin-arm64.tar.gz"
      sha256 "54584e2e146131820d69973ced2687478e83b20c175443650d19f58b29c84351"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v0.1.0/grove-linux-arm64.tar.gz"
      sha256 "6b31478337ec15a4adbef5634e2676dce9da557ad2105bd78318e8f140459823"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v0.1.0/grove-linux-x86_64.tar.gz"
      sha256 "e7bd6cd359002d417da8e83732cc13d6269afacde5b90272b30c2880a5937534"
    end
  end

  def install
    bin.install "grove"
  end

  test do
    assert_match "grove cli 0.1.0", shell_output("#{bin}/grove version")
  end
end
