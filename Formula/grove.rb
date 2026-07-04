class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "9.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v9.0.0/grove-v9.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "8367b4d9fada96b77d26259927d86ef643c042fe42572469d9dbaafb98abb793"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v9.0.0/grove-v9.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "972d0f1b8078abb03e6662c12e80de8f39ea74431342ac0ff9831899122bf23a"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v9.0.0/grove-v9.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a579da63d26b67ebcc5f61b18fd9d58d4ab9cc504aecf71bbab1fd484556ca3"
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
        grove do <name>
      provisions the global skill at ~/.claude/skills/grove/ — there is no
      separate install step. The skill re-provisions automatically the next time
      you run `grove do` after upgrading the formula.
    EOS
  end

  test do
    assert_match "grove 9.0.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 9.0.0", shell_output("#{bin}/grove-llm --version")
  end
end
