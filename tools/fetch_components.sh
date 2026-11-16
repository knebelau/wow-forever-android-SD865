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
            cp "$DEST/turnip-wow-scheduler-test.zip" "$DEST/$f.part"
            python3 - "$DEST/$f.part" <<'PY'
import json, os, sys, zipfile
zip_path = sys.argv[1]
with zipfile.ZipFile(zip_path, "r") as zin, zipfile.ZipFile(zip_path + ".repacked", "w", zipfile.ZIP_DEFLATED) as zout:
    for item in zin.infolist():
        data = zin.read(item.filename)
        if item.filename == "meta.json":
            meta = json.loads(data.decode("utf-8"))
            meta["name"] = "Turnip-SD865-Z"
            meta["description"] = "Mesa Turnip fe067b17d9 with IR3 barycentric scheduler fix, ICD exports, and Adreno 650 (FD650) GMEM support."
            meta["driverVersion"] = "26.1.99-fe067b17d9-sd865-wow"
            meta["libraryName"] = "libvulkan_freedreno.so"
            zout.writestr("meta.json", json.dumps(meta, indent=2) + "\n")
        else:
            zout.writestr(item, data)
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
