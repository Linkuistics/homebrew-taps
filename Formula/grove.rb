class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "18.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v18.1.0/grove-v18.1.0-aarch64-apple-darwin.tar.xz"
      sha256 "8c702a060d1de33bf7306e50fc78beb1e7364852a09565cc19aa7628155d08b5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v18.1.0/grove-v18.1.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e79ab86b1b2eae4b4e66a0446a18ded26f0dfb0a0f8ddcd1e5488eaaf0a224bd"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v18.1.0/grove-v18.1.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "95c10705cc44111e07a80c1242f8c19a108000883f3a36a1e4544d6440a76bef"
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
    assert_match "grove 18.1.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 18.1.0", shell_output("#{bin}/grove-llm --version")
  end
end
