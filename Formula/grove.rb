class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v1.0.0/grove-v1.0.0-aarch64-apple-darwin.tar.xz"
      sha256 "a475c5ed1f244d7436f848f76704b911f482bec22f2eee03386bc12d49a7f232"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v1.0.0/grove-v1.0.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "da64111d6ddda70c7a5e8d90aa91e34ac0abe8720cea0f996f7fda61cede64b3"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v1.0.0/grove-v1.0.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4b6403b53838053e9daae39f63413290296428e03bb3b86c5fad47f6ac6fc91f"
    end
  end

  def install
    bin.install "grove"
  end

  test do
    assert_match "grove cli 1.0.0", shell_output("#{bin}/grove version")
  end
end
