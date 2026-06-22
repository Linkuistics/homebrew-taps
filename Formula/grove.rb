class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "7.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v7.0.0/grove-v7.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "80b7537fd427db15faf0c3518e20efd84dbf4b99faea24c09b0de736032822e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v7.0.0/grove-v7.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "69c470e84b3b6bfc028f57325417e2e76f380b5f6751f4fdc8ce81d20b279f1f"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v7.0.0/grove-v7.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fb4453ca7ca6408d4a7ced4d03928e3cdce12a36b24a467bdc7683c1ba5fe0df"
    end
  end

  def install
    # The methodology skill is NOT fetched or installed here. The `grove` binary
    # embeds the full `content/` tree (ADR-0031/0034) and provisions it to
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
    assert_match "grove 7.0.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 7.0.0", shell_output("#{bin}/grove-llm --version")
  end
end
