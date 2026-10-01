class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "21.13.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v21.13.0/grove-v21.13.0-aarch64-apple-darwin.tar.xz"
      sha256 "fd0e9c29e6a2a602ed89be4f2a246c4ef7ec5d8d8da09a1e3716cf2ddafbbda8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v21.13.0/grove-v21.13.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "85ac63a64fef06b1e8583d3507fbecf69e074e7dede2f832eed903c0bd0e6e6f"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v21.13.0/grove-v21.13.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ff4525323658d05da9fb5e2e4aa152b98240138b1da312efa64ec2ccb1d0b48"
    end
  end

  def install
    # Codex skill snapshots are embedded in grove and provisioned at startup.
    # Claude Code retains marketplace delivery; no separate payload is fetched.
    #
    # The archive is an installation prefix, and the keg keeps its shape:
    # harness-dispatch finds its private policy worker at
    # ../libexec/harness-dispatch/ from its own real path, which the bin/
    # symlink Homebrew links resolves to. No system Bun or Node takes part.
    bin.install "bin/grove", "bin/grove-llm", "bin/harness-dispatch"
    libexec.install "libexec/harness-dispatch"
  end

  def caveats
    <<~EOS
      Codex: when ~/.codex is a directory or CODEX_HOME is nonempty, bare grove
      installs and repairs all bundled compatible skills in ~/.agents/skills before
      launching a session. No separate checkout or download is needed;
      the skills update with the installed binary.

      Claude Code: install the plugins and enable marketplace auto-update:

        /plugin marketplace add Linkuistics/grove
        /plugin install grove@linkuistics
        /plugin install linkuistics@linkuistics
        /plugin install testanyware@linkuistics

        /plugin -> Marketplaces -> Enable auto-update

      Gemini CLI and Pi: clone the repository and run its installer:

        git clone https://github.com/Linkuistics/grove
        ./grove/plugins/install.sh

      Grove also needs launch policy in ~/.config/grove/config.kdl. Run
      grove config examples for inactive samples, then give every session
      kind you use a command template before the first run.
    EOS
  end

  test do
    assert_equal "grove 21.13.0\n", shell_output("#{bin}/grove --version")
    assert_equal "grove-llm 21.13.0\n", shell_output("#{bin}/grove-llm --version")
    assert_equal "harness-dispatch 21.13.0\n", shell_output("#{bin}/harness-dispatch --version")

    # The worker reports its own version, and the front refuses a worker from
    # another build before evaluating anything. Inspect through a symlink to
    # the front, as bin/ is linked, so the worker is found from the real path.
    (testpath/"policy.ts").write <<~TS
      export const policy = {
        schemaVersion: 1,
        version: "brew-test",
        catalog: [{ id: "check", provider: "check", model: "check", effort: "check", program: "true", args: [{ slot: "prompt" }] }],
        routes: { check: "check" },
      };
    TS
    ln_s bin/"harness-dispatch", testpath/"harness-dispatch"
    report = JSON.parse(shell_output(
      "#{testpath}/harness-dispatch inspect --kind check --config #{testpath}/policy.ts --json",
    ))
    assert_equal "21.13.0", report["worker"]["packageVersion"]
    assert_equal (libexec/"harness-dispatch/harness-dispatch-policy").realpath.to_s, report["worker"]["path"]
  end
end
