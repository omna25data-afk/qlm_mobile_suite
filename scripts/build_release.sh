#!/bin/bash

# ============================================
# QLM Mobile Suite - Build & Publish to GitHub Releases
# ============================================
# Builds a SINGLE universal APK and publishes to GitHub Releases
# ============================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get version from pubspec.yaml
VERSION=$(grep 'version:' pubspec.yaml | sed 's/version: //' | tr -d ' ' | cut -d'+' -f1)
BUILD_NUMBER=$(grep 'version:' pubspec.yaml | sed 's/version: //' | tr -d ' ' | cut -d'+' -f2)
APP_NAME="qlm_mobile_suite"
RELEASE_DIR="releases"
APK_NAME="${APP_NAME}-v${VERSION}.apk"

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}   QLM Mobile Suite - Build & Publish${NC}"
echo -e "${BLUE}============================================${NC}"
echo -e "${YELLOW}Version: ${VERSION} (build ${BUILD_NUMBER})${NC}"
echo ""

# Step 1: Clean
echo -e "${YELLOW}[1/5] Cleaning previous builds...${NC}"
flutter clean > /dev/null 2>&1
echo -e "${GREEN}✓ Clean${NC}"

# Step 2: Get dependencies
echo -e "${YELLOW}[2/5] Getting dependencies...${NC}"
flutter pub get > /dev/null 2>&1
echo -e "${GREEN}✓ Dependencies${NC}"

# Step 3: Build Universal APK (works on ALL Android devices)
echo -e "${YELLOW}[3/5] Building Universal APK...${NC}"
flutter build apk --release

echo -e "${GREEN}✓ APK built${NC}"

# Step 4: Prepare release
echo -e "${YELLOW}[4/5] Preparing release...${NC}"
mkdir -p "${RELEASE_DIR}"
cp "build/app/outputs/flutter-apk/app-release.apk" "${RELEASE_DIR}/${APK_NAME}"
APK_SIZE=$(ls -lh "${RELEASE_DIR}/${APK_NAME}" | awk '{print $5}')
echo -e "${GREEN}✓ APK ready: ${APK_NAME} (${APK_SIZE})${NC}"

# Step 5: Publish to GitHub Releases
echo -e "${YELLOW}[5/5] Publishing to GitHub Releases...${NC}"

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo -e "${RED}⚠ GitHub CLI (gh) not installed${NC}"
    echo -e "Install with: ${YELLOW}sudo apt install gh${NC}"
    echo -e "Then authenticate: ${YELLOW}gh auth login${NC}"
    echo ""
    echo -e "${BLUE}Manual upload:${NC}"
    echo -e "1. Go to: https://github.com/omna25data-afk/qlm_mobile_suite/releases"
    echo -e "2. Click 'Create a new release'"
    echo -e "3. Tag: v${VERSION}"
    echo -e "4. Upload: ${RELEASE_DIR}/${APK_NAME}"
    exit 0
fi

# Check if release already exists
if gh release view "v${VERSION}" > /dev/null 2>&1; then
    echo -e "${YELLOW}Release v${VERSION} exists, updating...${NC}"
    gh release upload "v${VERSION}" "${RELEASE_DIR}/${APK_NAME}" --clobber
else
    echo -e "${YELLOW}Creating new release v${VERSION}...${NC}"
    gh release create "v${VERSION}" \
        "${RELEASE_DIR}/${APK_NAME}" \
        --title "الإصدار ${VERSION}" \
        --notes "## نظام الأمين الشرعي - الإصدار ${VERSION}

### التحميل
📱 **[تحميل APK](https://github.com/omna25data-afk/qlm_mobile_suite/releases/download/v${VERSION}/${APK_NAME})**

### متطلبات التشغيل
- Android 5.0 (API 21) أو أحدث

### ملاحظات
- ملف APK واحد يعمل على جميع أجهزة Android"
fi

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}   ✅ PUBLISHED SUCCESSFULLY!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "📥 Download link:"
echo -e "${BLUE}https://github.com/omna25data-afk/qlm_mobile_suite/releases/download/v${VERSION}/${APK_NAME}${NC}"
echo ""
echo -e "📄 Releases page:"
echo -e "${BLUE}https://github.com/omna25data-afk/qlm_mobile_suite/releases${NC}"
