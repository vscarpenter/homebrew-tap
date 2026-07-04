class Tycho < Formula
  desc "Privacy-first usage analytics for Claude Code's local JSONL transcripts"
  homepage "https://github.com/vscarpenter/tycho-cli"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.2.0/tycho-cli-aarch64-apple-darwin.tar.xz"
      sha256 "463596c0b30628c157cfac1f50fd4f2a7cadfd90bce032a2f0f5347e356b1a4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.2.0/tycho-cli-x86_64-apple-darwin.tar.xz"
      sha256 "aa1534499829a6861a7c5994e9f1020636ff90f8087fe47ab1efb6e1566a4de6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.2.0/tycho-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f96c62076ac1fd2d60b77142a30f10ac82f20585c7d62ca963d27d19f5666636"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.2.0/tycho-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "74acbf4df1b89b05d7b31c57ad4279e2fc3e3dbf6474a420e93a7359bac5b566"
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
