class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "18.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v18.0.0/grove-v18.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "48d140d42bf51d52e389e4174a2a9176045f1d08db9833bcb03038a1d711e745"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v18.0.0/grove-v18.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e91b8f384eda8fe2e9355f34f2f895493017fc926301a19884a0a1f849bc88e5"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v18.0.0/grove-v18.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "09d23ff20e48ce59d6fa9c772448f4e26fb4f7d67ae03a4954031b321f4413d3"
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
    assert_match "grove 18.0.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 18.0.0", shell_output("#{bin}/grove-llm --version")
  end
end
