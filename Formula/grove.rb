class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "10.0.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v10.0.1/grove-v10.0.1-aarch64-apple-darwin.tar.xz"
      sha256 "7cc2935540ef7e081a7759f118e05a0a46606f2c5010811036337aa9d77c9aea"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v10.0.1/grove-v10.0.1-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b7ed642cd5a2f747afca15e307d3616f3f0faf4e30535a6a5a1675b0f0d9c508"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v10.0.1/grove-v10.0.1-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7f917e4d5314e95d6046c51dcbbe952d8eae43132698ef2e94f76a3b892bdcee"
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
    assert_match "grove 10.0.1", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 10.0.1", shell_output("#{bin}/grove-llm --version")
  end
end
