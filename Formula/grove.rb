class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "21.2.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v21.2.0/grove-v21.2.0-aarch64-apple-darwin.tar.xz"
      sha256 "6614f5347144cb0016442c282b1741499e1bbfa49ab8f3805013630e753bb2fd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v21.2.0/grove-v21.2.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dad67c0dbe4a95216b52f605db330d6c97e25320d8ad8c58709dc5beb52766e5"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v21.2.0/grove-v21.2.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "db890df918a5d4bc74d2184d2c02ca5a6f777ac07355be7edfebedbc30810a72"
    end
  end

  def install
    # Two binaries and nothing else. The methodology is NOT fetched or installed
    # here, and is no longer carried inside the binary either: it ships as the
    # `grove` agent-skill plugin with its own install route (see the caveats).
    # Do NOT reintroduce a content/ download into this formula or the release
    # tarball — that was the pre-v19.5.0 shape, and its replacement is a plugin
    # rather than a second thing brew installs.
    bin.install "grove", "grove-llm"
  end

  def caveats
    <<~EOS
      grove needs two things this formula does not install.

      1. Its methodology, as an agent-skill plugin. Grove names the skill a
         session must load and does not deliver it — a session whose harness
         cannot load that skill has nothing to read.

           Claude Code:  /plugin marketplace add Linkuistics/grove
                         /plugin install grove@linkuistics
           Codex, Gemini CLI, Pi:
                         git clone https://github.com/Linkuistics/grove
                         ./grove/plugins/install.sh

         Before v19.5.0 grove embedded the methodology and swept it into
         ~/.claude/skills/grove/ and two siblings on every run. It no longer
         writes those directories; if an older grove left one behind, remove it
         before running plugins/install.sh, which refuses to clobber it.

      2. Its launch policy, ~/.config/grove/config.kdl, which grove never
         creates: give every session kind one command template before the first
         run.
    EOS
  end

  test do
    assert_match "grove 21.2.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 21.2.0", shell_output("#{bin}/grove-llm --version")
  end
end
