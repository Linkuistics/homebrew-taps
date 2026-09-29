cask "koine" do
  version "0.1.0"
  sha256 "26b091d54af3095d4360c95efddb87eb8fdec2c43bd76af7f3cb78d4651603fb"

  url "https://github.com/Linkuistics/Koine/releases/download/v#{version}/Koine-#{version}-aarch64-apple-darwin.zip"
  name "Koine"
  desc "Discover, query and command the desktop through a GraphQL API"
  homepage "https://github.com/Linkuistics/Koine"

  # Koine's support matrix is macOS 26 on Apple Silicon. A bare symbol takes
  # the ">=" comparator: Homebrew/Library/Homebrew/cask/dsl/depends_on.rb
  # (MacOSRequirement.parse(args, comparator: ">=")), read in Homebrew 7.0.7.
  depends_on arch: :arm64
  depends_on macos: :tahoe

  # The bundle is Developer ID signed, notarized and stapled, so Gatekeeper
  # accepts the quarantined download as it stands. There is deliberately no
  # postflight stripping com.apple.quarantine: one would hide a notarization
  # failure instead of revealing it.
  app "Koine.app"

  uninstall quit: "dev.antony.Koine"

  # Koine registers its login item through SMAppService.mainApp, a Background
  # Task Management entry tied to the bundle, not a System Events login item, so
  # `uninstall login_item:` (an AppleScript deletion) does not apply to it.
  zap trash: [
    "~/Library/Application Support/Koine",
    "~/Library/Preferences/dev.antony.Koine.plist",
    "~/Library/Saved Application State/dev.antony.Koine.savedState",
  ]
end
