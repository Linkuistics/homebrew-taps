require "json"
require "shellwords"

# Rendered once for each channel in scripts/release-channel.sh, from the same
# archives. Only the class and the keg_only line differ between channels.
class RavelAT2 < Formula
  desc "Configuration router and session process manager"
  homepage "https://github.com/Linkuistics/Ravel"
  version "2.0.0"
  license "Apache-2.0"
  keg_only :versioned_formula
  deprecate! date: "2026-11-11", because: :versioned_formula, replacement_formula: "ravel"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/Ravel/releases/download/v2.0.0/ravel-v2.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "5957840ab33f4331b794539dbd455d801f71c6c6485c781dc290cfb48490231d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/Ravel/releases/download/v2.0.0/ravel-v2.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a4750ea439450e88621be411183e7bf30d2616f9a545b64a30445df3a9f02bee"
    end
    on_intel do
      url "https://github.com/Linkuistics/Ravel/releases/download/v2.0.0/ravel-v2.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "906e589f72161ed5dce5db683e6af10963c1952bdf177c6b343d1918928c3dd1"
    end
  end

  def install
    # Homebrew prefix/test helpers: https://docs.brew.sh/Formula-Cookbook
    # Rhai is embedded in the executable; examples and Rust notices are data.
    bin.install "bin/ravel"
    (share/"ravel").install "share/ravel/examples", "share/ravel/notices"
    # docs/specs/skill-discovery.md, "The installation record". The shared
    # prefix, not the keg, so the keg-only ravel@2 names the same directory.
    # HOMEBREW_PREFIX: https://docs.brew.sh/Formula-Cookbook#variables-for-directory-locations
    write_installation_record(share, HOMEBREW_PREFIX/"share/ravel/skills")
  end

  # Write SHARE/ravel/installation.json, naming SKILL_DIRECTORY.
  def write_installation_record(share, skill_directory)
    (share/"ravel").mkpath
    record = { schemaVersion: 1, skillDirectory: skill_directory.to_s }
    (share/"ravel/installation.json").write("#{JSON.generate(record)}\n")
  end

  test do
    assert_equal "ravel 2.0.0\n", shell_output([(bin/"ravel").to_s, "--version"].shelljoin)
    (testpath/"home").mkpath
    (testpath/"tmp").mkpath
    # The default skill directory belongs to the installation, not to a HOME,
    # and the machine's shared one can hold sources. This HOME turns it off,
    # so these launches keep their prompts exact.
    # docs/specs/skill-discovery.md, "Default skill directory".
    (testpath/"home/.config/ravel").mkpath
    (testpath/"home/.config/ravel/settings.json").write "{\"skills\":{\"schemaVersion\":1,\"sources\":[]}}\n"
    ln_s bin/"ravel", testpath/"ravel"
    (testpath/"fake-agent").write <<~SH
      #!/bin/sh
      printf 'fixture stdout\n'
      exec "$1" end-session -- "$2"
    SH
    (testpath/"fake-agent").chmod 0755
    (testpath/"config.rhai").write <<~RHAI
      import "#{(share/"ravel/examples/static").to_s}" as starter;
      export const SCHEMA_VERSION = 4;
      export const VERSION = "brew-test";
      fn select(request, context) {
        let routes = \#{ check: |request| \#{
          program: #{(testpath/"fake-agent").to_s.inspect},
          args: [#{(testpath/"ravel").to_s.inspect}, request.prompt],
          provider: "fixture", model: "none", effort: "none"
        } };
        starter::select_route(routes, request)
      }
    RHAI
    # Scrub live authority and configuration. The child ends this fixture's
    # session and its output must not contaminate the opaque result stream.
    ["exact result", "", "first\nsecond\n", "--help"].each do |result|
      command = ["/usr/bin/env", "-i", "PATH=/usr/bin:/bin",
                 "HOME=#{testpath}/home", "TMPDIR=#{testpath}/tmp",
                 (testpath/"ravel").to_s, "start-session", "--kind", "check",
                 "--config", (testpath/"config.rhai").to_s, "--prompt", result]
      assert_equal result, shell_output(command.shelljoin)
    end
    assert_equal [], Dir.children(testpath/"tmp")

    # The record that install wrote names the shared skill directory.
    record = JSON.parse((share/"ravel/installation.json").read)
    assert_equal({ "schemaVersion" => 1, "skillDirectory" => "#{HOMEBREW_PREFIX}/share/ravel/skills" }, record)
    # The sandbox denies writes to HOMEBREW_PREFIX, and a fixture there would
    # reach every running session. A copy of the executable is a private
    # installation: Ravel finds its record beside the canonical executable.
    relocated = testpath/"relocated"
    (relocated/"bin").mkpath
    cp bin/"ravel", relocated/"bin/ravel"
    chmod 0755, relocated/"bin/ravel"
    skills = testpath/"skills"
    write_installation_record(relocated/"share", skills)
    (skills/"fixture/skills/check").mkpath
    (skills/"fixture/skills/check/SKILL.md").write "---\nname: check\ndescription: fixture\n---\n"
    # A HOME without settings, so the private record supplies the source set.
    (testpath/"home-default").mkpath
    no_settings = ["/usr/bin/env", "-i", "PATH=/usr/bin:/bin",
                   "HOME=#{testpath}/home-default", "TMPDIR=#{testpath}/tmp", (relocated/"bin/ravel").to_s]
    resolved = JSON.parse(shell_output((no_settings + ["skills", "resolve", "--json"]).shelljoin))
    assert_equal "resolved", resolved["status"]
    assert_equal ["fixture"], resolved["sources"].map { |source| source["id"] }
    assert_equal (skills/"fixture").realpath.to_s, resolved["sources"][0]["originPath"]
    # A launch protects the directory of its configuration script, which
    # must not hold the source.
    (testpath/"launch").mkpath
    cp testpath/"config.rhai", testpath/"launch/config.rhai"
    launch = no_settings + ["start-session", "--kind", "check", "--config", (testpath/"launch/config.rhai").to_s,
                            "--prompt", "task", "--json"]
    shell_output("#{launch.shelljoin} 2>#{(testpath/"notice").to_s.shellescape}")
    notice = (testpath/"notice").readlines.filter_map do |line|
      document = JSON.parse(line) if line.start_with?("{")
      document if document&.key?("selection")
    end
    assert_equal [skills.to_s], notice.map { |document| document["skills"]["defaultDirectory"] }
  ensure
    # Snapshots are read-only by design. Let Homebrew remove the test path.
    %w[home home-default].each { |home| chmod_R "u+w", testpath/home if (testpath/home).exist? }
  end
end
