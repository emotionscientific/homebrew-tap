class Verlet < Formula
  desc "Local-first runtime for autonomous AI agents"
  homepage "https://github.com/emotionscientific/verlet-kernel"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.5/verlet-0.3.5-aarch64-apple-darwin.tar.gz"
      sha256 "6bf286f125c39be3e68d1b984791e05ddc21d9e06ff35fe0315725202be86494"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.5/verlet-0.3.5-x86_64-apple-darwin.tar.gz"
      sha256 "8568e818ba77da15ffc52c0128abc05ae837a3af530b2d4ada1676f65bb4b1a4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.5/verlet-0.3.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "da2b76ece2e3bf40a407879a95c42daf3d42c52077ffd29d410bcbbf0eaf4e52"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.5/verlet-0.3.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a6bbfe91b68e12ed24120c151f5641a11966280dcb7bf653476b0d5b46da9146"
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
