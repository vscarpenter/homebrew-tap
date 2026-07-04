class Tycho < Formula
  desc "Privacy-first usage analytics for Claude Code's local JSONL transcripts"
  homepage "https://github.com/vscarpenter/tycho-cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.1.0/tycho-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b92b285606a7b15695894e2140e9219ff3d8e62596e387f215989179d143238b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.1.0/tycho-cli-x86_64-apple-darwin.tar.xz"
      sha256 "73a9091d24ff9edc51a90dacfeb12db36638b33939df87c1a6cf11b6010e5678"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.1.0/tycho-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "142fd10e254bb2dd71941edbe9570e7c2cfd1d1ece4396e1061b28f2352b00b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.1.0/tycho-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1fd91ec6f0d32bfac30fd5e2d65d8df7eb3133ee2890fb8b09979d0255ca1d97"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "tycho" if OS.mac? && Hardware::CPU.arm?
    bin.install "tycho" if OS.mac? && Hardware::CPU.intel?
    bin.install "tycho" if OS.linux? && Hardware::CPU.arm?
    bin.install "tycho" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
