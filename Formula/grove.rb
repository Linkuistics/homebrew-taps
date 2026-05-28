class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "3.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v3.0.0/grove-v3.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "57aa28893010caf9965d452769f3ac129765d540c490968218eaac968e8cbe89"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v3.0.0/grove-v3.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c729d0da2d8aa2680fed6d07788fb2f236ee9c52f0537b0fe225aad42cbd2d2f"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v3.0.0/grove-v3.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "81729c1576efddb6e2a675a83ebff80384b9df77916f9a4382416b115e7711ed"
    end
  end

  def install
    bin.install "grove", "grove-llm"
  end

  test do
    assert_match "grove cli 3.0.0", shell_output("#{bin}/grove version")
    assert_match "grove-llm 3.0.0", shell_output("#{bin}/grove-llm --version")
  end
end
