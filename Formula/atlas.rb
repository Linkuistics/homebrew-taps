class Atlas < Formula
  desc "Design recovery and architectural pattern extraction for large codebases"
  homepage "https://github.com/linkuistics/Atlas"
  version "1.2.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.2.1/atlas-v1.2.1-aarch64-apple-darwin.tar.xz"
      sha256 "3b1930f2e2c853b07fa8a405ffb582e36c94bf052876beb344b4ae8ce17a0bc1"
    end
    on_intel do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.2.1/atlas-v1.2.1-x86_64-apple-darwin.tar.xz"
      sha256 "c28f361832c2db9ce34c014d80f5a343dc2e1734820c40ed67c2db6d902f7b20"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.2.1/atlas-v1.2.1-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f7d4bc076bb789326c7f5c0ca712a3fd4208532e30525a1ec1f169c3ad8844e8"
    end
    on_intel do
      url "https://github.com/linkuistics/Atlas/releases/download/v1.2.1/atlas-v1.2.1-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f43a33cc0554a2a6b11bd27509927970c27167e9e924f4e6f2a10045c1b8aa44"
    end
  end

  def install
    bin.install "atlas"
  end

  test do
    assert_match "atlas", shell_output("#{bin}/atlas --version")
  end
end
