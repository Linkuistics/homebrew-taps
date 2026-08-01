class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "16.4.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v16.4.0/grove-v16.4.0-aarch64-apple-darwin.tar.xz"
      sha256 "bb5d9734f87a80258913c91d5342487ad620184e11e520dd6c1e935c40e981f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v16.4.0/grove-v16.4.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "108452eaeba1e61b8b7abadac8348cb5391b49cb2bf64fc259552e610c90dfa6"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v16.4.0/grove-v16.4.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "80d9c218938e0f37332ca9acf1aa004edd76968a026664020b2e624f2d878c65"
    end
  end

  def install
    # The methodology skill is NOT fetched or installed here. The `grove` binary
    # embeds the full `content/` tree (self-extension-core-and-methodology / task-tree-scheme) and provisions it to
    # ~/.claude/skills/grove/ on the first `grove do`, so the skill can never
    # drift from the binary. Do NOT reintroduce a content/ download into this
    # formula or the release tarball — `brew install grove` is the sole gesture.
    bin.install "grove", "grove-llm"
  end

  def caveats
    <<~EOS
      grove ships its methodology inside the binary. The first
        grove do
      run from inside your working tree provisions the global skill at
      ~/.claude/skills/grove/ — there is no separate install step. The skill
      re-provisions automatically the next time you run `grove do` after
      upgrading the formula.
    EOS
  end

  test do
    assert_match "grove 16.4.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 16.4.0", shell_output("#{bin}/grove-llm --version")
  end
end
