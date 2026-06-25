class Testanyware < Formula
  desc "GUI testing tool for VMs, using tart, designed for LLM-driven testing"
  homepage "https://github.com/Linkuistics/TestAnyware"
  version "2.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Linkuistics/TestAnyware/releases/download/v2.1.0/testanyware-v2.1.0-aarch64-apple-darwin.tar.xz"
      sha256 "4d8e97997e1b0a8091c013899c1786c4259d21e1f16e1093b6a0805355b6fc9f"
    end
  end

  on_linux do
    # macOS uses in-process Apple Vision OCR; Linux routes `screen find-text`
    # through the EasyOCR Python daemon (ADR-0002), so the Linux install builds
    # a venv at <prefix>/libexec/venv. python is the interpreter for that venv.
    depends_on "python@3.12"

    on_arm do
      url "https://github.com/Linkuistics/TestAnyware/releases/download/v2.1.0/testanyware-v2.1.0-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fccee0a91b42e51a4f577179948972f110e03d1301c806a0dcbd58f27d0dd2ba"
    end
    on_intel do
      # BUILD/LINK-VERIFIED ONLY: no native x86_64 guest verifies this at
      # runtime (ADR-0009 no-silent-caps). The OCR/record runtime path here is
      # unproven; aarch64-linux is the harness-green tier.
      url "https://github.com/Linkuistics/TestAnyware/releases/download/v2.1.0/testanyware-v2.1.0-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7a32c4591d8acdcfb97449cdae6f407518b1ffcd39fda94d741ed2a56c29eed1"
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
