class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "19.3.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v19.3.0/grove-v19.3.0-aarch64-apple-darwin.tar.xz"
      sha256 "805cbdaf1f5ee4bf706e3d88b60eec4a91380e40f73f4e5fdebba1f7844462d0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v19.3.0/grove-v19.3.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "13b78b7b197fc8f9fc62a1d1fd2c6f0f28c52ca0fcae477a8adf347d25c5c221"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v19.3.0/grove-v19.3.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f93e2e2f38bb28954b560d77862e50cbe9acd8881792580f6b08640bcc7c8c92"
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
    assert_match "grove 19.3.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 19.3.0", shell_output("#{bin}/grove-llm --version")
  end
end
