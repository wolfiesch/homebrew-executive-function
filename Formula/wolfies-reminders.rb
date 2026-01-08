# typed: false
# frozen_string_literal: true

class WolfiesReminders < Formula
  desc "Apple Reminders MCP server for Claude Code integration"
  homepage "https://github.com/wolfiesch/wolfies-executive-function"
  version "0.2.0"
  license "MIT"

  url "https://github.com/wolfiesch/wolfies-executive-function/releases/download/v#{version}/wolfies-reminders-#{version}.tar.gz"
  sha256 "966a0314fdc9823c6022b6e6139f1cc7573298f9fbb13281a3febc3bb8195b90"

  depends_on :macos
  depends_on "python@3.11"

  def install
    # Install MCP server entry point
    libexec.install "server.py"
    libexec.install "requirements.txt"

    # Install src modules
    (libexec/"src").install Dir["src/*"]

    # Create wrapper script for MCP registration
    (bin/"wolfies-reminders-mcp").write <<~EOS
      #!/bin/bash
      set -euo pipefail
      LIBEXEC_DIR="#{libexec}"
      export PYTHONPATH="$LIBEXEC_DIR"
      cd "$LIBEXEC_DIR"
      exec "#{Formula["python@3.11"].opt_bin}/python3.11" "#{libexec}/server.py" "$@"
    EOS
    (bin/"wolfies-reminders-mcp").chmod 0755

    # Create config directory
    (var/"wolfies-reminders").mkpath
  end

  def post_install
    ohai "Wolfies Apple Reminders MCP installed!"
    ohai ""
    ohai "Setup required:"
    ohai "  1. Grant Reminders access:"
    ohai "     System Settings > Privacy & Security > Reminders > Enable Terminal"
    ohai ""
    ohai "  2. Grant Automation access:"
    ohai "     System Settings > Privacy & Security > Automation > Terminal > Reminders"
    ohai ""
    ohai "  3. Register with Claude Code:"
    ohai "     claude mcp add -t stdio reminders -- #{opt_bin}/wolfies-reminders-mcp"
  end

  def caveats
    <<~EOS
      Apple Reminders MCP server requires macOS permissions.

      1. Grant Reminders access:
         System Settings > Privacy & Security > Reminders > Enable Terminal

      2. Grant Automation access (for AppleScript):
         System Settings > Privacy & Security > Automation > Terminal > Reminders

      3. Install Python dependencies:
         pip3.11 install mcp pyobjc-framework-EventKit pyobjc-core

      4. Register with Claude Code:
         claude mcp add -t stdio reminders -- #{opt_bin}/wolfies-reminders-mcp
    EOS
  end

  test do
    assert_predicate bin/"wolfies-reminders-mcp", :executable?
  end
end
