class Tycho < Formula
  desc "Privacy-first usage analytics for local AI tool transcripts"
  homepage "https://github.com/vscarpenter/tycho-cli"
  version "0.10.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.10.1/tycho-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9664ae4aa19391fa2a2a4d3bc19472be0564e1f16c61b646ab4e7ab55cde509c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.10.1/tycho-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d11a030eb9d8c2dc1d7d80f7c786f07e59ac497727965aa7f0b44878c65f71df"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.10.1/tycho-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ec32aaa350b32442ad390da13a70d01df243ea0083f2aa153e23181276ee90ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.10.1/tycho-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0224548c37f3999bb29c2d0ac1a1b26e9f517f74ff375c7845ca3035339cc8ae"
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
