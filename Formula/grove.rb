class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "10.0.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v10.0.3/grove-v10.0.3-aarch64-apple-darwin.tar.xz"
      sha256 "b315314b7e305d15c4457f4b0c63aabda9fc4567fa1630dddb7f0305a1bd35e9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v10.0.3/grove-v10.0.3-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bbf45b044a859d33c1ed49c9f691b51cfe139ce789053e26cb6563b4aef96290"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v10.0.3/grove-v10.0.3-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "69608a31c2a7f5e4ffd8eef364f0fc2756094dcaa95e02aca8fb50900c546d87"
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
    assert_match "grove 10.0.3", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 10.0.3", shell_output("#{bin}/grove-llm --version")
  end
end
