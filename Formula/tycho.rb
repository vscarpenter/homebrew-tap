class Tycho < Formula
  desc "Privacy-first usage analytics for local AI tool transcripts"
  homepage "https://github.com/vscarpenter/tycho-cli"
  version "0.10.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.10.2/tycho-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9747113e61d6f89b634f4712ecb364f3c2e819f12aa1b57b039041829b63bcb9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.10.2/tycho-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5ff1dd31503381f55a482a235a50106a083643148d6f31c051e1dfbcf32f8a9f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.10.2/tycho-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "298a6ea7145d63307aaeb5d20d0530cd2a07f191cec3345723898af23df2a5f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.10.2/tycho-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "353dd0ac091944c256621651a479df85258e9a9c77554d655ac8eb429b0d2e1c"
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
