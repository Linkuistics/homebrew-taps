class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "16.3.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v16.3.0/grove-v16.3.0-aarch64-apple-darwin.tar.xz"
      sha256 "2a1c814154532fe53481afcbf7df9ce09e6690e2a845ec76da14a50ee4750aae"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v16.3.0/grove-v16.3.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "483fc498f227a1eae8ca3ba44002e1f4e157413ce1e54ecfeb5447fbb19b98c1"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v16.3.0/grove-v16.3.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b23adb4eda6b7ba66d50e113cc60df399dc63151b13c1815b48de39fd4adfe5c"
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
    assert_match "grove 16.3.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 16.3.0", shell_output("#{bin}/grove-llm --version")
  end
end
