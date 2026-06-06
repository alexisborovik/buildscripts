#!/bin/bash

echo "===================================="
echo "🧹 CLEANING CONFLICTING CACHES..."
echo "===================================="
# Удаляем манифесты, чтобы repo качал ТОЛЬКО саму прошивку
rm -rf .repo/local_manifests
# Удаляем сломанные кэши qcom, на которые ругался сервер
rm -rf hardware/qcom-caf/sm8250/audio hardware/qcom-caf/sm8250/display
rm -rf .repo/projects/hardware/qcom-caf/sm8250/audio.git .repo/projects/hardware/qcom-caf/sm8250/display.git

echo "===================================="
echo "🚀 INIT EVOLUTION-X (bq2)..."
echo "===================================="
repo init -u https://github.com/Evolution-X/manifest -b bq2 --git-lfs

echo "===================================="
echo "🔄 SYNCING ROM (WITHOUT DEVICE TREES)..."
echo "===================================="
/opt/crave/resync.sh

echo "===================================="
echo "📥 CLONING DEVICE TREES MANUALLY..."
echo "===================================="
# Удаляем папки на всякий случай и качаем всё вручную через git clone
rm -rf device/xiaomi/spes vendor/xiaomi/spes kernel/xiaomi/sm6225 hardware/xiaomi hardware/samsung-ext/interfaces

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
# ЖЕСТКО ОТКЛЮЧАЕМ ROOMSERVICE, чтобы он не сломал наши папки!
export ROOMSERVICE_DISABLED=true
export DISABLE_ROOMSERVICE=true

source build/envsetup.sh
lunch evolution_spes-userdebug
make installclean
mka evolution
