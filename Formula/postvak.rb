class Postvak < Formula
  desc "Your inbox, organized by rules you write"
  homepage "https://postvak.pataar.nl/"
  version "0.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.14.0/postvak-aarch64-apple-darwin.tar.xz"
      sha256 "1273f63f99d59974e90ab0cacfd40419ae5c6317cf47fa122a112a49f71b7dc8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.14.0/postvak-x86_64-apple-darwin.tar.xz"
      sha256 "c62c67923c990ab85bfc35d4ee87f67ae9385078600aceca2be9d66b5ede1516"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.14.0/postvak-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "58de876a3311ab069acf5fb826575e0d693124a0d4a806c73d371c2584a0599e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.14.0/postvak-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e2e72dd18b3503fdc9079ad36c5e06cc8fea361e799733e25c2548aab33d18eb"
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
