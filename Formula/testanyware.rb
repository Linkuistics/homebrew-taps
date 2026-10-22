class Testanyware < Formula
  desc "GUI testing tool for VMs, using tart, designed for LLM-driven testing"
  homepage "https://github.com/Linkuistics/TestAnyware"
  version "2.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/TestAnyware/releases/download/v2.4.0/testanyware-v2.4.0-aarch64-apple-darwin.tar.xz"
      sha256 "0b72e8453affde6353bbd5f3a47142f44dec156adb5d14f46685246b7498a1da"
    end
  end

  on_linux do
    # macOS uses in-process Apple Vision OCR; Linux routes `screen find-text`
    # through the EasyOCR Python daemon (ADR-0002), so the Linux install builds
    # a venv at <prefix>/libexec/venv. python is the interpreter for that venv.
    depends_on "python@3.12"

    on_arm do
      url "https://github.com/Linkuistics/TestAnyware/releases/download/v2.4.0/testanyware-v2.4.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "28a4e07c17339dbc2bb25a775b3e32fa9ec7db25b344c171e49826e116a263be"
    end
    on_intel do
      # BUILD/LINK-VERIFIED ONLY: no native x86_64 guest verifies this at
      # runtime (ADR-0009 no-silent-caps). The OCR/record runtime path here is
      # unproven; aarch64-linux is the harness-green tier.
      url "https://github.com/Linkuistics/TestAnyware/releases/download/v2.4.0/testanyware-v2.4.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d6b417df7cc2782a289dc748b2e0da6548b3f7f022948e9dbd078f52682a6de1"
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
