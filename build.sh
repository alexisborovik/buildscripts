#!/bin/bash

echo "===================================="
echo "🧹 CLEANING CACHE..."
echo "===================================="
rm -rf .repo/local_manifests
rm -rf device/xiaomi/spes vendor/xiaomi/spes kernel/xiaomi/sm6225 hardware/xiaomi hardware/samsung-ext/interfaces

echo "===================================="
echo "🚀 INIT EVOLUTION-X (bq2)..."
echo "===================================="
repo init -u https://github.com/Evolution-X/manifest -b bq2 --git-lfs
/opt/crave/resync.sh

echo "===================================="
echo "📥 CLONING DEVICE TREES MANUALLY..."
echo "===================================="
git clone https://github.com/Evolution-X-Devices/device_xiaomi_spes.git -b bka device/xiaomi/spes
git clone https://github.com/Evolution-X-Devices/vendor_xiaomi_spes.git -b bka vendor/xiaomi/spes
git clone https://github.com/Evolution-X-Devices/kernel_xiaomi_sm6225.git -b bka kernel/xiaomi/sm6225
git clone https://github.com/LineageOS/android_hardware_xiaomi.git -b lineage-23.2 hardware/xiaomi
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