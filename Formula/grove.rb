class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "15.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v15.0.0/grove-v15.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "b186a666fb35e6670c3cee218506b455b94210d8169e4601d07b35be401bdd64"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v15.0.0/grove-v15.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c0ad0237f29cb92e45db5f39c571de608038c41866d2e35bfeeb1dcc3bbe00f8"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v15.0.0/grove-v15.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1166cf2b7c38bea541c7c15fdf0151001807e0800f46f435b2262fb195b58bd0"
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
    assert_match "grove 15.0.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 15.0.0", shell_output("#{bin}/grove-llm --version")
  end
end
