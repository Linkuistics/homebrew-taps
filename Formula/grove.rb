class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "3.0.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v3.0.1/grove-v3.0.1-aarch64-apple-darwin.tar.xz"
      sha256 "1f58b8ae131706240514213eabde45b6afc96b13c5b26babe9ed3701de957a28"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v3.0.1/grove-v3.0.1-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c7bb33834e0630f1fb3e2fbd4435d9e6c47a95fe836e87848d1e46b95f4db3f5"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v3.0.1/grove-v3.0.1-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "939d49e9c15a5d4f3979697c7357a3fc42b85cdec6c2ce767e43282adea7a26c"
    end
  end

  def install
    bin.install "grove", "grove-llm"
  end

  test do
    assert_match "grove cli 3.0.1", shell_output("#{bin}/grove version")
    assert_match "grove-llm 3.0.1", shell_output("#{bin}/grove-llm --version")
  end
end
