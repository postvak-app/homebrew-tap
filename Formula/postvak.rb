class Postvak < Formula
  desc "A fast, simple mail client with automatic mailbox rules"
  homepage "https://postvak.pataar.nl/"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.7.0/postvak-aarch64-apple-darwin.tar.xz"
      sha256 "624af2fa6a34abfc51e3824ae9a9ef29d5b32dbbd40882c22cc917a80e8cd29d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.7.0/postvak-x86_64-apple-darwin.tar.xz"
      sha256 "023cbe47c5896366d95fceb956c69ddda86d185a54dce0e8ca5924e10fcabcf1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/postvak-app/postvak/releases/download/v0.7.0/postvak-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d284d0fa5c77b77e81d6ed950d9f228125e9d627a815a861a1444108861deb5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/postvak-app/postvak/releases/download/v0.7.0/postvak-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bf48a79830f497901c1f1a005cbf1fa91abffe8995b27b4c1d92deece3875cb9"
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
