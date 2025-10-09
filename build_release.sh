#!/bin/bash

# Set variables
APP_NAME="lordan_v1"
SPLIT_INFO_DIR="build/symbols"
OUTPUT_DIR="build/app/outputs/flutter-apk"

echo "🚀 Building release APK for $APP_NAME..."

# Step 1: Clean previous builds
flutter clean

# Step 2: Get packages
flutter pub get

# Step 3: Build the release APK with obfuscation & symbols
flutter build apk \
  --release \
  --obfuscate \
  --split-debug-info=$SPLIT_INFO_DIR \
  --target-platform android-arm64

# Step 4: Show result
echo ""
echo "✅ Build finished!"
echo "🔍 APK location:"
ls -lh $OUTPUT_DIR
