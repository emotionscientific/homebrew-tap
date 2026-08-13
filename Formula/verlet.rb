class Verlet < Formula
  desc "Local-first runtime for autonomous AI agents"
  homepage "https://github.com/emotionscientific/verlet-kernel"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.4.0/verlet-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "0f96a2635ff6ced47f59d3b82fa0211b4932d8c76b0df3654cbfd27570f83448"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.4.0/verlet-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "19894d90ef2933f8a0e234f8ac5c85b3edd16d12f521859db34a140251ad3b95"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.4.0/verlet-0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "aac651b798628d112e8d69be640b7fc7eb33393af125e68799e159fec1957538"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.4.0/verlet-0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9462949dfc47c726476a357f6f639b221f38b254acb3fce97e9831a0a3d2688a"
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
