class Verlet < Formula
  desc "Local-first runtime for autonomous AI agents"
  homepage "https://github.com/emotionscientific/verlet-kernel"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.7/verlet-0.3.7-aarch64-apple-darwin.tar.gz"
      sha256 "184b9d42ef3aed693f312ea4fa5f156dc894b7828e70bf5e97ed96d1b0a35ede"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.7/verlet-0.3.7-x86_64-apple-darwin.tar.gz"
      sha256 "91034c3adf2a167ea100b0385a882576f32cdc551ea07b3b75c5e3e7b8d3edcb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.7/verlet-0.3.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c4b5452f9c930abca8a3fd59e28814ffcfae8a44e70b64548ab80ab5f3e601e7"
    else
      url "https://github.com/emotionscientific/verlet-kernel/releases/download/v0.3.7/verlet-0.3.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "11c616fa3c36adadd4687b290e6b2f4437c0eba67c2cd9e33ceccd5186158878"
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
