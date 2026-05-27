class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "2.2.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v2.2.0/grove-v2.2.0-aarch64-apple-darwin.tar.xz"
      sha256 "a95343f17c6243e47be769bb6238d8946e3ea80d2480612a7268cfa8a5d7a465"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v2.2.0/grove-v2.2.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "72411c283e62cd5c66bc4a5b4d11038bb676897a1f5c4d6ee17c9ddd0bb3c96d"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v2.2.0/grove-v2.2.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "891110055c7c7e5634e432d99782197a6829bc3396c82ce32cf321fc4b40cd20"
    end
  end

  def install
    bin.install "grove"
  end

  test do
    assert_match "grove cli 2.2.0", shell_output("#{bin}/grove version")
  end
end
