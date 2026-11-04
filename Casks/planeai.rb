cask "planeai" do
  arch arm: "aarch64", intel: "x64"

  version "1.112.0"
  sha256 arm:   "1a6edf5e9470e2b14a1d674a0bcfa1ffaf319caf12d0c176c5fa79dcc4306c21",
         intel: "23ff5efaffdb85100402ebf24d3486b74e7d4f7063def1355fdab8e7bbd82b93"

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
