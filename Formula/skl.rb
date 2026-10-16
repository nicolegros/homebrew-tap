class Skl < Formula
  desc "Install, update, and remove AI agent skills from GitHub repositories"
  homepage "https://github.com/nicolegros/skl"
  url "https://github.com/nicolegros/skl/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "09bb621576f00bde2eb90e7e42d597cde8f606898625183bd3caa059f1d3bf41"
  license "MIT"
  head "https://github.com/nicolegros/skl.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    generate_completions_from_executable(bin/"skl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skl version")
  end
end
