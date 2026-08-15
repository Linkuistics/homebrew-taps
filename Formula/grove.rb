class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "18.3.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v18.3.1/grove-v18.3.1-aarch64-apple-darwin.tar.xz"
      sha256 "5683d314d8acaab02550a7416e4b20befa9f5b722edd2879618f4f135ce353f5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v18.3.1/grove-v18.3.1-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3497d10e24528d94548acdd2bdb618fcb825f3db6a8746ad80a8d60d2f9683f3"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v18.3.1/grove-v18.3.1-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7fd86801bf085e9e4d5af0ce373a9e358b7258a294a4e226aef728be805f962e"
    end
  end

  def install
    # The methodology skill is NOT fetched or installed here. The `grove` binary
    # embeds the full `content/` tree (self-extension-core-and-methodology / task-tree-scheme) and provisions it to
    # ~/.claude/skills/grove/ on the first run, so the skill can never drift
    # from the binary. Do NOT reintroduce a content/ download into this formula
    # or the release tarball — `brew install grove` is the sole gesture.
    bin.install "grove", "grove-llm"
  end

  def caveats
    <<~EOS
      grove ships its methodology inside the binary. The first
        grove
      run from inside your working tree provisions the global skill at
      ~/.claude/skills/grove/ — there is no separate install step. The skill
      re-provisions automatically the next time you run `grove` after upgrading
      the formula.

      grove reads all of its launch policy from ~/.config/grove/config.kdl,
      which it never creates: give every session kind one command template
      before the first run.
    EOS
  end

  test do
    assert_match "grove 18.3.1", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 18.3.1", shell_output("#{bin}/grove-llm --version")
  end
end
