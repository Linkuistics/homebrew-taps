class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "11.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v11.0.0/grove-v11.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "24cf64c688cb8e08fc8a48019ed6698780044585f438f836ec529fd3a1585377"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v11.0.0/grove-v11.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c6f73df1bca467febcf4f7aec6e02dbd7df8afd7c3978d088c24217544d996cf"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v11.0.0/grove-v11.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2759cf298423fa1b499fe56bd5d4654528cedceeaac1012b9c072165c94b1fb4"
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
    assert_match "grove 11.0.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 11.0.0", shell_output("#{bin}/grove-llm --version")
  end
end
