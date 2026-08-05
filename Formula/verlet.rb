class Verlet < Formula
  desc "Local-first runtime for autonomous AI agents"
  homepage "https://github.com/emotionscientific/verlet-kernel"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.1/verlet-0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "7b3f6d293e4382a89e6e770fa2962c3f26b9062cae2aabce7a76bcddb71f3210"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.1/verlet-0.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "c732f1f75355a5a1143fc01ccb5ee5a8d7c13aff529e5c30c72e9a145c276051"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.1/verlet-0.3.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3a80846483e4deebd1a0a36b4ae31265fe50bf18e5c9ae8627b24f5de42f34d7"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.1/verlet-0.3.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7d407aa07af47ec45045453feffe01f1fdd560115fcdbe53a385d161a2f589e9"
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
