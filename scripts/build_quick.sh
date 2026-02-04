#!/bin/bash

# ============================================
# Quick Build - Single Universal APK
# ============================================
# Creates a single APK that works on all devices
# (Larger file size but simpler distribution)
# ============================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

VERSION=$(grep 'version:' pubspec.yaml | sed 's/version: //' | tr -d ' ')
RELEASE_DIR="releases"

echo -e "${BLUE}Building Universal APK...${NC}"

# Build universal APK
flutter build apk --release

# Create release directory
mkdir -p "${RELEASE_DIR}"

# Copy APK
cp "build/app/outputs/flutter-apk/app-release.apk" "${RELEASE_DIR}/qlm_mobile_suite-v${VERSION}-universal.apk"

echo -e "${GREEN}✓ Universal APK created!${NC}"
echo -e "Location: ${RELEASE_DIR}/qlm_mobile_suite-v${VERSION}-universal.apk"
ls -lh "${RELEASE_DIR}/qlm_mobile_suite-v${VERSION}-universal.apk"
