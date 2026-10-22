require "shellwords"

class Ravel < Formula
  desc "Policy router and session process manager"
  homepage "https://github.com/Linkuistics/Ravel"
  version "1.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/Ravel/releases/download/v1.1.0/ravel-v1.1.0-aarch64-apple-darwin.tar.xz"
      sha256 "92ec94083495f536136a17310ce1624004d145569f6fbf92da978aee65e7c357"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/Ravel/releases/download/v1.1.0/ravel-v1.1.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4334bd0adfa97391925b44029e96ce70744ecf3d141a2b5bb21174fd7cfa9c60"
    end
    on_intel do
      url "https://github.com/Linkuistics/Ravel/releases/download/v1.1.0/ravel-v1.1.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2a0f91c793069fa2dd8d73fcbe0fe383d383d029f60adc4a5b7f3726919b60fb"
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
    assert_equal "ravel 1.1.0\n", shell_output([(bin/"ravel").to_s, "--version"].shelljoin)
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
