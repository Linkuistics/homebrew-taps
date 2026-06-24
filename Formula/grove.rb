class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "8.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v8.1.0/grove-v8.1.0-aarch64-apple-darwin.tar.xz"
      sha256 "e67c7452b86151d032d39546047be670f0856adb440a1a94fbc0c0a9709d3b61"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v8.1.0/grove-v8.1.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "81ef30db27535e177fa3232c05ec32453183121ff5b6c96f277e017495706dc9"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v8.1.0/grove-v8.1.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "30fd6c96fb611f611234597f500e7f10096f418b0e28abd8cc2af2ddfdbb1903"
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
    assert_match "grove 8.1.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 8.1.0", shell_output("#{bin}/grove-llm --version")
  end
end
