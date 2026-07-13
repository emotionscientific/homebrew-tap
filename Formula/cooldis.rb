class Cooldis < Formula
  desc "Local-first runtime for autonomous AI agents"
  homepage "https://github.com/emotionscientific/cooldis-kernel"
  version "0.1.0-rc.7"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.1.0-rc.7/cooldis-0.1.0-rc.7-aarch64-apple-darwin.tar.gz"
      sha256 "55dea77a5fd0f52b0c86c31b7a16154c7a6234dba95fcc54840f9a696d67c1a1"
    else
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.1.0-rc.7/cooldis-0.1.0-rc.7-x86_64-apple-darwin.tar.gz"
      sha256 "b2100c069cf2d0e531a7b6cc37312f1703fc91b2ee2b8ff706dea341cbba4c0b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.1.0-rc.7/cooldis-0.1.0-rc.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bcbe5e069ca1bfb6daacf5551ab8769e771f64a10ff07b972a81d6337c8385ef"
    else
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.1.0-rc.7/cooldis-0.1.0-rc.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "979f18d4bce38f29c60b77e6c6c6cf82014622a57321af5f75a836103ed9d5b2"
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
