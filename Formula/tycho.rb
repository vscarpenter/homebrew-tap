class Tycho < Formula
  desc "Privacy-first usage analytics for local AI tool transcripts"
  homepage "https://github.com/vscarpenter/tycho-cli"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.12.0/tycho-cli-aarch64-apple-darwin.tar.xz"
      sha256 "25b55c2ca50b66cff146efc0bcea13759d1578a51c73a88fcfb11393a5ee98cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.12.0/tycho-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c334d2d04a7ef6e2bdcb8b9fd4b570999e4ebaa038ac631eb2c6cc3231ced320"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.12.0/tycho-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e207905fa508338dadbc9e7a1061a4d74c2b20ebc1249f942f124c0229d743f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.12.0/tycho-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d797a2777b564710ce0b0c13ade83b4c2a6570bf13c200ada520730a1cbe58bf"
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
