# typed: false
# frozen_string_literal: true

class WolfiesCalendar < Formula
  desc "Google Calendar MCP server for Claude Code integration"
  homepage "https://github.com/wolfiesch/wolfies-executive-function"
  version "0.2.0"
  license "MIT"

  url "https://github.com/wolfiesch/wolfies-executive-function/releases/download/v#{version}/wolfies-calendar-#{version}.tar.gz"
  sha256 "PLACEHOLDER_SHA256"

  depends_on :macos
  depends_on "python@3.11"

  def install
    # Install MCP server files
    libexec.install "server.py"
    libexec.install "calendar_client.py"
    libexec.install "requirements.txt"

    # Create wrapper script for MCP registration
    (bin/"wolfies-calendar-mcp").write <<~EOS
      #!/bin/bash
      set -euo pipefail
      LIBEXEC_DIR="#{libexec}"
      export PYTHONPATH="$LIBEXEC_DIR"
      cd "$LIBEXEC_DIR"
      exec "#{Formula["python@3.11"].opt_bin}/python3.11" "#{libexec}/server.py" "$@"
    EOS
    (bin/"wolfies-calendar-mcp").chmod 0755

    # Create config directory
    (var/"wolfies-calendar").mkpath
  end

  def post_install
    ohai "Wolfies Google Calendar MCP installed!"
    ohai ""
    ohai "Setup required:"
    ohai "  1. Create Google OAuth credentials at:"
    ohai "     https://console.cloud.google.com/apis/credentials"
    ohai ""
    ohai "  2. Save credentials.json to:"
    ohai "     ~/.config/wolfies-calendar/credentials.json"
    ohai ""
    ohai "  3. Register with Claude Code:"
    ohai "     claude mcp add -t stdio google-calendar -- #{opt_bin}/wolfies-calendar-mcp"
  end

  def caveats
    <<~EOS
      Google Calendar MCP server requires Google OAuth setup.

      1. Create credentials at: https://console.cloud.google.com/apis/credentials
      2. Download credentials.json to: ~/.config/wolfies-calendar/
      3. Install Python dependencies:
         pip3.11 install google-api-python-client google-auth-httplib2 google-auth-oauthlib mcp python-dateutil
      4. Register with Claude Code:
         claude mcp add -t stdio google-calendar -- #{opt_bin}/wolfies-calendar-mcp

      First run will open browser for OAuth authentication.

      Tip: You can share credentials.json with wolfies-gmail if both use the same Google account.
    EOS
  end

  test do
    assert_predicate bin/"wolfies-calendar-mcp", :executable?
  end
end
