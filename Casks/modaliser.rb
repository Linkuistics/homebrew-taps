cask "modaliser" do
  version "1.4.1"
  sha256 "4ddaa02306e66f6186c2a00a1b518e8a9c7de3322a6bcbfa191c430922f375ec"

  url "https://github.com/Linkuistics/Modaliser/releases/download/v#{version}/modaliser-v#{version}-aarch64-apple-darwin.tar.xz"
  name "Modaliser"
  desc "Scheme-scriptable modal keyboard system for macOS"
  homepage "https://github.com/Linkuistics/Modaliser"

  depends_on macos: ">= :sonoma"
  depends_on arch: :arm64

  app "Modaliser.app"

  # The release artifact is ad-hoc signed (no Developer ID), so the downloaded
  # bundle inherits com.apple.quarantine and Gatekeeper refuses to launch it.
  # Stripping the xattr at install time bypasses that on this user's machine.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Modaliser.app"]
  end

  uninstall quit: "dev.antony.Modaliser"

  zap trash: [
    "~/.config/modaliser",
    "~/Library/Logs/Modaliser",
    "~/Library/Preferences/dev.antony.Modaliser.plist",
    "~/Library/Saved Application State/dev.antony.Modaliser.savedState",
  ]
end
