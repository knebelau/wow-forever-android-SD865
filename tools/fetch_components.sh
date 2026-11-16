#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$REPO_DIR/app/src/main/assets/bundled_components"
RELEASE_URL="${COMPONENTS_URL:-https://github.com/jaredgei/wow-forever-android/releases/download/components-v1}"
FILES=(
    proton-11.0-90624-arm64ec.wcp
    dxvk-2.4.1-wow-aarch64-test.wcp
    turnip-wow-scheduler-test.zip
    turnip-V32-RP6sched.zip
    turnip-sd865.zip
)

mkdir -p "$DEST"
for f in "${FILES[@]}"; do
    if [ -s "$DEST/$f" ]; then
        echo "have $f"
    elif [ -n "${1:-}" ] && [ -s "$1/$f" ]; then
        cp "$1/$f" "$DEST/$f"
        echo "copied $f"
    else
        if [ "$f" = "turnip-V32-RP6sched.zip" ]; then
            curl -fL --retry 3 -o "$DEST/$f.part" "https://raw.githubusercontent.com/arusiasotto/wow-forever-a840/main/driver/turnip-V32-RP6sched.zip"
        elif [ "$f" = "turnip-sd865.zip" ]; then
            curl -fL --retry 3 -o "$DEST/$f.part" "https://github.com/K11MCH1/AdrenoToolsDrivers/releases/download/v25.3.0-rc.06/Turnip_v25.3.0_R6_Gmem.zip"
            python3 - "$DEST/$f.part" <<'PY'
import json, os, sys, zipfile
zip_path = sys.argv[1]
with zipfile.ZipFile(zip_path, "r") as zin:
    so_name = next(n for n in zin.namelist() if n.endswith(".so"))
    so_data = zin.read(so_name)
    meta = json.loads(zin.read("meta.json").decode("utf-8"))
meta["name"] = "Turnip-SD865-Z"
meta["libraryName"] = "libvulkan_freedreno.so"
with zipfile.ZipFile(zip_path + ".repacked", "w", zipfile.ZIP_DEFLATED) as zout:
    zout.writestr("meta.json", json.dumps(meta, indent=2) + "\n")
    zout.writestr("libvulkan_freedreno.so", so_data)
os.replace(zip_path + ".repacked", zip_path)
PY
        else
            curl -fL --retry 3 -o "$DEST/$f.part" "$RELEASE_URL/$f"
        fi
        mv "$DEST/$f.part" "$DEST/$f"
        echo "downloaded $f"
    fi
done

(cd "$DEST" && shasum -a 256 -c "$REPO_DIR/tools/components.sha256")
