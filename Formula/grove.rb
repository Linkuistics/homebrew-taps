class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "16.2.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v16.2.0/grove-v16.2.0-aarch64-apple-darwin.tar.xz"
      sha256 "db7b68f5b2872418c76e2863f67f6a2aed63ecae89893477ebf220f2362b3600"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v16.2.0/grove-v16.2.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d85e75d8c33a085a97190c8a69d8177137cb3a073a0e88ba4278e92ce7970d5b"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v16.2.0/grove-v16.2.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5f00a8e1a74080ecfc5f2527cb2bdac6cebc41f614c274d3a09530d9f82c5583"
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
    assert_match "grove 16.2.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 16.2.0", shell_output("#{bin}/grove-llm --version")
  end
end
