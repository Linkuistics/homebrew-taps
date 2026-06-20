class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "6.3.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v6.3.0/grove-v6.3.0-aarch64-apple-darwin.tar.xz"
      sha256 "12036988615fe951e88513e0d644d2822c53e4c896d080fd66cc2f2226fed8d6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v6.3.0/grove-v6.3.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "15791847c764a566ce40a34c950caa9cde47deed1fc959f6082bd47871b81e64"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v6.3.0/grove-v6.3.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "24b31ffa3e3aef189d928105e710886ed399edd04317b7e6a0c4ae825646d870"
    end
  end

  def install
    # rmux is the bundled stock daemon/CLI (ADR-0030); grove tui resolves it as
    # a sibling of its own executable, so all three must land in the same bin/.
    bin.install "grove", "grove-llm", "rmux"
  end

  test do
    assert_match "grove 6.3.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 6.3.0", shell_output("#{bin}/grove-llm --version")
    # rmux mirrors tmux's terse CLI: version is `-V`, not GNU `--version`.
    assert_match "rmux", shell_output("#{bin}/rmux -V")
  end
end
