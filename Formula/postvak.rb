class Postvak < Formula
  desc "A fast, simple mail client with automatic mailbox rules"
  homepage "https://postvak.pataar.nl/"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.4.0/postvak-aarch64-apple-darwin.tar.xz"
      sha256 "ebb235d78a4ba0298b55a80d61f020b3acc958ba54d09fb18895fe821376f57c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.4.0/postvak-x86_64-apple-darwin.tar.xz"
      sha256 "b47ba5a0d4d9bbf7cee4234eb00098a3abcc11b9ef3f1a2602b3ec31d372c2e4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.4.0/postvak-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e152cf718cccd03514fc8ba8e6785b88612677919489377954fa6826cd95bbff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.4.0/postvak-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "02c98cb0e6583feebd1b93aa66b9c70a88c4025dbe007858d53bc2bcc01416b0"
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
