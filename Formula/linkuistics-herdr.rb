class LinkuisticsHerdr < Formula
  desc "Herdr, built from AntonyBlakey/herdr@ui-layout (ui.layout + hook-authority fix)"
  homepage "https://github.com/AntonyBlakey/herdr"
  url "https://github.com/AntonyBlakey/herdr.git",
      branch:   "ui-layout",
      revision: "d17e0f4201febeebca7f70c451c94133165a970b"
  version "0.7.5-linkuistics.1"
  license "Apache-2.0"

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build

  def install
    ENV["ZIG"] = formula_opt_bin("zig@0.15")/"zig"
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      This is Antony's personal fork of herdr, not upstream ogulcancelik/herdr.
      It exists so the daily herdr can be `brew`-installed/upgraded instead of
      manually built and symlinked. It carries two patches on top of upstream
      master, and both are permanent carries: the fork is ours to maintain, not
      a staging area for contributions, so neither patch is offered upstream and
      no issue is filed there either.

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

      Versioning: upstream's version plus `-linkuistics.<seq>`, where <seq>
      increments on every ship and resets when upstream's version bumps. Bump
      <seq> whenever the pinned revision changes, so `brew upgrade` sees it.

      Rebasing the carry onto each new upstream release is therefore recurring,
      indefinite work; the branch layout, rebase cycle and build overrides it
      needs are in docs/specs/herdr-fork-maintenance.md in Linkuistics/grove.
    EOS
  end

  test do
    assert_match "herdr #{version.to_s.split("-").first}", shell_output("#{bin}/herdr --version")
  end
end
