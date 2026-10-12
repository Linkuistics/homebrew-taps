require "shellwords"

class Ravel < Formula
  desc "Policy router and session process manager"
  homepage "https://github.com/Linkuistics/Ravel"
  version "0.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/Ravel/releases/download/v0.1.0/ravel-v0.1.0-aarch64-apple-darwin.tar.xz"
      sha256 "7e33ae0c56a93e6a5cff256c5a8a981dec4eb4d114c1f636ce8ee23d1f5d1059"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/Ravel/releases/download/v0.1.0/ravel-v0.1.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "19a20dc895a09440cbe3d8da1ce80b96311fbc1c3e6be5e2bf1eb18bb6cc0f7e"
    end
    on_intel do
      url "https://github.com/Linkuistics/Ravel/releases/download/v0.1.0/ravel-v0.1.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b9e3443dc428923d6ab45dff7d3837def16bd36985ddd5900f75489a7a4b96e8"
    end
  end

  def install
    # Homebrew prefix/test helpers: https://docs.brew.sh/Formula-Cookbook
    # Resolve the matching private worker from the front's real path, including
    # Homebrew's bin symlink. The pair needs no host Bun, Node or Grove.
    bin.install "bin/ravel"
    libexec.install "libexec/ravel"
  end

  test do
    assert_equal "ravel 0.1.0\n", shell_output([(bin/"ravel").to_s, "--version"].shelljoin)
    (testpath/"home").mkpath
    (testpath/"tmp").mkpath
    ln_s bin/"ravel", testpath/"ravel"
    (testpath/"fake-agent").write <<~SH
      #!/bin/sh
      printf 'fixture stdout\n'
      exec "$1" end-session -- "$2"
    SH
    (testpath/"fake-agent").chmod 0755
    (testpath/"policy.ts").write <<~TS
      import { definePolicy } from "ravel/sdk";
      import { selectRoute } from "ravel/examples/static";
      const routes = { check: request => ({
        program: #{(testpath/"fake-agent").to_s.inspect},
        args: [#{(testpath/"ravel").to_s.inspect}, request.prompt],
        provider: "fixture", model: "none", effort: "none"
      }) };
      export const policy = definePolicy({
        schemaVersion: 2, version: "brew-test",
        select: request => selectRoute(routes, request)
      });
    TS
    # Scrub live authority and configuration. The child ends this fixture's
    # session and its output must not contaminate the opaque result stream.
    ["exact result", "", "first\nsecond\n", "--help"].each do |result|
      command = ["/usr/bin/env", "-i", "PATH=/usr/bin:/bin",
                 "HOME=#{testpath}/home", "TMPDIR=#{testpath}/tmp",
                 (testpath/"ravel").to_s, "start-session", "--kind", "check",
                 "--config", (testpath/"policy.ts").to_s, "--prompt", result]
      assert_equal result, shell_output(command.shelljoin)
    end
    assert_equal [], Dir.children(testpath/"tmp")
  end
end
