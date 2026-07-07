class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "9.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v9.1.0/grove-v9.1.0-aarch64-apple-darwin.tar.xz"
      sha256 "f5c265c2548f5e19ac6e842a1f6dfa7bfb5587465414a64bddd5dabd6db06003"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v9.1.0/grove-v9.1.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2abf0e773d7107e771d78adbcb85e372f03e5c68b45933deb2a4dfee04562c1d"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v9.1.0/grove-v9.1.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6ea133a5a6390972a2a3b902fe75b5a691b2933496a5130b34eff4b32eaeca0e"
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
    assert_match "grove 9.1.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 9.1.0", shell_output("#{bin}/grove-llm --version")
  end
end
