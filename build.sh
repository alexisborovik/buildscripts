#!/bin/bash

echo "===================================="
echo "🚀 INIT EVOLUTION-X (bq2)..."
echo "===================================="
repo init -u https://github.com/Evolution-X/manifest -b bq2 --git-lfs

echo "===================================="
echo "📝 SETTING UP LOCAL MANIFEST..."
echo "===================================="
rm -rf .repo/local_manifests
mkdir -p .repo/local_manifests
cat <<EOF > .repo/local_manifests/spes.xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <!-- Качаем основные деревья через repo, чтобы не было ошибки "Is a directory" -->
  <project path="device/xiaomi/spes" name="Evolution-X-Devices/device_xiaomi_spes" remote="github" revision="bka" />
  <project path="vendor/xiaomi/spes" name="Evolution-X-Devices/vendor_xiaomi_spes" remote="github" revision="bka" />
  <project path="kernel/xiaomi/sm6225" name="Evolution-X-Devices/kernel_xiaomi_sm6225" remote="github" revision="bka" />
</manifest>
EOF

echo "===================================="
echo "🧹 CLEANING CRAVE CACHE BUGS..."
echo "===================================="
# Удаляем битый кэш Crave, чтобы repo не выдал ошибку "unsupported checkout state"
rm -rf .repo/project-objects/Evolution-X-Devices
rm -rf .repo/projects/device/xiaomi/spes.git
rm -rf .repo/projects/vendor/xiaomi/spes.git
rm -rf .repo/projects/kernel/xiaomi/sm6225.git

echo "===================================="
echo "🔄 SYNCING ROM..."
echo "===================================="
/opt/crave/resync.sh

echo "===================================="
echo "📥 CLONING HARDWARE TREES MANUALLY..."
echo "===================================="
# Делаем ТОЧНО КАК В РАБОЧЕМ СКРИПТЕ: проблемные папки качаем вручную после синхронизации
rm -rf hardware/xiaomi
git clone https://github.com/LineageOS/android_hardware_xiaomi.git -b lineage-23.2 hardware/xiaomi

rm -rf hardware/samsung-ext/interfaces
git clone https://github.com/Roynas-Android-Playground/hardware_samsung-extra_interfaces.git -b lineage-23.2 hardware/samsung-ext/interfaces

echo "===================================="
echo "⚙️ STARTING BUILD..."
echo "===================================="
export BUILD_USERNAME=Alexis
export BUILD_HOSTNAME=CraveCloud

source build/envsetup.sh
lunch evolution_spes-userdebug
make installclean
mka evolution
