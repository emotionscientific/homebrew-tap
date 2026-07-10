class Cooldis < Formula
  desc "Local-first runtime for autonomous AI agents"
  homepage "https://github.com/emotionscientific/cooldis-kernel"
  version "0.1.0-rc.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.1.0-rc.5/cooldis-0.1.0-rc.5-aarch64-apple-darwin.tar.gz"
      sha256 "b794fb034851fcd2a6f73c94a2410c5f2f53582970dbd755353150bfd1284a2c"
    else
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.1.0-rc.5/cooldis-0.1.0-rc.5-x86_64-apple-darwin.tar.gz"
      sha256 "3db9937f9c8b76e9bf1322e8b32893265303b19c3e4f849d55c2112032b58d21"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.1.0-rc.5/cooldis-0.1.0-rc.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b21cd8f1755674f1393e0d8df1b7687b9f4b11423431c8caa17ed74f436efdc7"
    else
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.1.0-rc.5/cooldis-0.1.0-rc.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a9ab2686ae8c68586f1ac838977e305fc39eb54536d3a829c7d1b4bfadbc8e02"
    end
  end

  def install
    bin.install "cooldis", "cooldis-acp-agent", "cooldis-mcp-server"
    pkgshare.install "share/cooldis/console"
  end

  test do
    assert_match "cooldis ", shell_output("#{bin}/cooldis --version")
    assert_match "cooldis-acp-agent ", shell_output("#{bin}/cooldis-acp-agent --version")
    assert_match "Usage", shell_output("#{bin}/cooldis-mcp-server --help")
    assert_match "Usage", shell_output("#{bin}/cooldis console --help")
    assert_path_exists pkgshare/"console/index.html"
  end
end
