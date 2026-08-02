class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "16.5.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v16.5.0/grove-v16.5.0-aarch64-apple-darwin.tar.xz"
      sha256 "9680da9cfd8f5d3fefc1f0d728315f8b2e3242dcdc5b33fd1841fc44712ebe05"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v16.5.0/grove-v16.5.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0786092e8ffcf97e7256fa6e5fcd3ff0fdc4eb0f0f757cb74855442f2206c24e"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v16.5.0/grove-v16.5.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f736f068fbc08c2fda1c2ddc5ab53422b31d5521ab7a1423e9d60e424be4207c"
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
    assert_match "grove 16.5.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 16.5.0", shell_output("#{bin}/grove-llm --version")
  end
end
