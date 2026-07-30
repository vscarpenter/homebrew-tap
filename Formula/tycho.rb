class Tycho < Formula
  desc "Privacy-first usage analytics for local AI tool transcripts"
  homepage "https://github.com/vscarpenter/tycho-cli"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.4.0/tycho-cli-aarch64-apple-darwin.tar.xz"
      sha256 "73063896a90591d3fbe7995d7821635d49bc39c7b8832ed4de878d633c89c7ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.4.0/tycho-cli-x86_64-apple-darwin.tar.xz"
      sha256 "40ffe76295813df62ff44518a1f630b2ced723fb4b0bbb8443b58cb9e44946f4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.4.0/tycho-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "312dbdc94729462df11c95f1309a8cd9686950a24d35278649b17605505f2157"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.4.0/tycho-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a7dd40f753d0419b75e036052abf939d02f337204af7837e86bd0fc77860cc81"
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
