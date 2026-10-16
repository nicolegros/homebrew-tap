cask "planeai" do
  arch arm: "aarch64", intel: "x64"

  version "1.105.3"
  sha256 arm:   "013be65c5b80ebbc26672ea3bb9625bd8ad954b40a36157cf4dc0cdf42614e67",
         intel: "32ae508da4d241e589b2a45eb53475d87ed0840c092658af52ae3320c63b1cbe"

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
