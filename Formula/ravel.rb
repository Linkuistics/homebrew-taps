require "shellwords"

class Ravel < Formula
  desc "Policy router and session process manager"
  homepage "https://github.com/Linkuistics/Ravel"
  version "1.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/Ravel/releases/download/v1.0.0/ravel-v1.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "d1f253db86cde3c625950cda2d8fa929ca4d1e4529ca6c3f223e138f9be9a922"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/Ravel/releases/download/v1.0.0/ravel-v1.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "288158c1259667dbd11d9f71aa5d643b4da4e08ffc4402524f4852afb314f732"
    end
    on_intel do
      url "https://github.com/Linkuistics/Ravel/releases/download/v1.0.0/ravel-v1.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1264ea0f3dd113f5dbb0914992ee9a7734285c0ddcc161e9acaffd83c037f9a9"
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
    assert_equal "ravel 1.0.0\n", shell_output([(bin/"ravel").to_s, "--version"].shelljoin)
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
