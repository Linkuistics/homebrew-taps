class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "2.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v2.0.0/grove-v2.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "c44e3e33d81413ea5e14267b84da214560ff5d5bdc90254aa6b25629c206a444"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v2.0.0/grove-v2.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a15b6bea99cfc0cf068456cc21be76ead1e55908c1efdaa04b9008a871591fc4"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v2.0.0/grove-v2.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "be988c35ba2e54b1003fdb7bb0a3dae7a8fd780d932e22538f438a6983cb3f4a"
    end
  end

  def install
    bin.install "grove"
  end

  test do
    assert_match "grove cli 2.0.0", shell_output("#{bin}/grove version")
  end
end
