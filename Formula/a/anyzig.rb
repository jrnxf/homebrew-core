class Anyzig < Formula
  desc "Universal zig executable that runs any version of zig"
  homepage "https://github.com/marler8997/anyzig"
  url "https://github.com/marler8997/anyzig/archive/refs/tags/v2026_10_13.tar.gz"
  sha256 "fa87b33ea91cda5f7df7bfb74fdb4ead644b53f68a5bdf9480b7292bcb1affbe"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b74b8a10618d168a874dfb7cbb1bd8a32a81347b6a818f223b47867090b86f23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e325f79fe7feec7d8be39362aeb50782bf324ea99c074fb1eb392dc7991e0b96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22edb36bfb2d62b7c3e70b970fb811fc9c3609eefe87181d5e7c5200b2e8a206"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b8227dc878ab1f9ddb379e15ae0d886f40dcdd4a472314c6fb96eafe96a075c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eff964177238e0129e2dce0d96b6e0c09a690da2135148607b6597f409179034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ec5b50befefe7b3e36c11b2ad750ba9e64905a1594fc3ec5d74a08b5e8abd82"
  end

  keg_only "it conflicts with zig"

  depends_on "zig" => :build

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    args = %W[-Dforce-version=v#{version.to_s.tr(".", "_")}]
    system "zig", "build", *args, *std_zig_args
  end

  test do
    assert_match "v#{version.to_s.tr(".", "_")}", shell_output("#{bin}/zig any version").strip
    system bin/"zig", "any", "list-installed"
  end
end
