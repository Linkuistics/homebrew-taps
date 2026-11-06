class QuintLlmKit < Formula
  desc "Informal Systems' Quint specification skills as a Ravel skill source"
  homepage "https://github.com/quint-co/quint-llm-kit"
  # quint-llm-kit has no releases. The formula pins one commit, and its version
  # is that of the commit's plugin manifest.
  url "https://github.com/quint-co/quint-llm-kit/archive/cc75369f741af7d490936f82002c2d28e3b3d78d.tar.gz"
  version "1.0.0"
  sha256 "152947a80275a1d8dd935ba6bec58e58ef92ef367cd70ca7a142b81dbbd5ca20"
  license "Apache-2.0"

  def install
    # The keg layout of docs/specs/codex-skill-provisioning.md in Grove. The
    # source is quint-llm-kit-plugin, whose root is skills, under the source ID
    # quint. Homebrew links share/ravel/skills/quint into
    # $(brew --prefix)/share/ravel/skills, Ravel's default skill directory.
    # The directory moves into the keg, so it keeps the modes of the archive.
    (share/"ravel/skills").install "quint-llm-kit-plugin" => "quint"
  end

  def caveats
    <<~EOS
      Ravel 2.0.0 delivers the Quint skills from
      #{HOMEBREW_PREFIX}/share/ravel/skills/quint when its settings name
      no sources. No harness finds the skills in the keg alone.
    EOS
  end

  test do
    source = share/"ravel/skills/quint"
    assert_equal "quint-llm-kit", JSON.parse((source/".claude-plugin/plugin.json").read)["name"]
    %w[quint-execute-spec quint-lang quint-modeling].each do |skill|
      assert_path_exists source/"skills"/skill/"SKILL.md"
      refute_predicate source/"skills"/skill/"SKILL.md", :executable?
    end
  end
end
