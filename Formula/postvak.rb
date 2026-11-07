class Postvak < Formula
  desc "Your inbox, organized by rules you write"
  homepage "https://postvak.pataar.nl/"
  version "0.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.16.0/postvak-aarch64-apple-darwin.tar.xz"
      sha256 "e785425f27b7447f358e9171aadbf028734d1ed4e36dec537dfa9f57d9f7c425"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.16.0/postvak-x86_64-apple-darwin.tar.xz"
      sha256 "a3cbcbfb74d256d983e4e800c1f305d892f478d80fc3eef28fcf8ee1c69c9f61"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.16.0/postvak-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "220ff35efa537ae149a5cfe26067191f24e20af40c44f72f7d8b39ad02be8816"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.16.0/postvak-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e9c8ffb759b4e98e0c389cd07ad0640d204a43e1006c0ca7f2638a1d9145f355"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
      bin.install "postvak"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "postvak"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "postvak"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "postvak"
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
