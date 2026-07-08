class Tycho < Formula
  desc "Privacy-first usage analytics for local AI tool transcripts"
  homepage "https://github.com/vscarpenter/tycho-cli"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.3.0/tycho-cli-aarch64-apple-darwin.tar.xz"
      sha256 "38042bdefc5be79aada115ea361e06a09c3da3829dff8e3dc375b41aee4329df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.3.0/tycho-cli-x86_64-apple-darwin.tar.xz"
      sha256 "15d406278759a11be693e21ca56945c5b0d0e8f8d7d43f68e3d1d9d34dacab89"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.3.0/tycho-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "464b45e23963b3cb2aaccd166aa4d39d945e2c1445cee342ca93757744448398"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.3.0/tycho-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f5b2d824d8a54af096d67477e1f12bb884a2361c151ab1a2eb49bf6e69107436"
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
