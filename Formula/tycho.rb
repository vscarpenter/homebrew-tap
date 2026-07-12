class Tycho < Formula
  desc "Privacy-first usage analytics for local AI tool transcripts"
  homepage "https://github.com/vscarpenter/tycho-cli"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.3.1/tycho-cli-aarch64-apple-darwin.tar.xz"
      sha256 "dfab95a075234f3d4f21fed0a0ed573ef1b115891f098565c64c2c7b87f49776"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.3.1/tycho-cli-x86_64-apple-darwin.tar.xz"
      sha256 "760daeea0c043dc66f7b741a55cd51cc016273893b62ffb30f1c721a4ce1598c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.3.1/tycho-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bd7f8f0499b155cd91cefc43703e38d31cb9eb6856d556d7457809c7d08d8c96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.3.1/tycho-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab35a505f755d0464df35f13670d79a6e63638b854ac12d0998a1b6608933f22"
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
