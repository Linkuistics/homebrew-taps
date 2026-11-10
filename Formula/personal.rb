class Personal < Formula
  desc "Antony Blakey's craft skills for Ravel and guardrail plugin for Claude Code"
  homepage "https://github.com/Linkuistics/PersonalSkills"
  # PersonalSkills has no releases. The formula pins one commit, and its
  # version is the date of that commit.
  url "https://github.com/Linkuistics/PersonalSkills/archive/cddcfde901cdaf8069e2aac6f3b6bc5aba9fe925.tar.gz"
  version "2026-11-06"
  sha256 "ff55ec0adea4e8994e9b650ddaa2776d2dda4778773093015560f33967809c74"
  license "Apache-2.0"
  # Revision 1 projects the source into the keg layout at the same commit.
  revision 1

  # The marketplace file of the keg's hook adapter. It lists the guardrail
  # plugin by a path relative to the keg root.
  MARKETPLACE = {
    "name"        => "personal",
    "description" => "The hook adapter of the personal Homebrew keg. The guardrail plugin " \
                     "for Claude Code. Ravel supplies the personal craft skills.",
    "owner"       => {
      "name"  => "Antony Blakey",
      "email" => "antony.blakey@gmail.com",
    },
    "plugins"     => [
      {
        "name"        => "guardrail",
        "source"      => "./libexec/plugins/guardrail",
        "description" => "A user-invoked, session-scoped guardrail for Claude Code. Its " \
                         "PreToolUse hook asks for confirmation before destructive shell " \
                         "commands and before edits outside the project boundary.",
      },
    ],
  }.freeze

  def install
    # "The keg layout" of docs/specs/codex-skill-provisioning.md in Grove.
    # The source is a private payload in libexec/skill-sources. A relative
    # directory symlink in share/ravel/skills is its public alias. Homebrew
    # links that alias into $(brew --prefix)/share/ravel/skills, Ravel's
    # default skill directory. Keg#link_dir handles the symlink as a file, so
    # `brew link` and conflict repair never link the source's files one by one.
    # install_symlink makes the link relative, so it names the same keg.
    # https://github.com/Homebrew/brew/blob/3ccfa1d07143/Library/Homebrew/keg.rb
    # https://github.com/Homebrew/brew/blob/7.0.12/Library/Homebrew/extend/pathname.rb
    # Each directory moves into the keg, so it keeps the modes of the archive.
    # Homebrew's cleaner sets modes only under bin, sbin and lib, and its prune
    # step skips libexec.
    # https://github.com/Homebrew/brew/blob/7.0.12/Library/Homebrew/cleaner.rb
    (libexec/"skill-sources").install "plugins/personal"
    (share/"ravel/skills").install_symlink libexec/"skill-sources/personal"
    (libexec/"plugins").install "plugins/guardrail"
    # The keg root, which Homebrew links nowhere, holds the marketplace file.
    (prefix/".claude-plugin").mkpath
    (prefix/".claude-plugin/marketplace.json").write "#{JSON.pretty_generate(MARKETPLACE)}\n"
  end

  def caveats
    <<~EOS
      The personal craft skills are a private copy in
      #{opt_libexec}/skill-sources/personal.
      Ravel 2.0.0 delivers them through the alias
      #{HOMEBREW_PREFIX}/share/ravel/skills/personal when its settings name
      no sources. No harness finds the skills in the keg alone.

      Ravel installs no hook. Register the guardrail plugin in Claude Code once:

        claude plugin marketplace add "$(brew --prefix)/opt/personal"
        claude plugin install guardrail@personal
    EOS
  end

  test do
    # The source is a private directory, and its public alias is a relative
    # directory symlink into this keg.
    source = libexec/"skill-sources/personal"
    assert_predicate source, :directory?
    refute_predicate source, :symlink?
    assert_predicate share/"ravel/skills/personal", :symlink?
    assert_equal "../../../libexec/skill-sources/personal", (share/"ravel/skills/personal").readlink.to_s
    assert_path_exists source/".claude-plugin/plugin.json"
    %w[authoring-conventions machine-environment using-jujutsu].each do |skill|
      assert_path_exists source/"craft"/skill/"SKILL.md"
    end
    scripts = libexec/"plugins/guardrail/skills/guardrail/scripts"
    %w[guardrail-hook.sh guardrail-hook.test.sh].each do |script|
      assert_predicate scripts/script, :executable?
    end
    refute_predicate source/"craft/using-jujutsu/SKILL.md", :executable?

    marketplace = JSON.parse((prefix/".claude-plugin/marketplace.json").read)
    assert_equal "personal", marketplace["name"]
    assert_equal ["guardrail"], marketplace["plugins"].map { |plugin| plugin["name"] }
    plugin = prefix/marketplace["plugins"].first["source"]
    assert_equal "guardrail", JSON.parse((plugin/".claude-plugin/plugin.json").read)["name"]
  end
end
