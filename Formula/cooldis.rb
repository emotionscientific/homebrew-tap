class Cooldis < Formula
  desc "Local-first runtime for autonomous AI agents"
  homepage "https://github.com/emotionscientific/cooldis-kernel"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.2.0/cooldis-0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "89c83e6966d383817a2413070d03408e1297397e3aaeb2c221f04aee9b88b6ec"
    else
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.2.0/cooldis-0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "4b92f3dd566958579210997c6266c97a20b90856df1c1dca273b7620479702e0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.2.0/cooldis-0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c790fb14d0e0ec3729824f9e75da782648ee4709701f7f30e377e45a06c1115d"
    else
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.2.0/cooldis-0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "47ffbd475e3a923110faa4c0d23418f284995ef295ba651b8e6f08d455637274"
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
