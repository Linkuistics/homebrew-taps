class QuintLlmKit < Formula
  desc "Informal Systems' Quint specification skills as a Ravel skill source"
  homepage "https://github.com/quint-co/quint-llm-kit"
  # quint-llm-kit has no releases. The formula pins one commit, and its version
  # is that of the commit's plugin manifest.
  url "https://github.com/quint-co/quint-llm-kit/archive/cc75369f741af7d490936f82002c2d28e3b3d78d.tar.gz"
  version "1.0.0"
  sha256 "152947a80275a1d8dd935ba6bec58e58ef92ef367cd70ca7a142b81dbbd5ca20"
  license "Apache-2.0"
  # Revision 1 projects the source into the keg layout at the same commit.
  revision 1

  def install
    # "The keg layout" of docs/specs/codex-skill-provisioning.md in Grove. The
    # source is quint-llm-kit-plugin, whose root is skills, under the source ID
    # quint. The source is a private payload in libexec/skill-sources. A
    # relative directory symlink in share/ravel/skills is its public alias.
    # Homebrew links that alias into $(brew --prefix)/share/ravel/skills,
    # Ravel's default skill directory. Keg#link_dir handles the symlink as a
    # file, so `brew link` and conflict repair never link the source's files
    # one by one. install_symlink makes the link relative, so it names the
    # same keg.
    # https://github.com/Homebrew/brew/blob/3ccfa1d07143/Library/Homebrew/keg.rb
    # https://github.com/Homebrew/brew/blob/7.0.12/Library/Homebrew/extend/pathname.rb
    # The directory moves into the keg, so it keeps the modes of the archive.
    # Homebrew's cleaner sets modes only under bin, sbin and lib, and its prune
    # step skips libexec.
    # https://github.com/Homebrew/brew/blob/7.0.12/Library/Homebrew/cleaner.rb
    (libexec/"skill-sources").install "quint-llm-kit-plugin" => "quint"
    (share/"ravel/skills").install_symlink libexec/"skill-sources/quint"
  end

  def caveats
    <<~EOS
      The Quint skills are a private copy in
      #{opt_libexec}/skill-sources/quint.
      Ravel 2.0.0 delivers them through the alias
      #{HOMEBREW_PREFIX}/share/ravel/skills/quint when its settings name
      no sources. No harness finds the skills in the keg alone.
    EOS
  end

  test do
    # The source is a private directory, and its public alias is a relative
    # directory symlink into this keg.
    source = libexec/"skill-sources/quint"
    assert_predicate source, :directory?
    refute_predicate source, :symlink?
    assert_predicate share/"ravel/skills/quint", :symlink?
    assert_equal "../../../libexec/skill-sources/quint", (share/"ravel/skills/quint").readlink.to_s
    assert_equal "quint-llm-kit", JSON.parse((source/".claude-plugin/plugin.json").read)["name"]
    %w[quint-execute-spec quint-lang quint-modeling].each do |skill|
      assert_path_exists source/"skills"/skill/"SKILL.md"
      refute_predicate source/"skills"/skill/"SKILL.md", :executable?
    end
  end
end
