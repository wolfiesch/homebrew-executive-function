# typed: false
# frozen_string_literal: true

class WolfiesGmail < Formula
  desc "Gmail MCP server for Claude Code integration"
  homepage "https://github.com/wolfiesch/wolfies-executive-function"
  version "0.2.0"
  license "MIT"

  url "https://github.com/wolfiesch/wolfies-executive-function/releases/download/v#{version}/wolfies-gmail-#{version}.tar.gz"
  sha256 "5f4c4fd1348b9e5637ac74fe003376e5422459c94542a062910a5c36db61ef1c"

  depends_on :macos
  depends_on "python@3.11"

  def install
    # Install MCP server files
    libexec.install "server.py"
    libexec.install "gmail_client.py"
    libexec.install "requirements.txt"

    # Create wrapper script for MCP registration
    (bin/"wolfies-gmail-mcp").write <<~EOS
      #!/bin/bash
      set -euo pipefail
      LIBEXEC_DIR="#{libexec}"
      export PYTHONPATH="$LIBEXEC_DIR"
      cd "$LIBEXEC_DIR"
      exec "#{Formula["python@3.11"].opt_bin}/python3.11" "#{libexec}/server.py" "$@"
    EOS
    (bin/"wolfies-gmail-mcp").chmod 0755

    # Create config directory
    (var/"wolfies-gmail").mkpath
  end

  def post_install
    ohai "Wolfies Gmail MCP installed!"
    ohai ""
    ohai "Setup required:"
    ohai "  1. Create Google OAuth credentials at:"
    ohai "     https://console.cloud.google.com/apis/credentials"
    ohai ""
    ohai "  2. Save credentials.json to:"
    ohai "     ~/.config/wolfies-gmail/credentials.json"
    ohai ""
    ohai "  3. Register with Claude Code:"
    ohai "     claude mcp add -t stdio gmail -- #{opt_bin}/wolfies-gmail-mcp"
  end

  def caveats
    <<~EOS
      Gmail MCP server requires Google OAuth setup.

      1. Create credentials at: https://console.cloud.google.com/apis/credentials
      2. Download credentials.json to: ~/.config/wolfies-gmail/
      3. Install Python dependencies:
         pip3.11 install google-api-python-client google-auth-httplib2 google-auth-oauthlib mcp
      4. Register with Claude Code:
         claude mcp add -t stdio gmail -- #{opt_bin}/wolfies-gmail-mcp

      First run will open browser for OAuth authentication.
    EOS
  end

  test do
    assert_predicate bin/"wolfies-gmail-mcp", :executable?
  end
end
