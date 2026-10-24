class Postvak < Formula
  desc "A fast, simple mail client with automatic mailbox rules"
  homepage "https://postvak.pataar.nl/"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.6.0/postvak-aarch64-apple-darwin.tar.xz"
      sha256 "28b6c926a4de9ea8e015165486bbe9342cedf5d46c24581fb4ff8ffe0b97fd89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.6.0/postvak-x86_64-apple-darwin.tar.xz"
      sha256 "66afca2d35e6dbef3b6c04144bff42b9c67d1e74c0661665f639d13b093b0d11"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.6.0/postvak-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "92ab3224709304d841c814b3ec0628eaa90000611ad82efd3bf139e3e888926e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.6.0/postvak-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0f7ea908a52db3a31a8caf2242b3024c0e5fb094de402ff3b2a391f49a86cba2"
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
