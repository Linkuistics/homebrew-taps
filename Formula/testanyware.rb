class Testanyware < Formula
  desc "GUI testing tool for VMs, using tart, designed for LLM-driven testing"
  homepage "https://github.com/Linkuistics/TestAnyware"
  version "2.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/TestAnyware/releases/download/v2.7.0/testanyware-v2.7.0-aarch64-apple-darwin.tar.xz"
      sha256 "9793e38f08ad43c01f178d3a6a3f6f014736f05afb73bfb7a79bbafa412db098"
    end
  end

  on_linux do
    # macOS uses in-process Apple Vision OCR; Linux routes `screen find-text`
    # through the EasyOCR Python daemon (ADR-0002), so the Linux install builds
    # a venv at <prefix>/libexec/venv. python is the interpreter for that venv.
    depends_on "python@3.12"

    on_arm do
      url "https://github.com/Linkuistics/TestAnyware/releases/download/v2.7.0/testanyware-v2.7.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "523123f03f3dc4e95c55ee25ad4bd07d9cdb8916fdfcc550d18f8c1fe174d416"
    end
    on_intel do
      # BUILD/LINK-VERIFIED ONLY: no native x86_64 guest verifies this at
      # runtime (ADR-0009 no-silent-caps). The OCR/record runtime path here is
      # unproven; aarch64-linux is the harness-green tier.
      url "https://github.com/Linkuistics/TestAnyware/releases/download/v2.7.0/testanyware-v2.7.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f04704f07f296ad1043c0c5b50943afff5c0f151a8d33ddbc8da59c4543dea09"
    end

    # EasyOCR backs `screen find-text` on Linux. Pinned by sha256; pip resolves
    # its deep transitive tree (torch, opencv, …) for the host at install time.
    # Wheel-only on PyPI — installed from the cached download (no stage/unzip).
    resource "easyocr" do
      url "https://files.pythonhosted.org/packages/bb/84/4a2cab0e6adde6a85e7ba543862e5fc0250c51f3ac721a078a55cdcff250/easyocr-1.7.2-py3-none-any.whl"
      sha256 "5be12f9b0e595d443c9c3d10b0542074b50f0ec2d98b141a109cd961fd1c177c"
    end
  end

  def install
    bin.install "bin/testanyware"
    pkgshare.install Dir["share/testanyware/*"]

    on_linux do
      # The cross binary hard-NEEDs the BtbN ffmpeg-8 sonames (which match no
      # distro's ffmpeg) and is linked with RUNPATH=$ORIGIN/../lib, so placing
      # them in the keg's lib/ makes it self-locating — no LD_LIBRARY_PATH.
      lib.install Dir["lib/*.so*"]

      # Build the EasyOCR daemon venv at the path resolve_interpreter() finds
      # relative to <prefix>/bin/testanyware: <prefix>/libexec/venv/bin/python.
      venv = libexec/"venv"
      system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", venv
      system venv/"bin/pip", "install", "--quiet", "--upgrade", "pip"
      # Pinned easyocr (+ its resolved deps), then the ocr_analyzer daemon
      # module itself (deps already satisfied, so --no-deps). The bridge spawns
      # `python -m ocr_analyzer --daemon` with no PYTHONPATH, so the module must
      # live in the venv's own site-packages — hence pip-installed, not copied.
      system venv/"bin/pip", "install", "--quiet", resource("easyocr").cached_download
      system venv/"bin/pip", "install", "--quiet", "--no-deps", pkgshare/"ocr"
    end
  end

  test do
    assert_match "testanyware", shell_output("#{bin}/testanyware --help")
  end
end
