class Cooldis < Formula
  desc "Local-first runtime for autonomous AI agents"
  homepage "https://github.com/emotionscientific/cooldis-kernel"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.1.0/cooldis-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "5e88aeeb2ccce5a2df48d46c936a54a6b318070977480fcca734c7c7bb7149d6"
    else
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.1.0/cooldis-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "9d2e7d96f27537953274966caf17c3f29058a456c536dfe2a4faab2ecccd8be4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.1.0/cooldis-0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b25b5056ab4a37b6438adb27e150c872a0c90fdf0d02217b67fdad67380df8be"
    else
      url "https://github.com/emotionscientific/cooldis-kernel/releases/download/v0.1.0/cooldis-0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8dcf70f610c8c7ffd2c992fc7eff898a3813d8c2b9d5ea0b867f54f4d0b80fa7"
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
