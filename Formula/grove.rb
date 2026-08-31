class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "20.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v20.1.0/grove-v20.1.0-aarch64-apple-darwin.tar.xz"
      sha256 "0f1ea2e356e3cf2b86f4394ba8a7ca30da19809bd87b8f877606cac98ef9dcb3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v20.1.0/grove-v20.1.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cebc5bd81081e6c55415bea0b1917dc470572949fd472256ffd231db916694a4"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v20.1.0/grove-v20.1.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "82b3e221ea2d6788a2d57901727ef1ee844d1a52b0b3c09f0b2ddab475315f1b"
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
    assert_match "grove 20.1.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 20.1.0", shell_output("#{bin}/grove-llm --version")
  end
end
