class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "19.4.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v19.4.0/grove-v19.4.0-aarch64-apple-darwin.tar.xz"
      sha256 "8476efd15edab0229e1614fdee7860f4c6924ea6470a3b81e5bd3d3febd1f45f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v19.4.0/grove-v19.4.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc9e6acf4e55c3cd7489c3371c3e4cf107e0bf90103e735d7870f119d731c874"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v19.4.0/grove-v19.4.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "baeefcedcfcce3155493d4fdd01b9cf0f76fe0da162d1d3f3b783b647c24bd1d"
    end
  end

  def install
    # The methodology skill is NOT fetched or installed here. The `grove` binary
    # embeds the full `content/` tree (self-extension-core-and-methodology / task-tree-scheme) and provisions it to
    # ~/.claude/skills/grove/ on the first run, so the skill can never drift
    # from the binary. Do NOT reintroduce a content/ download into this formula
    # or the release tarball — `brew install grove` is the sole gesture.
    bin.install "grove", "grove-llm"
  end

  def caveats
    <<~EOS
      grove ships its methodology inside the binary. The first
        grove
      run from inside your working tree provisions the global skill at
      ~/.claude/skills/grove/ — there is no separate install step. The skill
      re-provisions automatically the next time you run `grove` after upgrading
      the formula.

      grove reads all of its launch policy from ~/.config/grove/config.kdl,
      which it never creates: give every session kind one command template
      before the first run.
    EOS
  end

  test do
    assert_match "grove 19.4.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 19.4.0", shell_output("#{bin}/grove-llm --version")
  end
end
