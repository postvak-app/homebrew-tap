class Postvak < Formula
  desc "A fast, simple mail client with automatic mailbox rules"
  homepage "https://postvak.pataar.nl/"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.3.1/postvak-aarch64-apple-darwin.tar.xz"
      sha256 "4b479567a8213777050b5e6568ba729b204bb73176c4698cd7e726ae3fa97795"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.3.1/postvak-x86_64-apple-darwin.tar.xz"
      sha256 "c5321f2489db5e7197c8a08c7d730338105abe9455fc39a9f1f5bd43bed0f3dd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.3.1/postvak-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ae4a268f072cd085cf9f5c5e661c6cd9b77a4b4a9089bccdb6f84b21cb18c530"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.3.1/postvak-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "73b8faef2c82781743888e74fc1430f35258c75d0b6769d59699919aa0ac7b89"
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
