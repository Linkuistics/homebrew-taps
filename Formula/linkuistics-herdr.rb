class LinkuisticsHerdr < Formula
  desc "Herdr, built from AntonyBlakey/herdr@ui-layout (adds ui.layout)"
  homepage "https://github.com/AntonyBlakey/herdr"
  url "https://github.com/AntonyBlakey/herdr.git",
      branch:   "ui-layout",
      revision: "b9570aa70d99525729e424db7862336ff6912293"
  version "0.7.5-uilayout.b9570aa"
  license "Apache-2.0"

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
