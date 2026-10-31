class Postvak < Formula
  desc "Your inbox, organized by rules you write"
  homepage "https://postvak.pataar.nl/"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.12.0/postvak-aarch64-apple-darwin.tar.xz"
      sha256 "86eed925a4b532ad2315be02b24a100613aac9239584a4ede7cb4f1ab5cbd55d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.12.0/postvak-x86_64-apple-darwin.tar.xz"
      sha256 "6381f21ec5bc61d2b321f34fd6c8651616f4c2f82c609891c8ce61600d7b162f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.12.0/postvak-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "221c84f960c9a7c6ab6e6f4221812102b3f6dd70de97d4f44c0ad5ab1caf7e6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.12.0/postvak-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "51db7e334bf01c65c07b8e559c9722883150de6c18b49ffc2cb0936f40e95663"
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
