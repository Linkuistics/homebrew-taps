class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "21.12.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v21.12.0/grove-v21.12.0-aarch64-apple-darwin.tar.xz"
      sha256 "7221513182d2d6e6e46c88356e6f0f273732711632a4e2d2a4176a111b1ec5aa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v21.12.0/grove-v21.12.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "266ef59c3d08961045b4a72ef8cbb0b4b049e8ff01ff90fd3f8e45d5639440a6"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v21.12.0/grove-v21.12.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cfe14129f4ef8c77469a0e32f3b8baaa1a7e2c64b5439b43e91162b73e2c1922"
    end
  end

  def install
    # Codex skill snapshots are embedded in grove and provisioned at startup.
    # Claude Code retains marketplace delivery; no separate payload is fetched.
    bin.install "grove", "grove-llm"
  end

  def caveats
    <<~EOS
      Codex: when ~/.codex is a directory or CODEX_HOME is nonempty, bare grove
      installs and repairs all bundled compatible skills in ~/.agents/skills before
      launching a session. No separate checkout or download is needed;
      the skills update with the installed binary.

      Claude Code: install the plugins and enable marketplace auto-update:

        /plugin marketplace add Linkuistics/grove
        /plugin install grove@linkuistics
        /plugin install linkuistics@linkuistics
        /plugin install testanyware@linkuistics

        /plugin -> Marketplaces -> Enable auto-update

      Gemini CLI and Pi: clone the repository and run its installer:

        git clone https://github.com/Linkuistics/grove
        ./grove/plugins/install.sh

      Grove also needs launch policy in ~/.config/grove/config.kdl. Run
      grove config examples for inactive samples, then give every session
      kind you use a command template before the first run.
    EOS
  end

  test do
    assert_match "grove 21.12.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 21.12.0", shell_output("#{bin}/grove-llm --version")
  end
end
