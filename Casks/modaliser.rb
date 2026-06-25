cask "modaliser" do
  version "2.5.0"
  sha256 "f43a7cbadcb7c3a452f25d92d1d6e38ab3cc24d6eeda01876c6bdb70243dc3fb"

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
