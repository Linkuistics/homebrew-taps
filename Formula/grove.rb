class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "10.0.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v10.0.2/grove-v10.0.2-aarch64-apple-darwin.tar.xz"
      sha256 "d100c94f4c85e19def47b751627c13164832f8efb28ca71796c8684d23931d59"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v10.0.2/grove-v10.0.2-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3488dcc3ddedc795ca5a3b5d8750c0cd8c514c4ab450d9a82376997e455c4a20"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v10.0.2/grove-v10.0.2-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c2c00e5db160f996697eab97a46791a039a2ccf420668d81ea6b8fcd289dda19"
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
    assert_match "grove 10.0.2", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 10.0.2", shell_output("#{bin}/grove-llm --version")
  end
end
