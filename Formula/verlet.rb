class Verlet < Formula
  desc "Local-first runtime for autonomous AI agents"
  homepage "https://github.com/emotionscientific/verlet-kernel"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.0/verlet-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "550a37fd0a5275fe3f1c9f98bde35519ed981fe822f8ba2341b8d2a0d01cd310"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.0/verlet-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "f52ae8b54ceaa102688aa303f6f06921f88dcfdccdd693488a9aa62f8c278b17"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.0/verlet-0.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "57b85f90bf7889bb42b91372b13a4ca9cc7d2fb3ef04deab2c5f66a181ce3fa3"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.0/verlet-0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f9dc9671798bcac60370e67051def3063d761c39d6d4982bdba72d2e3027f2a7"
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
