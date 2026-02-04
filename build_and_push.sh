#!/bin/bash

# QLM Mobile Suite - Build & Push Script for IDX
# This script analyzes the code, builds the APK, zips it, and pushes to Git.

echo "🚀 Starting QLM Mobile Suite Build Process..."

# 1. Clean and Get Dependencies
echo "📦 Getting dependencies..."
flutter pub get

# 2. Analyze Code
echo "🔍 Analyzing code for errors..."
if ! flutter analyze; then
    echo "❌ Analysis failed. Please fix errors before building."
    exit 1
fi

# 3. Build APK
echo "🏗️ Building Release APK..."

# IDX Workaround: Force ALL Java/Gradle temp files into $HOME/tmp (avoiding system /tmp)
export HOME_TMP="$HOME/tmp"
mkdir -p "$HOME_TMP"
export GRADLE_OPTS="-Dorg.gradle.daemon=false -Djava.io.tmpdir=$HOME_TMP"
export _JAVA_OPTIONS="-Djava.io.tmpdir=$HOME_TMP"

# Clean previous build artifacts to save space (Crucial for IDX)
flutter clean

if ! flutter build apk --release --no-tree-shake-icons; then
    echo "❌ Build failed."
    exit 1
fi

# 4. Prepare Release File
echo "📦 Preparing ZIP release for mobile..."
mkdir -p release
cp build/app/outputs/flutter-apk/app-release.apk release/qlm_suite_release.apk

# Zip the release folder (zip pkg added to dev.nix)
zip -r qlm_suite_build.zip release/

# 5. Commit and Push to Git
echo "📤 Pushing build to GitHub..."
git add qlm_suite_build.zip
git commit -m "Build: New APK Release (ZIP) $(date +'%Y-%m-%d %H:%M')"
git push origin main

echo "✅ Done! You can now download qlm_suite_build.zip from GitHub."
