class Tycho < Formula
  desc "Privacy-first usage analytics for local AI tool transcripts"
  homepage "https://github.com/vscarpenter/tycho-cli"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.8.0/tycho-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9e2348ee8c7c00edb438691a8b9d9b13d7478d3b3ce972db96fda65e5fe7b8fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.8.0/tycho-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f1641f065a5130dd32bd03f5720b7aaa7ef93602f92f3db3108543e34b544827"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.8.0/tycho-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "82464e6a58248e4849570d7d30fb94944d1e71c9a0cc7e5d5301590bbeb9adfa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vscarpenter/tycho-cli/releases/download/v0.8.0/tycho-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c5d9ec0ee5fa24c8386a04e9744579820790c60982041bca68dbd9524bde5736"
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
