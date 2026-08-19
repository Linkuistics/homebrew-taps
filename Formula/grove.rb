class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "19.2.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v19.2.0/grove-v19.2.0-aarch64-apple-darwin.tar.xz"
      sha256 "44e3f1f2fddfadcf650b70876a026d75c72269c607a001bab13cdf225fc119e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v19.2.0/grove-v19.2.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3a89ab9031c9c2d9098d134fe13788e10fe5580339fe60d92763999337fb1800"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v19.2.0/grove-v19.2.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ca614baea934eefd0cfc77bc0364f344dcd3bef14536738dd1644053c2b31ed"
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
    assert_match "grove 19.2.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 19.2.0", shell_output("#{bin}/grove-llm --version")
  end
end
