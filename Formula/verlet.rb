class Verlet < Formula
  desc "Local-first runtime for autonomous AI agents"
  homepage "https://github.com/emotionscientific/verlet-kernel"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.2/verlet-0.3.2-aarch64-apple-darwin.tar.gz"
      sha256 "2d990b39563ccfca25037ceba2052b1dcad0685b591e1bdde6dfd9acaa11e0ef"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.2/verlet-0.3.2-x86_64-apple-darwin.tar.gz"
      sha256 "3f194bc520cf082708e66dddb22bebf82584217d81ec096680fcff849c4a6940"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.2/verlet-0.3.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "92175cd040176c71241a9cc512475e1fcb7a395077b5b613f934cb0c202f0875"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.2/verlet-0.3.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d8a5bd8abc09d1bbbf0418a27eb74e4965112d282ca49e045d69c86dbf0cd2a6"
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
