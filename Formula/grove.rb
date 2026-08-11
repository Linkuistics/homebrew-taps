class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "17.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v17.0.0/grove-v17.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "6bf3771b39f1b91a45d8e96a3904efac6b360308e478671c58567d592df7bb88"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v17.0.0/grove-v17.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "31e2229e7ade9ba329f1c4ac4fd697c65797bbbf377afe7946f39db306e33891"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v17.0.0/grove-v17.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9666d78f7c5c982d3b11c76fb271b05e85527ec3a18d6937b2f68f84f9694672"
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
    assert_match "grove 17.0.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 17.0.0", shell_output("#{bin}/grove-llm --version")
  end
end
