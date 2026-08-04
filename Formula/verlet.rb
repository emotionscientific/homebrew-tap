class Verlet < Formula
  desc "Local-first runtime for autonomous AI agents"
  homepage "https://github.com/emotionscientific/verlet-kernel"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.0/verlet-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "070ee66ef1791f226abb734c5a66fc87b5c762b84a94472800725525b1f9539a"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.0/verlet-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "b5d0d5ef35e4b70f0b763fd66d6c2b08102de1f8e8bfa3a18844153d25e6b038"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.0/verlet-0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "be2f56576d5834cba3256099250eefa919defdc6de064dabc4629264ae3a08ec"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.0/verlet-0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c191678d171ff7d001f9f43ce85be33a458a34cd205047fdf744d0d2bdc0be77"
    end
  end

  def install
    bin.install "verlet", "verlet-acp-agent", "verlet-mcp-server"
    man1.install "share/man/man1/verlet.1"
    pkgshare.install "share/verlet/console"
  end

  test do
    assert_match "verlet ", shell_output("#{bin}/verlet --version")
    assert_match "verlet-acp-agent ", shell_output("#{bin}/verlet-acp-agent --version")
    assert_match "Usage", shell_output("#{bin}/verlet console --help")
    assert_path_exists pkgshare/"console/index.html"
  end
end
