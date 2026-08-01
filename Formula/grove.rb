class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "16.3.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v16.3.1/grove-v16.3.1-aarch64-apple-darwin.tar.xz"
      sha256 "fcf10fe10511778fb83ae80666fef285a055a650ce60672f754d7108bc8fd566"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v16.3.1/grove-v16.3.1-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "85262991c4b8af6cb1a14e60a5e1903c4d8d158ddda4b9470714082e0bd8b631"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v16.3.1/grove-v16.3.1-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d4fdd97f4419d5fcb351a82f987b044568453125e5627a167e2447fba0e269f1"
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
    assert_match "grove 16.3.1", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 16.3.1", shell_output("#{bin}/grove-llm --version")
  end
end
