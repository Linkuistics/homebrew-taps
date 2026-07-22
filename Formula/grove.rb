class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "14.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v14.0.0/grove-v14.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "d0e0c1f395e406dcd66d98a1675643d90f71dbc4cdd83d7fafb9240d90798f3d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v14.0.0/grove-v14.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "74837b143a99ca4bc24108280cfbbe93e563ecbb557a0dcc0fc636ba93ff6414"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v14.0.0/grove-v14.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ccf21c654c26e4939febdeebd43bffd5121caddd3d251b31c568d21bfff4c1ea"
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
    assert_match "grove 14.0.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 14.0.0", shell_output("#{bin}/grove-llm --version")
  end
end
