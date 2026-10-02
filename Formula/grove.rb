class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "22.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v22.0.0/grove-v22.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "b04fb9642404757c6cbcbf523ada5db250239a97db6571def3e479f58e19d5d1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v22.0.0/grove-v22.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7d58558639925aa84b082e781ed742cb37209cb0663379876bf3afe2758858f7"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v22.0.0/grove-v22.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "65e0212e375b7f01467afc0bb75e1462a877d5cfc3206741ac4b6cba1cece29f"
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

      Grove launches every session through harness-dispatch, which needs
      your policy in ~/.config/harness-dispatch/policy.ts. Install the sample:

        harness-dispatch init

      Read it and edit it before the first run: it launches codex with
      approvals off and full access. A config.kdl or .grove.kdl from an
      earlier release is no longer read.
    EOS
  end

  test do
    assert_equal "grove 22.0.0\n", shell_output("#{bin}/grove --version")
    assert_equal "grove-llm 22.0.0\n", shell_output("#{bin}/grove-llm --version")
    assert_equal "harness-dispatch 22.0.0\n", shell_output("#{bin}/harness-dispatch --version")

    # The worker reports its own version, and the front refuses a worker from
    # another build before evaluating anything. Inspect through a symlink to
    # the front, as bin/ is linked, so the worker is found from the real path.
    (testpath/"policy.ts").write <<~TS
      export const policy = {
        schemaVersion: 2,
        version: "brew-test",
        select: () => ({
          status: "selected",
          program: "true",
          args: [],
          provider: "check",
          model: "check",
          effort: "check",
          reason: "brew test",
        }),
      };
    TS
    ln_s bin/"harness-dispatch", testpath/"harness-dispatch"
    report = JSON.parse(shell_output(
      "#{testpath}/harness-dispatch inspect --kind check --config #{testpath}/policy.ts --json",
    ))
    assert_equal "22.0.0", report["worker"]["packageVersion"]
    assert_equal (libexec/"harness-dispatch/harness-dispatch-policy").realpath.to_s, report["worker"]["path"]
  end
end
