class Thokr < Formula
  desc "Sleek typing TUI with visualized results and historical logging"
  homepage "https://github.com/jrnxf/thokr"
  url "https://github.com/jrnxf/thokr/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "982a5d1860e56ec02abb5560424e4c9668b30264175aff097eaa834f817df75b"
  license "MIT"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/thokr --version")

    # thokr refuses to start without a tty, so drive a one-word test through a pty
    require "pty"
    PTY.spawn(bin/"thokr", "-w", "1", "-p", "hi") do |r, w, pid|
      r.readpartial(1024) # the first draw: thokr is now reading keys
      w.write "hi\x03" # type the word, then quit with ctrl-c
      begin
        r.read
      rescue Errno::EIO
        # on Linux, reading a pty whose child has exited raises instead of ending
      end
      Process.wait pid
    end

    config = OS.mac? ? testpath/"Library/Application Support" : testpath/".config"
    assert_match "date,num_words", (config/"thokr/log.csv").read
  end
end
