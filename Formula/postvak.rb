class Postvak < Formula
  desc "A fast, simple mail client with automatic mailbox rules"
  homepage "https://postvak.pataar.nl/"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.8.0/postvak-aarch64-apple-darwin.tar.xz"
      sha256 "d35b021ddb3709b6e9392d6672eb4230fbb9dcca667e3e9b46703fb113283017"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.8.0/postvak-x86_64-apple-darwin.tar.xz"
      sha256 "754690ba9714d6c3fd46fc0a7ee87b56cbba7559695e8a1b04f350dfe5155ffd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.8.0/postvak-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c42ae698df99fb8d078ba79b3ce5cce6864e7a824ad75d20820cc84d78fdff16"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.8.0/postvak-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "444390979f8c841efb0d96c4ebb4acc11ac206af46f3e4bcdb254ee96be90e92"
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
