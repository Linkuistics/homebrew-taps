class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "19.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v19.1.0/grove-v19.1.0-aarch64-apple-darwin.tar.xz"
      sha256 "e4bd01282f251084cf1d86defe27ba9410ce8f059b9ec21278baedbbf0ab0710"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v19.1.0/grove-v19.1.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "98f172f87887eb4674f1ac634a307778a2d264d44229bcc85496025da5776442"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v19.1.0/grove-v19.1.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "82f708001d90002976b261d1f8157d8df8494a3f44b792dcf0a2baf8074e14d9"
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
    assert_match "grove 19.1.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 19.1.0", shell_output("#{bin}/grove-llm --version")
  end
end
