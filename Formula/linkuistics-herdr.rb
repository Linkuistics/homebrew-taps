class LinkuisticsHerdr < Formula
  desc "Herdr, built from AntonyBlakey/herdr@ui-layout (adds ui.layout)"
  homepage "https://github.com/AntonyBlakey/herdr"
  url "https://github.com/AntonyBlakey/herdr.git",
      branch:   "ui-layout",
      revision: "552c16ec9480594094213ba5017ea299f8e5bb02"
  version "0.7.4-uilayout.552c16e"
  license "AGPL-3.0-or-later"

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build

  def install
    ENV["ZIG"] = formula_opt_bin("zig@0.15")/"zig"
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      This is Antony's personal ui.layout fork of herdr (docs/adr/0016 in
      Modaliser), not upstream ogulcancelik/herdr. It exists so the daily
      herdr can be `brew`-installed/upgraded instead of manually built and
      symlinked. Remove this formula and reinstall stock `herdr` once the
      upstream PR merges.
    EOS
  end

  test do
    assert_match "herdr #{version.to_s.split("-").first}", shell_output("#{bin}/herdr --version")
  end
end
