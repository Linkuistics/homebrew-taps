class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "22.2.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v22.2.0/grove-v22.2.0-aarch64-apple-darwin.tar.xz"
      sha256 "081893c977cebb734ae90280148f15be5fa73d605c327b7c19c054f3f31ca9e3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v22.2.0/grove-v22.2.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aad8b5a9ddb94530716c34f96684092d3f05b446a48b650a53a2494474b82d69"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v22.2.0/grove-v22.2.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1938c16715a0aa8f37a989b69b5bb54bd50eea4a318f0cb6825b5cf4f631c76b"
    end
  end

  depends_on "linkuistics/taps/ravel"

  def install
    # Codex skill snapshots are embedded in grove and provisioned at startup.
    # Claude Code retains marketplace delivery; no separate payload is fetched.
    #
    # Readable caller assets retain ordinary relative imports. Ravel owns its
    # own front, private worker, SDK and notices in its independently sized keg.
    bin.install "bin/grove", "bin/grove-llm"
    libexec.install "libexec/ravel-policy"
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

      Grove launches sessions through the independent Ravel dependency.
      Copy the readable sample and edit your owner policy before the first run:

        mkdir -p ~/.config/ravel
        cp #{libexec}/ravel-policy/sample/policy.ts ~/.config/ravel/policy.ts

      The sample launches codex with approvals off and full access. Copy only
      into an absent policy; preserve an existing policy and its relative helpers.
      Creator-aware examples live in #{libexec}/ravel-policy/examples;
      keep the whole caller asset tree together when copying their imports.
      Earlier config.kdl or .grove.kdl files are no longer read.
    EOS
  end

  test do
    assert_equal "grove 22.2.0\n", shell_output("#{bin}/grove --version")
    assert_equal "grove-llm 22.2.0\n", shell_output("#{bin}/grove-llm --version")
    ravel = Formula["ravel"].opt_bin/"ravel"
    assert_match(/^ravel 0\.1\./, shell_output("#{ravel} --version"))
    assets = libexec/"ravel-policy"
    %w[README.md grove.ts provenance.ts examples/grove-static.ts
       examples/grove-review.ts examples/review.ts sample/policy.ts
       typecheck/static.ts typecheck/review.ts].each do |asset|
      assert_path_exists assets/asset
    end
    # Homebrew's test sandbox cannot nest Ravel's macOS confinement sandbox.
    # https://github.com/Homebrew/brew/blob/master/Library/Homebrew/dev-cmd/test.rb
    # Exercise lifecycle here; release verification separately runs confined
    # standalone publication through scripts/grove-installed-smoke.sh.
    (testpath/"home/.config/ravel").mkpath
    (testpath/".jj/repo").mkpath
    (testpath/".grove").mkpath
    (testpath/".grove/_BRIEF.md").write "# fixture\n"
    leaf = testpath/".grove/01-impl--work-k1.md"
    leaf.write "# work\n"
    agent = testpath/"agent.sh"
    agent.write <<~SH
      #!/bin/sh
      printf launched > launched.txt
      touch "$GROVE_LAUNCH_DIR/teardown"
      exec "$1" end-session grove-continue
    SH
    (testpath/"home/.config/ravel/policy.ts").write <<~TS
      import { definePolicy } from "ravel/sdk";
      import { withProvenance } from "#{assets}/provenance.ts";
      import { groveReviewSelector } from "#{assets}/examples/grove-review.ts";
      const route = request => ({ program: "/bin/sh", args: [#{agent.to_s.to_json},
        #{ravel.to_s.to_json}], provider: "fixture", model: "none", effort: "none" });
      export const policy = withProvenance(definePolicy({ schemaVersion: 2,
        version: "brew-test", ...groveReviewSelector({ routes: { impl: route }, reviews: {} }) }));
    TS
    ENV["HOME"] = (testpath/"home").to_s
    ENV.delete("CODEX_HOME")
    ENV["PATH"] = "#{Formula["ravel"].opt_bin}:/usr/bin:/bin"
    assert_match "loop complete", shell_output("#{bin}/grove 2>&1")
    assert_equal "launched", (testpath/"launched.txt").read
    assert_path_exists leaf
  end
end
