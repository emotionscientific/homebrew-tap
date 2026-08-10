class Verlet < Formula
  desc "Local-first runtime for autonomous AI agents"
  homepage "https://github.com/emotionscientific/verlet-kernel"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.6/verlet-0.3.6-aarch64-apple-darwin.tar.gz"
      sha256 "49a1fae69f3ef32a2d11084ba9df774cf96fdee7bbe343c63078ace0dce10dc8"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.6/verlet-0.3.6-x86_64-apple-darwin.tar.gz"
      sha256 "9ca73b97dcc275a1793c953e7b3a7071f548bfa7c03f6fe3e4f4803f9bbef976"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.6/verlet-0.3.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "102129519fdbe32c6e4babbd62a8566251172f751462ac2e742468de0d44bb96"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.6/verlet-0.3.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bfd8a1bc8c4935ec8aafd727d10b4f261208ba9a1dfdae64832737f9cec3e84e"
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
