#!/bin/bash
set -e

echo "===================================="
echo "🧹 AGGRESSIVE CLEANING (LIKE A PRO)..."
echo "===================================="
# Сносим всё, что может вызвать конфликт кэша Crave
rm -rf .repo/local_manifests
rm -rf device/xiaomi/spes
rm -rf vendor/xiaomi/spes
rm -rf kernel/xiaomi/sm6225
rm -rf hardware/xiaomi
rm -rf hardware/samsung-ext/interfaces

echo "===================================="
echo "🚀 INIT EVOLUTION-X (bq2)..."
echo "===================================="
repo init -u https://github.com/Evolution-X/manifest -b bq2 --depth=1 --git-lfs

echo "===================================="
echo "📝 CREATING XML MANIFEST..."
echo "===================================="
# Делаем то же самое, что его git clone, только создаем файл на лету
mkdir -p .repo/local_manifests
cat <<EOF > .repo/local_manifests/spes.xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project path="device/xiaomi/spes" name="Evolution-X-Devices/device_xiaomi_spes" remote="github" revision="bka" />
  <project path="vendor/xiaomi/spes" name="Evolution-X-Devices/vendor_xiaomi_spes" remote="github" revision="bka" />
  <project path="kernel/xiaomi/sm6225" name="Evolution-X-Devices/kernel_xiaomi_sm6225" remote="github" revision="bka" />
  <project path="hardware/xiaomi" name="LineageOS/android_hardware_xiaomi" remote="github" revision="lineage-23.2" />
  <project path="hardware/samsung-ext/interfaces" name="Roynas-Android-Playground/hardware_samsung-extra_interfaces" remote="github" revision="lineage-23.2" />
</manifest>
EOF

echo "===================================="
echo "🔄 SYNCING EVERYTHING VIA REPO..."
echo "===================================="
# Теперь repo сам скачает и EvoX, и деревья из spes.xml без ошибок!
/opt/crave/resync.sh

echo "===================================="
echo "⚙️ STARTING BUILD..."
echo "===================================="
export BUILD_USERNAME=Alexis
export BUILD_HOSTNAME=CraveCloud

source build/envsetup.sh
lunch evolution_spes-userdebug
make installclean
mka evolution
