class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "16.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v16.1.0/grove-v16.1.0-aarch64-apple-darwin.tar.xz"
      sha256 "562f0a331e9960c36617952ec61ad450d745e18abdb9ad4160681e74a2d6743a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v16.1.0/grove-v16.1.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "19947ce8d484e52e0d498913d6dc68e6a52177248c517be6db4c75166da3758d"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v16.1.0/grove-v16.1.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e43c2a516348cb445420a213d65e7a7afe8e23c73e14d068d5ad527e4887be60"
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
    assert_match "grove 16.1.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 16.1.0", shell_output("#{bin}/grove-llm --version")
  end
end
