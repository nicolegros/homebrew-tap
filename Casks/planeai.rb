cask "planeai" do
  arch arm: "aarch64", intel: "x64"

  version "1.106.4"
  sha256 arm:   "64eb8b0665941d67f4af75b18ac7fe7863884a6e64df493378b6a075ccc57603",
         intel: "dace12193f1cc067835102dc59293656c64c8f575804a5e591f7482a161cfaa2"

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
