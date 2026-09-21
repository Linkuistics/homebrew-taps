class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "21.11.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v21.11.0/grove-v21.11.0-aarch64-apple-darwin.tar.xz"
      sha256 "68372b266bfb67ac15c223459b3229cbd8db52571e6800aa99d747345b1c01d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v21.11.0/grove-v21.11.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "05f1964234e47642d41586e64a7a12c9803964e050d050811e95ecf407f0ca1a"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v21.11.0/grove-v21.11.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "22ef9d6ee5de71ae4fb76f0786882810f3462efe3adc07d90a3b8a4e1c02071c"
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
    assert_match "grove 21.11.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 21.11.0", shell_output("#{bin}/grove-llm --version")
  end
end
