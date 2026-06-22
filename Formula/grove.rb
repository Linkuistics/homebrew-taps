class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "8.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v8.0.0/grove-v8.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "ec783cd74e3342f386dacaa6dcfe08155f78a526dab70a20944ce79c17383c79"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v8.0.0/grove-v8.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7311fce4de0f110424d5ce07f0a00a90cd79f3be50f5db77c154fc059c412cc3"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v8.0.0/grove-v8.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1708c3ed19f646d6aef1849cf8d41e218254c83f8c11290198d29c65901e6466"
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
    assert_match "grove 8.0.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 8.0.0", shell_output("#{bin}/grove-llm --version")
  end
end
