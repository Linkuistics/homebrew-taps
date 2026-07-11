class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "10.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v10.0.0/grove-v10.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "42e7eb40d221781a5dc89fb347508a844f28774a5c3db6cf77677ed63f21016a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v10.0.0/grove-v10.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3d0a3e4ebc352144a3aaf057fee49251abf515fa56f592580ba668caf963f616"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v10.0.0/grove-v10.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e73dd81894d3735b54b10e84ec75fa27b4312bf19dffd9f668c967a63b11ef79"
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
    assert_match "grove 10.0.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 10.0.0", shell_output("#{bin}/grove-llm --version")
  end
end
