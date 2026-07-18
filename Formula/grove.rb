class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "12.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v12.0.0/grove-v12.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "d9fdc291b948402aabdcb2d9967ec82103fa30bbf14dbc97e663b2cbd4397974"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v12.0.0/grove-v12.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "82e8546eeb15291808b1d2ba85847b04c235c12a93cc668af5a604a1edc68ab8"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v12.0.0/grove-v12.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "068bbae048dd46a15d07dbc73d3877f95c4b08cb1dde23b974ffa86875d70b37"
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
    assert_match "grove 12.0.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 12.0.0", shell_output("#{bin}/grove-llm --version")
  end
end
