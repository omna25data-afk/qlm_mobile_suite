#!/bin/bash

# ============================================
# QLM Mobile Suite - Build & Release Script
# ============================================
# This script builds APKs for multiple architectures
# and creates a zip file for easy distribution
# ============================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="qlm_mobile_suite"
VERSION=$(grep 'version:' pubspec.yaml | sed 's/version: //' | tr -d ' ')
BUILD_DIR="build/app/outputs/flutter-apk"
RELEASE_DIR="releases"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}   QLM Mobile Suite - Build Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo -e "${YELLOW}Version: ${VERSION}${NC}"
echo ""

# Step 1: Clean previous builds
echo -e "${YELLOW}[1/5] Cleaning previous builds...${NC}"
flutter clean
echo -e "${GREEN}✓ Clean complete${NC}"

# Step 2: Get dependencies
echo -e "${YELLOW}[2/5] Getting dependencies...${NC}"
flutter pub get
echo -e "${GREEN}✓ Dependencies fetched${NC}"

# Step 3: Build APKs for all architectures
echo -e "${YELLOW}[3/5] Building APKs (split per ABI)...${NC}"
flutter build apk --release --split-per-abi

echo -e "${GREEN}✓ APKs built successfully${NC}"

# Step 4: Create release directory
echo -e "${YELLOW}[4/5] Preparing release package...${NC}"
mkdir -p "${RELEASE_DIR}"

# Copy APKs to release directory with version names
cp "${BUILD_DIR}/app-armeabi-v7a-release.apk" "${RELEASE_DIR}/${APP_NAME}-v${VERSION}-armeabi-v7a.apk"
cp "${BUILD_DIR}/app-arm64-v8a-release.apk" "${RELEASE_DIR}/${APP_NAME}-v${VERSION}-arm64-v8a.apk"
cp "${BUILD_DIR}/app-x86_64-release.apk" "${RELEASE_DIR}/${APP_NAME}-v${VERSION}-x86_64.apk"

echo -e "${GREEN}✓ APKs copied to ${RELEASE_DIR}/${NC}"

# Step 5: Create zip file
echo -e "${YELLOW}[5/5] Creating zip archive...${NC}"
ZIP_NAME="${APP_NAME}-v${VERSION}-${TIMESTAMP}.zip"
cd "${RELEASE_DIR}"
zip -r "${ZIP_NAME}" *.apk
cd ..

echo -e "${GREEN}✓ Zip created: ${RELEASE_DIR}/${ZIP_NAME}${NC}"

# Summary
echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}   BUILD COMPLETE!${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo -e "APK Files:"
ls -lh "${RELEASE_DIR}"/*.apk 2>/dev/null || echo "No APK files found"
echo ""
echo -e "Zip Archive:"
ls -lh "${RELEASE_DIR}"/*.zip 2>/dev/null || echo "No zip files found"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. git add releases/"
echo -e "2. git commit -m 'release: v${VERSION}'"
echo -e "3. git push origin main"
echo -e "4. Download APK from GitHub on your phone"
echo ""
echo -e "${BLUE}Or create a GitHub Release:${NC}"
echo -e "gh release create v${VERSION} ${RELEASE_DIR}/*.apk --title 'v${VERSION}' --notes 'Release v${VERSION}'"
