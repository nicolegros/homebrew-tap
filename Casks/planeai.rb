cask "planeai" do
  arch arm: "aarch64", intel: "x64"

  version "1.116.0"
  sha256 arm:   "e917388d124b4492a5e19e4c35e3e9f54dc62bb9e3eb6d918b8affb4f2ba4834",
         intel: "9376310b04c5cce54e66446bb943225ff1b72d63507d36f3891ea99d8deb9d1f"

  url "https://github.com/nicolegros/planeai/releases/download/v#{version}/planeai_#{version}_#{arch}.dmg"
  name "planeai"
  desc "Desktop orchestrator for AI coding agent sessions"
  homepage "https://github.com/nicolegros/planeai"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on :macos

  app "planeai.app"
  binary "#{appdir}/planeai.app/Contents/MacOS/planeai-cli"

  # The in-app Command line installer symlinks these into /usr/local/bin.
  uninstall_preflight_steps do
    remove ["/usr/local/bin/planeai-cli", "/usr/local/bin/planeai-daemon"],
           symlink_target_contains: "/Applications/planeai.app/",
           sudo:                    :if_needed
  end

  uninstall quit: "ca.nicolegros.planeai"

  zap script: {
        executable:   "/usr/bin/pkill",
        args:         ["-x", "planeai-daemon"],
        must_succeed: false,
      },
      delete: "/tmp/planeai-#{Process.uid}",
      trash:  [
        "~/.config/planeai",
        "~/.planeai",
        "~/Library/Application Support/ca.nicolegros.planeai",
        "~/Library/Caches/ca.nicolegros.planeai",
        "~/Library/HTTPStorages/ca.nicolegros.planeai",
        "~/Library/Preferences/ca.nicolegros.planeai.plist",
        "~/Library/Saved Application State/ca.nicolegros.planeai.savedState",
        "~/Library/WebKit/ca.nicolegros.planeai",
      ]
end
