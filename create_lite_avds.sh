#!/usr/bin/env bash
set -euo pipefail

AVDMANAGER="$HOME/Library/Android/sdk/cmdline-tools/latest/bin/avdmanager"
EMULATOR="$HOME/Library/Android/sdk/emulator/emulator"
IMG="system-images;android-33;google_apis_playstore;arm64-v8a"

DEVICES=(
  "pixel_4:Pixel_4_Lite:Pixel 4 Lite"
  "pixel_4a:Pixel_4a_Lite:Pixel 4a Lite"
  "pixel_5:Pixel_5_Lite:Pixel 5 Lite"
  "pixel_8:Pixel_8_Lite:Pixel 8 Lite"
  "pixel_8a:Pixel_8a_Lite:Pixel 8a Lite"
  "pixel_9:Pixel_9_Lite:Pixel 9 Lite"
)

for item in "${DEVICES[@]}"; do
  IFS=: read -r dev name display <<< "$item"
  echo ">>> Recreating $name ($dev) with Google Play..."
  "$AVDMANAGER" delete avd -n "$name" >/dev/null 2>&1 || true
  "$AVDMANAGER" create avd -f -n "$name" -k "$IMG" -g "google_apis_playstore" -d "$dev" -c 128M <<< "no"

  cfg="$HOME/.android/avd/${name}.avd/config.ini"
  orig=$(grep -vE '^[[:space:]]*(AvdId|PlayStore\.enabled|avd\.ini\.displayname|disk\.dataPartition\.size|fastboot\.chosenSnapshotFile|fastboot\.forceChosenSnapshotBoot|fastboot\.forceColdBoot|fastboot\.forceFastBoot|firstboot\.saveToLocalSnapshot|hw\.cpu\.ncore|hw\.gpu\.enabled|hw\.gpu\.mode|hw\.keyboard|hw\.ramSize|hw\.sdCard|sdcard\.size|showDeviceFrame|skin\.dynamic|vm\.heapSize)[[:space:]]*=' "$cfg" || true)

  {
    printf '%s\n' "$orig"
    cat <<EOF
AvdId=$name
PlayStore.enabled=true
avd.ini.displayname=$display
disk.dataPartition.size=3G
fastboot.chosenSnapshotFile=
fastboot.forceChosenSnapshotBoot=no
fastboot.forceColdBoot=yes
fastboot.forceFastBoot=no
firstboot.saveToLocalSnapshot=no
hw.cpu.ncore=2
hw.gpu.enabled=yes
hw.gpu.mode=auto
hw.keyboard=yes
hw.ramSize=2048
hw.sdCard=yes
sdcard.size=128M
showDeviceFrame=no
skin.dynamic=yes
vm.heapSize=256
EOF
  } | LC_ALL=C sort > "$cfg"
done

echo "=== Done! Danh sách AVD hiện có: ==="
"$EMULATOR" -list-avds
