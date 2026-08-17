class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "18.4.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v18.4.0/grove-v18.4.0-aarch64-apple-darwin.tar.xz"
      sha256 "5476e0d69c64d4572c80f2e65cc11b2687d6f6915fa4f560b803a76466b46421"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v18.4.0/grove-v18.4.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "522d908e9ec5346c751cd8c18ac594a8ba1f056e45a348396d71c89a50a0ab88"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v18.4.0/grove-v18.4.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a3a13e930e87ba17cc560c2fd5ebbbf30af9211d76aecc2f4d0e08dfb330cc3f"
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
    assert_match "grove 18.4.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 18.4.0", shell_output("#{bin}/grove-llm --version")
  end
end
