class Bfgminer < Formula
  desc "Modular CPU/GPU/ASIC/FPGA miner written in C"
  homepage "http://bfgminer.org"
  url "https://github.com/broberson/homebrew-bfgminer/releases/download/5.5.0/bfgminer-5.5.0-tahoe.tgz"
  sha256 "908f7c50159dc573f12fe1f55b72409bd6cfa60bebb8bc6c87978366a45f8435"
  license "GPL-3.0-or-later"
  head "https://github.com/broberson/bfgminer.git", branch: "bfgminer"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "hidapi" => :build
  depends_on "libgcrypt" => :build
  depends_on "libscrypt" => :build
  depends_on "uthash" => :build
  depends_on 'gnu-sed' => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "libusb"

  uses_from_macos "curl"

  def install
    inreplace "gen-version.sh", "sed", "gsed"

    system "NOSUBMODULES=1 ./autogen.sh"

    configure_args = std_configure_args + %w[
      --without-system-libbase58
      --enable-cpumining
      --enable-opencl
      --enable-scrypt
      --enable-keccak
      --enable-bitmain
      --enable-alchemist
    ]
    configure_args << "--with-udevrulesdir=#{lib}/udev" if OS.linux?

    system "./configure", *configure_args
    system "make", "install"
  end

  test do
    assert_match "Work items generated", shell_output("bash -c \"#{bin}/bfgminer --benchmark 2>/dev/null <<< q\"")
  end
end
