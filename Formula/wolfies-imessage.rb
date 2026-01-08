# typed: false
# frozen_string_literal: true

class WolfiesImessage < Formula
  desc "High-performance iMessage CLI with daemon architecture (19x faster than MCP)"
  homepage "https://github.com/wolfiesch/LIFE-PLANNER"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/wolfiesch/LIFE-PLANNER/releases/download/v#{version}/wolfies-imessage-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 ""
    end
    on_intel do
      url "https://github.com/wolfiesch/LIFE-PLANNER/releases/download/v#{version}/wolfies-imessage-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 ""
    end
  end

  depends_on :macos
  depends_on "python@3.11"

  def install
    # Install Rust CLI binary
    bin.install "wolfies-imessage"

    # Install Python daemon files
    libexec.install "daemon/imessage_daemon.py"
    libexec.install "daemon/output_utils.py"
    (libexec/"src").install Dir["daemon/src/*"]
    (libexec/"gateway").install Dir["daemon/gateway/*"]

    # Create daemon wrapper script
    (bin/"wolfies-imessage-daemon").write <<~EOS
      #!/bin/bash
      set -euo pipefail
      DAEMON_DIR="#{libexec}"
      export PYTHONPATH="$DAEMON_DIR"
      cd "$DAEMON_DIR"
      exec "#{Formula["python@3.11"].opt_bin}/python3.11" "#{libexec}/imessage_daemon.py" "$@"
    EOS
    (bin/"wolfies-imessage-daemon").chmod 0755

    # Create socket directory
    (var/"wolfies-imessage").mkpath
  end

  def post_install
    ohai "Wolfies iMessage CLI installed!"
    ohai ""
    ohai "Usage:"
    ohai "  Start daemon:  brew services start wolfies-imessage"
    ohai "  Or manually:   wolfies-imessage-daemon start"
    ohai ""
    ohai "  CLI commands:  wolfies-imessage --help"
    ohai "  Health check:  wolfies-imessage health"
  end

  def caveats
    <<~EOS
      The iMessage daemon requires Full Disk Access to read the Messages database.

      Grant access in: System Settings > Privacy & Security > Full Disk Access
      Add: #{Formula["python@3.11"].opt_bin}/python3.11

      Start the daemon service:
        brew services start wolfies-imessage

      Socket location: ~/.wolfies-imessage/daemon.sock
    EOS
  end

  service do
    run [opt_bin/"wolfies-imessage-daemon", "start", "--foreground"]
    keep_alive true
    working_dir var/"wolfies-imessage"
    log_path var/"log/wolfies-imessage.log"
    error_log_path var/"log/wolfies-imessage-error.log"
    environment_variables PATH: std_service_path_env
  end

  test do
    # Test CLI binary exists and responds
    assert_match "wolfies", shell_output("#{bin}/wolfies-imessage --version 2>&1", 0)

    # Test daemon script exists
    assert_predicate bin/"wolfies-imessage-daemon", :exist?
    assert_predicate bin/"wolfies-imessage-daemon", :executable?
  end
end
