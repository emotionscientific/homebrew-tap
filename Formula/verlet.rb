class Verlet < Formula
  desc "Local-first runtime for autonomous AI agents"
  homepage "https://github.com/emotionscientific/verlet-kernel"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.4/verlet-0.3.4-aarch64-apple-darwin.tar.gz"
      sha256 "6f7139b3da7641fef766d171a21fc892d5f924ce1efadfa16680d2e551e7f22f"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.4/verlet-0.3.4-x86_64-apple-darwin.tar.gz"
      sha256 "3a153067742e2621fb4f38a886d78e5d083eb6b693c985d3ae4fbd2526ebe464"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.4/verlet-0.3.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "03f04a12b32d2a81756e89bca6485b9abd432c1104630591235dad45ffce886a"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.4/verlet-0.3.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6baa3780ee89b8c4b3da46ecb485a9b119203b2bfe667012d99bdcafd39d63da"
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
