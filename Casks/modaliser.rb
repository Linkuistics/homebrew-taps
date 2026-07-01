cask "modaliser" do
  version "2.6.0"
  sha256 "9915c9d5b95a8d7ab35d2c54ec80a37617ef311f8e7525a234439d3339828a2c"

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
