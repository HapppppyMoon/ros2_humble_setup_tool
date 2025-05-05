#!/bin/bash

# MCP Server Installation Script

echo "===== Installing MCP servers ====="
sudo apt update -y
sudo apt upgrade -y
sudo apt install nodejs npm -y

sudo npm cache clean -f
sudo npm install -g n
sudo n lts

yes | sudo npm install -g @modelcontextprotocol/server-filesystem @agentset/mcp @anaisbetts/mcp-youtube @anaisbetts/mcp-installer @smithery/cli

yes | npx @smithery/cli install @hbg/mcp-paperswithcode --client vscode --key "08295ed0-294e-45a9-b1ef-2e02d5933c18" --no-sandbox
yes | npx @smithery/cli install arxiv-mcp-server --client vscode --key "08295ed0-294e-45a9-b1ef-2e02d5933c18" --no-sandbox
yes | npx @smithery/cli install mcp-pandoc --client vscode --key "08295ed0-294e-45a9-b1ef-2e02d5933c18" --no-sandbox
echo "===== MCP servers installation completed ====="
