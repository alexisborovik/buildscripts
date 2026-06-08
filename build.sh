#!/bin/bash
set -e

echo "===================================="
echo "🧹 CLEANING WORKSPACE..."
echo "===================================="
rm -rf .repo/local_manifests
rm -rf device/xiaomi/spes device/xiaomi/sm6225-common
rm -rf vendor/xiaomi/spes vendor/xiaomi/sm6225-common
rm -rf kernel/xiaomi/sm6225 hardware/xiaomi hardware/samsung-ext/interfaces

echo "===================================="
echo "🚀 INIT EVOLUTION-X (bq2)..."
echo "===================================="
repo init -u https://github.com/Evolution-X/manifest -b bq2 --git-lfs
/opt/crave/resync.sh

echo "===================================="
echo "📥 CLONING ALL TREES MANUALLY..."
echo "===================================="
# Качаем специфичные деревья (spes)
git clone https://github.com/Evolution-X-Devices/device_xiaomi_spes.git -b bka device/xiaomi/spes
git clone https://github.com/Evolution-X-Devices/vendor_xiaomi_spes.git -b bka vendor/xiaomi/spes

# Качаем ОБЩИЕ деревья (sm6225-common), без них сборка не пойдет!
git clone https://github.com/Evolution-X-Devices/device_xiaomi_sm6225-common.git -b bka device/xiaomi/sm6225-common
git clone https://github.com/Evolution-X-Devices/vendor_xiaomi_sm6225-common.git -b bka vendor/xiaomi/sm6225-common

# Качаем ядро и железо
git clone https://github.com/Evolution-X-Devices/kernel_xiaomi_sm6225.git -b bka kernel/xiaomi/sm6225
git clone https://github.com/LineageOS/android_hardware_xiaomi.git -b lineage-23.2 hardware/xiaomi
git clone https://github.com/Roynas-Android-Playground/hardware_samsung-extra_interfaces.git -b lineage-23.2 hardware/samsung-ext/interfaces

echo "===================================="
echo "🩹 FIXING WINDOWS CRLF BUGS IN DEVICE TREE..."
echo "===================================="
# Эта магия найдет все файлы .mk, .bp и .sh в папке устройства и удалит из них виндовские символы \r
find device/xiaomi -type f -name "*.mk" -exec sed -i 's/\r$//' {} +
find device/xiaomi -type f -name "*.bp" -exec sed -i 's/\r$//' {} +
find device/xiaomi -type f -name "*.sh" -exec sed -i 's/\r$//' {} +

echo "===================================="
echo "⚙️ STARTING BUILD..."
echo "===================================="
export BUILD_USERNAME=Alexis
export BUILD_HOSTNAME=CraveCloud
export DISABLE_ROOMSERVICE=true
export ROOMSERVICE_DISABLED=true

source build/envsetup.sh
lunch evolution_spes-userdebug
make installclean
mka evolution
