class Superpowers < Formula
  desc "Jesse Vincent's development workflow skills as a Ravel skill source"
  homepage "https://github.com/obra/superpowers"
  # The commit of upstream release v7.0.0, through its GitHub source archive.
  url "https://github.com/obra/superpowers/archive/bb92a77741419a4ab5f06e711a283343f1ada0c3.tar.gz"
  version "7.0.0"
  sha256 "496b576d4a4a62c0d72cce4a9e99ff46c57026c07fe503931cbb8afd33006cf2"
  license "MIT"
  # Revision 1 projects the source into the keg layout at the same commit.
  revision 1

  def install
    # "The keg layout" of docs/specs/codex-skill-provisioning.md in Grove. The
    # source is the whole repository root, so Ravel's mandatory file
    # skills/using-superpowers/SKILL.md keeps its path. The source is a
    # private payload in libexec/skill-sources. A relative directory symlink
    # in share/ravel/skills is its public alias. Homebrew links that alias
    # into $(brew --prefix)/share/ravel/skills, Ravel's default skill
    # directory. Keg#link_dir handles the symlink as a file, so `brew link`
    # and conflict repair never link the source's files one by one.
    # install_symlink makes the link relative, so it names the same keg.
    # https://github.com/Homebrew/brew/blob/3ccfa1d07143/Library/Homebrew/keg.rb
    # https://github.com/Homebrew/brew/blob/7.0.12/Library/Homebrew/extend/pathname.rb
    # Each entry moves into the keg, so it keeps the modes of the archive.
    # Homebrew's cleaner sets modes only under bin, sbin and lib, and its prune
    # step skips libexec.
    # https://github.com/Homebrew/brew/blob/7.0.12/Library/Homebrew/cleaner.rb
    # Homebrew's stage makes .brew_home in the build directory, and the source
    # leaves it out.
    # https://github.com/Homebrew/brew/blob/7.0.12/Library/Homebrew/formula.rb
    entries = buildpath.children.reject { |entry| entry.basename.to_s == ".brew_home" }
    (libexec/"skill-sources/superpowers").install entries
    (share/"ravel/skills").install_symlink libexec/"skill-sources/superpowers"
  end

  def caveats
    <<~EOS
      The superpowers skills are a private copy in
      #{opt_libexec}/skill-sources/superpowers.
      Ravel 2.0.0 delivers them through the alias
      #{HOMEBREW_PREFIX}/share/ravel/skills/superpowers when its settings name
      no sources. No harness finds the skills in the keg alone.
    EOS
  end

  test do
    # The source is a private directory, and its public alias is a relative
    # directory symlink into this keg.
    source = libexec/"skill-sources/superpowers"
    assert_predicate source, :directory?
    refute_predicate source, :symlink?
    assert_predicate share/"ravel/skills/superpowers", :symlink?
    assert_equal "../../../libexec/skill-sources/superpowers", (share/"ravel/skills/superpowers").readlink.to_s
    assert_equal "superpowers", JSON.parse((source/".claude-plugin/plugin.json").read)["name"]
    assert_equal 15, (source/"skills").children.count { |skill| (skill/"SKILL.md").file? }
    assert_path_exists source/"skills/using-superpowers/SKILL.md"
    refute_predicate source/"skills/using-superpowers/SKILL.md", :executable?
    assert_predicate source/"skills/brainstorming/scripts/start-server.sh", :executable?
    refute_path_exists source/".brew_home"
  end
end
