class Verlet < Formula
  desc "Local-first runtime for autonomous AI agents"
  homepage "https://github.com/emotionscientific/verlet-kernel"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.3/verlet-0.3.3-aarch64-apple-darwin.tar.gz"
      sha256 "7543674f55f193821ce9459a23d277626022275853ed02ed1564e9fd46b1c68d"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.3/verlet-0.3.3-x86_64-apple-darwin.tar.gz"
      sha256 "25bafdc79377569cda8854c89887004fad94c612dc9ecd789a2ef10f3410022c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.3/verlet-0.3.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "695f0dfbfe370327531cd4d05f882760f2556eb600b578e154f374828b914c61"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.3/verlet-0.3.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1f88981baa6e40517c3d5626fc1c7f1b97404e0e46b052ca220174fb5bc613e7"
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
