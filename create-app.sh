#!/bin/bash

# Create a new app from this starter template
# Usage: ./create-app.sh my-new-app

set -e

if [ -z "$1" ]; then
  echo "Usage: ./create-app.sh <app-name>"
  echo "Example: ./create-app.sh my-awesome-app"
  exit 1
fi

APP_NAME=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(dirname "$SCRIPT_DIR")/$APP_NAME"

if [ -d "$TARGET_DIR" ]; then
  echo "Error: Directory $TARGET_DIR already exists"
  exit 1
fi

echo "🚀 Creating new app: $APP_NAME"

# Copy template
cp -r "$SCRIPT_DIR" "$TARGET_DIR"

# Clean up
cd "$TARGET_DIR"
rm -rf .git node_modules .svelte-kit create-app.sh

# Update package.json name
if command -v sed &> /dev/null; then
  sed -i '' "s/\"name\": \"sveltekit-auth-app\"/\"name\": \"$APP_NAME\"/" package.json 2>/dev/null || \
  sed -i "s/\"name\": \"sveltekit-auth-app\"/\"name\": \"$APP_NAME\"/" package.json
fi

# Update wrangler.toml name
if [ -f wrangler.toml ]; then
  sed -i '' "s/name = \"sveltekit-auth-app\"/name = \"$APP_NAME\"/" wrangler.toml 2>/dev/null || \
  sed -i "s/name = \"sveltekit-auth-app\"/name = \"$APP_NAME\"/" wrangler.toml
fi

# Initialize fresh git repo
git init
git add -A
git commit -m "Initial commit from sveltekit-auth-app template"

echo ""
echo "✅ Created $APP_NAME successfully!"
echo ""
echo "Next steps:"
echo "  cd ../$APP_NAME"
echo "  npm install"
echo "  npm run podman:up    # Start PostgreSQL"
echo "  npm run db:push      # Create tables"
echo "  npm run dev          # Start dev server"
echo ""

