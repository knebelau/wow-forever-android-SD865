# WoW Forever for Android (Snapdragon 865 / Adreno 650 Edition)

Play **World of Warcraft: Forever** on **Snapdragon 865 (Adreno 650)** Android handhelds (such as the **Retroid Pocket 5**, **Retroid Pocket Flip 2**, and **Retroid Pocket Mini**) as a normal Android app. You tap the icon, press Play, and the game runs.

This uses Blizzard's own **Windows ARM64** WoW client, so the game itself runs natively on the handheld's CPU. Wine translates the Windows calls, and DXVK plus a patched Mesa Turnip Vulkan driver render the game on the Adreno 650 GPU. Nothing is emulated as x86.

> Unofficial community project. Not affiliated with or endorsed by Blizzard Entertainment. You need your own Battle.net account with WoW Forever access. This repo and its releases contain **no** Blizzard game files.

---

## Supported devices

| Device | SoC / GPU | Status |
| :--- | :--- | :--- |
| **Retroid Pocket Flip 2** | Snapdragon 865 / Adreno 650 | Tested in-world at 720p with built-in controller support |
| **Retroid Pocket 5 (RP5)** | Snapdragon 865 / Adreno 650 | Supported (same SoC, GPU, and RAM configuration) |
| **Retroid Pocket Mini** | Snapdragon 865 / Adreno 650 | Supported (automatically scales to 4:3 screen aspect ratio) |
| **Other Snapdragon 865 devices** | Snapdragon 865 (`SM8250` / `kona`) / Adreno 650 | Supported |

Requirements:

- **Qualcomm Snapdragon 865 (Adreno 650 GPU)**. The app comes pre-configured with an Adreno 650-optimized Turnip driver (`Turnip-SD865-Z`), native hardware BCn texture decoding, `sysmem` rendering (bypassing the 1 MB GMEM limit in 3D zones), and tuned DXVK/Wine settings.
- Android 10 or newer, 64-bit (6 GB or 8 GB RAM recommended).
- About **60 GB** free for the game data (internal storage or microSD card), plus about 4 GB of internal storage for the app and its Windows environment.
- Wi-Fi. A computer is optional: it only speeds up the first install by copying the game data over instead of streaming it.

---

## Installation

### 1. Install the app

Download `WoW-Forever.apk` from the [latest release](https://github.com/knebelau/wow-forever-android-SD865/releases/latest) and install it on your device. The app's package name is `app.wowforever`, so it can sit alongside GameNative or Winlator.

### 2. Install the game

Open **WoW Forever** and grant **All files access** when asked; the app needs it to read and write the game folder. The launcher then shows **Install World of Warcraft** with the install location, which defaults to `/storage/emulated/0/WoW Forever/`. Tap **Change Install Location** to use another folder, such as one on a microSD card (picking a folder that isn't empty, like the card's root, installs into a new `WoW Forever` folder inside it), then tap **Download & Install**.

The app downloads the Windows ARM64 client and the CASC archive indexes (about 250 MB) from Blizzard's CDN, checking every hash. The rest of the game data isn't downloaded up front: the game client streams it from Blizzard's CDN as you play and keeps it on disk. Expect longer loading screens the first time you visit a zone. The data grows to about 50 GB once you've been everywhere.

#### Optional: copy the game from a computer instead

If you have WoW Forever installed through Battle.net on a Mac or PC, copying its data skips the streaming. Copy two things from the install root (on a Mac that's `/Applications/World of Warcraft/`) into a `WoW Forever` folder at the root of internal storage or an SD card, where the launcher finds it automatically. Any other folder works too: tap **Locate Existing Files** and pick it.

```
WoW Forever/
├── .build.info                   <- from the install root
└── Data/                         <- the whole Data folder
```

- `Data/` is the same on every platform, so a Mac, Windows, or ARM install all work.
- `.build.info` is a hidden file. Copy it too. Without it the game fails with *"CAS system was unable to initialize"*.
- You don't need `Wow-ARM64.exe`. Mac and x86 installs don't ship it, so the app downloads the matching Windows ARM64 client from Blizzard's CDN when you press Play, and checks its hashes.
- **Location** switches folders later.

Ways to get the files onto the device:

- **SD Card:** Insert the microSD card into your computer and copy the files over (make sure your file manager shows hidden files so `.build.info` is included).
- **USB File Transfer:** Connect your device to your computer via USB (in File Transfer / MTP mode) and copy the files directly to internal storage (default: `/storage/emulated/0/WoW Forever/`).
- **ADB Script:** If you have ADB installed and this repo checked out, you can use the sync script to copy initial files easily over USB:

```bash
WOW_SRC="/Applications/World of Warcraft" tools/sync_wow_to_device.sh
```

#### Upgrading from the WoW Forever beta

Blizzard replaced the beta (`wow_classic_beta`, in `_classic_beta_/`) with the full release (`wowf`, in `_forever_/`). Both use the same game archives, so there's nothing to copy again. When the launcher finds a beta install it shows **WoW Forever Has Launched**. Tap **Upgrade Now** and the app:

- downloads the full-release ARM64 client (about 100 MB) into `_forever_/`
- adds a `wowf` entry to `.build.info`
- carries over your settings from `_classic_beta_/WTF/Config.wtf`

Your existing `Data/` folder is reused. The `_classic_beta_/` folder can be deleted afterwards.

### 3. Play

Once your game files and Battle.net credentials are configured, the app automatically launches straight into the game. If credentials are not yet configured, the launcher stops at the setup screen so you can enter them before playing. The first launch downloads the ARM64 game client and installs the Windows environment, which takes a few minutes and needs an internet connection.

- **Setup screen:** to access folder settings, forget credentials, check environment status, or view updates, hold **Start + Select + L2 + R2** (or tap the back button) during the loading splash to cancel boot and return to the setup screen.
- The app creates a basic `WTF/Config.wtf` on first run and always sets `gxApi "D3D11"` along with safe view distance (`farclip "1200"`) and shadow (`shadowMode "0"`) defaults for the Adreno 650.
- **Region:** tap **Region** on the setup screen to choose Americas, Europe, Korea or Taiwan. The game logs straight into that region without showing its region picker. New installs default to a guess based on the device's country. The game is also installed and updated to the build that region's realms run, which can differ between regions right after a patch.
- **Resolution:** tap **Resolution** on the setup screen to choose 720p, 900p or 1080p. Snapdragon 865 / Adreno 650 devices default to **720p**, which provides the best balance of framerate and memory usage. The game's resolution is set from this on every launch and reshaped to fit non-16:9 screens.
- **Add-ons:** download an add-on's `.zip` on your device, then tap **Add-on** on the setup screen and pick it. It's installed into `_forever_/Interface/AddOns`, replacing any older copy. You can also copy add-on folders there yourself.
- **Custom Turnip Driver Override (Optional):** you can test any custom Adreno 650 Turnip driver without rebuilding the APK by placing `libvulkan_freedreno.so` or `turnip-sd865.zip` (`.adpkg`) into your WoW install folder or the Android `Download/` folder.

### Controls and signing in

- **Controller:** built-in handheld controllers work in-game. WoW's own gamepad mode handles the mapping.
- **In-game menu:** press Back (the button or the back swipe gesture) to open the sidebar. It has **Keyboard**, on-screen controls, performance overlay and **Exit**.
- **Keyboard:** the sidebar's **Keyboard** opens the Android keyboard. Symbols like `@` work, and so does pasting.
- **Battle.net Auto-Login:** configure credentials directly on the launcher setup screen (**Login**). Credentials are saved encrypted on-device via Android Keystore. On boot, the launcher generates `_forever_/login.txt`, which the WoW client automatically reads on startup to sign in natively without macro simulation or synthetic clicks. Use **Forget Login** on the launcher setup screen to clear credentials and remove the login file.
  - Authenticator codes still have to be entered by hand. The game keeps running when you switch apps, so you can grab a code from an authenticator app on the same device.
  - Each install shows Battle.net its own Windows PC identity (machine ID and a `DESKTOP-XXXXXXX` computer name), generated once and kept across updates. Reinstalling the app creates a new one, so Battle.net may treat it as a new device.

---

## Updating the game

WoW Forever features a native in-app game updater connected directly to Blizzard's public edge CDNs. **You no longer need a computer or USB cables to keep your game updated.**

Whenever Blizzard patches the game:
1. **Live Version Check:** The launcher automatically checks the live version against Blizzard's public patch service on startup.
2. **Update Gate:** If an update is detected, auto-launch cancels and displays the update card with the remote build version, plus a secondary *Launch Anyway (Outdated)* override.
3. **One-Tap Update:** Tapping **UPDATE TO {version}** downloads the new ARM64 client binaries (`Wow-ARM64.exe` and companion DLLs), saves remote configs to `Data/config/`, syncs new CASC index archives to `Data/indices/`, and atomically updates `.build.info` on disk over Wi-Fi.
4. **Instant Boot:** Once the update completes, the launcher automatically transitions into booting World of Warcraft.
5. **In-Game Streaming:** The game engine's internal streaming client seamlessly streams any newly introduced assets from Blizzard's edge CDNs during gameplay.

---

## Snapdragon 865 / Adreno 650 Optimizations

Compared to the upstream Snapdragon 8 Gen 2 / 8 Elite project, this edition includes specific fixes for the **Snapdragon 865 (`SM8250` / Adreno 650)**:

- **Patched Turnip Driver with ICD Exports (`Turnip-SD865-Z`):** Bundles Mesa Turnip (`fe067b17d9`) with the IR3 barycentric scheduler fix, `FD650` (Adreno 650) support, and `vk_icd*` exports required by `bionic-vulkan-wrapper`.
- **Native Hardware BCn Textures (`bcnEmulation=none`, `resourceType=auto`):** Disables the wrapper's BCn-to-ASTC compute transcoding and buffer-resource wrapping, which otherwise caused `kgsl-3d0` GPU ringbuffer hangs (`status 00E795E5`) when entering the 3D world on Adreno 650.
- **1 MB GMEM & LRZ Bypass (`TU_DEBUG=noconform,sysmem,nolrz,nolrzfc,nocb,unaligned_store`):** Prevents 3D world load crashes (`VK_ERROR_DEVICE_LOST`) caused by WoW's deferred G-buffer MRT pass overflowing the Adreno 650's 1 MB GMEM tile buffer or hanging in LRZ fast-clears.
- **Native GPU Detection Fix:** Fixes a bug where an empty `gpuName` in `graphicsDriverConfig` matched the last entry in `gpu_cards.json` (`Intel(R) UHD Graphics 630`), ensuring WoW detects `Turnip Adreno (TM) 650` with 4 GB VRAM budget and full UBWC bandwidth compression.
- **Tuned DXVK, Shader Cache & World CVars:** Configures asynchronous pipeline compilation (`DXVK_ASYNC=1`, `DXVK_GPLASYNCCACHE=1`), a 128 MB Mesa shader cache, `d3d11.constantBufferRangeCheck = True`, and safe world CVars (`farclip "1200"`, `shadowMode "0"`).

---

## Troubleshooting

| Symptom | Fix |
| :--- | :--- |
| *CAS system was unable to initialize: no active install info entries* | `.build.info` or `_forever_/.flavor.info` is missing on the device. |
| *No realms available* / no servers listed | The device client is out of date. Tap **Update** on the launcher setup screen, or restart the app with Wi-Fi enabled. |
| Keyboard doesn't appear | Force-stop Gboard (Settings → Apps → Gboard → Force stop) and open **Keyboard** again. |
| Returns to the launcher after "Launching Game…" | Check the files under `_forever_/Errors/` and `_forever_/Logs/gx.log` on the device. |
| Handheld frontend (e.g. ES-DE / Cocoon) shows the wrong icon | The frontend cached an old icon. Refresh app artwork or reinstall the app. |

---

## Building from source

Requirements: JDK 17 and the Android SDK (with build-tools and platform-tools).

```bash
tools/fetch_components.sh           # Wine/Proton, DXVK and Turnip archives (~130 MB, not in git)
./gradlew assembleModernRelease     # app/build/outputs/apk/modern/release/app-modern-release.apk
./gradlew assembleModernDebug       # unminified debug build, faster to iterate on
```

Release builds are signed with `app/keystores/keystore.properties` when it exists (`storeFile`, `storePassword`, `keyAlias`, `keyPassword`). Otherwise they fall back to the debug key. Builds signed with different keys can't update each other, so switching between them means uninstalling first.

---

## Credits

This project builds on:

- **[wow-forever-android](https://github.com/jaredgei/wow-forever-android)** by jaredgei and the WoW Forever handheld community.
- **[GameNative](https://github.com/utkarshdalal/GameNative)** by Utkarsh Dalal and contributors (GPL-3.0), which builds on **[Pluvia](https://github.com/oxters168/Pluvia)**, **[Winlator](https://github.com/brunodev85/winlator)**, **[Winlator Cmod](https://github.com/coffincolors/winlator)** and the **[Bionic Vulkan wrapper](https://github.com/leegao/bionic-vulkan-wrapper)**.
- **[Proton 11 ARM64EC](https://github.com/The412Banner/proton-wine)**, **[DXVK](https://github.com/doitsujin/dxvk)**, **[Mesa Turnip](https://mesa3d.org/)**, **[FEX-Emu](https://github.com/FEX-Emu/FEX)**, **[box64](https://github.com/ptitSeb/box64)** and **[PulseAudio](https://www.freedesktop.org/wiki/Software/PulseAudio/)**.
- **Blizzard Entertainment** for World of Warcraft and its Windows ARM64 client.

## License

GPL-3.0, the same as GameNative. See [`LICENSE`](LICENSE). The bundled runtime components carry their own licenses (LGPL, MIT and others). See `THIRD_PARTY_NOTICES` and the notices inside each component archive.
