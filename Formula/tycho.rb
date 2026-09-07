class Tycho < Formula
  desc "Privacy-first usage analytics for local AI tool transcripts"
  homepage "https://github.com/vscarpenter/tycho-cli"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.9.0/tycho-cli-aarch64-apple-darwin.tar.xz"
      sha256 "42735877664a2681e7e13a5cc614e3295a2bee3551dc8609856f2f6d5b7831ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.9.0/tycho-cli-x86_64-apple-darwin.tar.xz"
      sha256 "91d091f3289836797df594c6977f4f79f33a72eee1f958c3188b50c21de90656"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.9.0/tycho-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0700084e2fa4ca54ba7d1d48883f0d4ee6e145518c9c9e7c26ab67dfebee84ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.9.0/tycho-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6b4e6d9aa22d92fd95277a5d4d9831fc92cc76470cbcae709fc806ac3d4bfaec"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "tycho"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tycho"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "tycho"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tycho"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
