# Build & Release Scripts

Scripts for building and distributing QLM Mobile Suite APKs.

## Available Scripts

### 1. Full Release Build (`build_release.sh`)

Builds APKs for all architectures and creates a zip file.

```bash
chmod +x scripts/build_release.sh
./scripts/build_release.sh
```

**Output:**

- `releases/qlm_mobile_suite-vX.X.X-armeabi-v7a.apk` (32-bit ARM)
- `releases/qlm_mobile_suite-vX.X.X-arm64-v8a.apk` (64-bit ARM - most phones)
- `releases/qlm_mobile_suite-vX.X.X-x86_64.apk` (Intel/AMD)
- `releases/qlm_mobile_suite-vX.X.X-TIMESTAMP.zip`

### 2. Quick Build (`build_quick.sh`)

Builds a single universal APK (larger but works everywhere).

```bash
chmod +x scripts/build_quick.sh
./scripts/build_quick.sh
```

**Output:**

- `releases/qlm_mobile_suite-vX.X.X-universal.apk`

## Download APK from GitHub

1. Run the build script
2. Commit and push releases:

   ```bash
   git add releases/
   git commit -m "release: vX.X.X"
   git push origin main
   ```

3. On your phone, open GitHub repo → releases folder → download APK

## GitHub Releases (Recommended)

For proper versioned releases:

```bash
gh release create v1.0.0 releases/*.apk --title "v1.0.0" --notes "Initial release"
```

Then download from: `https://github.com/omna25data-afk/qlm_mobile_suite/releases`

## Which APK to Download?

| Phone Type | APK to Download |
|------------|-----------------|
| Most modern phones | `arm64-v8a` |
| Older phones | `armeabi-v7a` |
| Emulators/Tablets | `x86_64` |
| Not sure | `universal` |
