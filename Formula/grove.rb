class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "18.2.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v18.2.0/grove-v18.2.0-aarch64-apple-darwin.tar.xz"
      sha256 "5f8ba3626bac0be8189fdd8fec5f4d3c549908f90a5cd1be2ae5476dfa6b2ae4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v18.2.0/grove-v18.2.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c99d19105544e41d02271ccc8090045100ecc67b133c8d7139ebe25eb1057c60"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v18.2.0/grove-v18.2.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "567b1a5ee08dd3d57a899ae14f9630e50507dc6391b857701ca5d541785e393f"
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
    assert_match "grove 18.2.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 18.2.0", shell_output("#{bin}/grove-llm --version")
  end
end
