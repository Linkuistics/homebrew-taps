class LinkuisticsHerdr < Formula
  desc "Herdr, built from AntonyBlakey/herdr@linkuistics-fork with carried patches"
  homepage "https://github.com/AntonyBlakey/herdr"
  url "https://github.com/AntonyBlakey/herdr.git",
      branch:   "linkuistics-fork",
      revision: "58373aed87cbf8e97d8017a1d9c89a7f0941acab"
  version "0.9.5-linkuistics.2"
  license "Apache-2.0"

  depends_on "rust" => :build
  depends_on "zig@0.16" => :build

  # Keep these resources aligned with the vendored Zig package manifests,
  # including translate-c's aro dependency. Homebrew's curl download avoids
  # failures in Zig's HTTP client; Zig still checks each package content hash.
  resource "translate-c" do
    url "https://codeberg.org/vancluever/translate-c/archive/4e879eb8aba615de112eabd1231ea6e01920cead.tar.gz"
    sha256 "8fb0f5c6a3e8b3bf0e35225d3abc1230bcf6f1fdf162467f1f747ec2fa5eda07"
  end

  resource "uucode" do
    url "https://deps.files.ghostty.org/uucode-2826a37a4562284fdacd8fa029d49509cc9bffcd.tar.gz"
    sha256 "7e76fc7fab1e7ac728c52b35bbb3e5b8c639841abfc7fe1a4bcb13050594bc9e"
  end

  resource "ghostty-themes" do
    url "https://deps.files.ghostty.org/ghostty-themes-release-20260831-151010-752a9c0.tgz"
    sha256 "83653eb837baeb5bfc7d50c91b7d44772796e08c1c243134e11c5edf6c8d15c5"
  end

  resource "highway" do
    url "https://deps.files.ghostty.org/highway-66486a10623fa0d72fe91260f96c892e41aceb06.tar.gz"
    sha256 "87d4f8893ef4e08f224973608ffebf94268a81380ba79c12e8841968c80aa212"
  end

  resource "zlib" do
    url "https://deps.files.ghostty.org/zlib-1220fed0c74e1019b3ee29edae2051788b080cd96e90d56836eea857b0b966742efb.tar.gz"
    sha256 "17e88863f3600672ab49182f217281b6fc4d3c762bde361935e436a95214d05c"
  end

  resource "wuffs" do
    url "https://deps.files.ghostty.org/wuffs-7411f488fe2e2c205c3d3b3d28638b7356522930.tar.gz"
    sha256 "17877d346f7988651d6c62e45b2e3b05c86809a6442c5e34612374b2a9719a1c"
  end

  resource "pixels" do
    url "https://deps.files.ghostty.org/pixels-12207ff340169c7d40c570b4b6a97db614fe47e0d83b5801a932dcd44917424c8806.tar.gz"
    sha256 "55e83b16d091082502bf149bf457f31f42092c5982650e3ffbae7b48871bf11a"
  end

  resource "aro" do
    url "https://github.com/vancluever/arocc/archive/f97cdfc3779aec4b242299e2fc9a1c828c3547c6.tar.gz"
    sha256 "42c8cab9135b12518e6af7dc5e461f055c78b863adca8ed7774f2fb7fe9a7784"
  end

  def install
    ENV["ZIG"] = formula_opt_bin("zig@0.16")/"zig"
    cd "vendor/libghostty-vt" do
      resources.each do |dependency|
        system ENV["ZIG"], "fetch", dependency.cached_download
      end
    end
    # herdr builds `--version` as {CARGO_PKG_VERSION}-{channel}.{build_id} from
    # these compile-time vars (src/build_info.rs). Without them `channel` falls
    # back to "stable" and the binary reports the upstream version, indistinguishable
    # from an upstream build. Derived from `version` so the two cannot drift.
    ENV["HERDR_BUILD_CHANNEL"] = "linkuistics"
    ENV["HERDR_BUILD_ID"] = version.to_s.split("-linkuistics.").last
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      This is Antony's personal fork of herdr, not upstream ogulcancelik/herdr.
      It exists so the daily herdr can be `brew`-installed/upgraded instead of
      manually built and symlinked. It carries three patches on top of upstream
      master: the fork is ours to maintain, not a staging area for
      contributions, so none is offered upstream and no issue is filed there
      either.

        * ui.layout    — sidebar/tab-bar geometry API + CLI verb (two `feat:`
                         commits). Upstream has no ui.layout in any form.
                         Carried for Modaliser, which paints chips over herdr's
                         own chrome and needs the drawn cell-rects the API does
                         not otherwise expose. Ends only if upstream ships an
                         equivalent geometry API.
        * hook authority — `fix:` separating session identity from lifecycle
                         state, so a reporter that sends no session_ref (grove)
                         is accepted without clearing the harness integration's
                         session-resume record. Offering it upstream was
                         considered and rejected; the reasoning, and what would
                         reopen it, are in docs/adr/herdr-optional-ui.md in
                         Linkuistics/grove. Ends only if upstream separates
                         session identity from lifecycle state on its own.
        * pane appearance — `[ui] active_pane_border_fg/_bg` and the `inactive_`
                         pair recolour split-pane borders without restyling the
                         whole UI through the shared accent. `inactive_pane_haze`
                         blends unfocused panes toward a colour so the focused
                         one stays obvious while typing. Both default to off and
                         reproduce upstream's appearance exactly. Ends only if
                         upstream makes pane appearance configurable to the same
                         degree.

      Versioning: upstream's version plus `-linkuistics.<seq>`, where <seq>
      increments on every ship and resets when upstream's version bumps. Bump
      <seq> whenever the pinned revision changes, so `brew upgrade` sees it.

      Rebasing the carry onto each new upstream release is therefore recurring,
      indefinite work; the branch layout, rebase cycle and build overrides it
      needs are in docs/specs/herdr-fork-maintenance.md in Linkuistics/grove.
    EOS
  end

  test do
    assert_match "herdr #{version}", shell_output("#{bin}/herdr --version")
  end
end
