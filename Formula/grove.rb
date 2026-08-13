class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "18.3.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v18.3.0/grove-v18.3.0-aarch64-apple-darwin.tar.xz"
      sha256 "622882155d91652645c2916856f13e58c68ba4bc484c5cc9b896b242bde47d51"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v18.3.0/grove-v18.3.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0052d36324c00c6f2f68a25a9aed45cd42fc4212c8030460db7adf4c1568b111"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v18.3.0/grove-v18.3.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d6144dae78d2ce8fb87f241b7d916a89d3fce1668779249f6836c54da64844c7"
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
    assert_match "grove 18.3.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 18.3.0", shell_output("#{bin}/grove-llm --version")
  end
end
