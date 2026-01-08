# typed: false
# frozen_string_literal: true

class ExecutiveFunction < Formula
  desc "Complete Wolfies tool suite - iMessage, Gmail, Calendar, and Reminders"
  homepage "https://github.com/wolfiesch/wolfies-executive-function"
  version "0.2.0"
  license "MIT"

  # Meta-formula - no source, just dependencies
  url "https://github.com/wolfiesch/wolfies-executive-function/releases/download/v#{version}/executive-function-#{version}.tar.gz"
  sha256 "PLACEHOLDER_SHA256"

  depends_on "wolfiesch/executive-function/wolfies-imessage"
  depends_on "wolfiesch/executive-function/wolfies-gmail"
  depends_on "wolfiesch/executive-function/wolfies-calendar"
  depends_on "wolfiesch/executive-function/wolfies-reminders"

  def install
    # Meta-formula - install README only
    doc.install "README.md" if File.exist?("README.md")
  end

  def post_install
    ohai "Executive Function tool suite installed!"
    ohai ""
    ohai "Installed tools:"
    ohai "  - wolfies-imessage (iMessage CLI + daemon)"
    ohai "  - wolfies-gmail-mcp (Gmail MCP server)"
    ohai "  - wolfies-calendar-mcp (Google Calendar MCP server)"
    ohai "  - wolfies-reminders-mcp (Apple Reminders MCP server)"
    ohai ""
    ohai "Next steps:"
    ohai "  1. Start iMessage daemon: brew services start wolfies-imessage"
    ohai "  2. Configure Google OAuth for Gmail/Calendar (see individual caveats)"
    ohai "  3. Grant macOS permissions for Reminders"
    ohai "  4. Register MCP servers with Claude Code"
  end

  def caveats
    <<~EOS
      Executive Function is a meta-formula that installs all Wolfies tools.

      After installation, configure each tool:

      iMessage (ready to use):
        brew services start wolfies-imessage
        wolfies-imessage health

      Gmail & Calendar (OAuth required):
        1. Create credentials at: https://console.cloud.google.com/apis/credentials
        2. claude mcp add -t stdio gmail -- wolfies-gmail-mcp
        3. claude mcp add -t stdio google-calendar -- wolfies-calendar-mcp

      Reminders (macOS permissions required):
        1. System Settings > Privacy & Security > Reminders > Enable Terminal
        2. System Settings > Privacy & Security > Automation > Terminal > Reminders
        3. claude mcp add -t stdio reminders -- wolfies-reminders-mcp
    EOS
  end

  test do
    system "which", "wolfies-imessage"
    system "which", "wolfies-gmail-mcp"
    system "which", "wolfies-calendar-mcp"
    system "which", "wolfies-reminders-mcp"
  end
end
