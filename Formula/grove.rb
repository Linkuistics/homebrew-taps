class Grove < Formula
  desc "Hierarchical, self-extending workstream tool for AI agents"
  homepage "https://github.com/Linkuistics/grove"
  version "6.2.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v6.2.0/grove-v6.2.0-aarch64-apple-darwin.tar.xz"
      sha256 "08e90cd09345bdecef93e1eda110a06b9f1ae4fc9e0bf63c3b66755b10fceef8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Linkuistics/grove/releases/download/v6.2.0/grove-v6.2.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1b786b50a7075759c3dc158b03feb315a50882b258b5e4ad6f2304ca1ae13ac9"
    end
    on_intel do
      url "https://github.com/Linkuistics/grove/releases/download/v6.2.0/grove-v6.2.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f1b5999a8da45f9de1b6f4912f90d7bdf5dd9eca8935d94b63c554b98b25f434"
    end
  end

  def install
    bin.install "grove", "grove-llm"
  end

  test do
    assert_match "grove 6.2.0", shell_output("#{bin}/grove --version")
    assert_match "grove-llm 6.2.0", shell_output("#{bin}/grove-llm --version")
  end
end
