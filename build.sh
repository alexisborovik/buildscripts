#!/bin/bash
set -e

echo "===================================="
echo "🧹 CLEANING WORKSPACE..."
echo "===================================="
rm -rf .repo/local_manifests
rm -rf device/xiaomi vendor/xiaomi kernel/xiaomi hardware/xiaomi hardware/samsung-ext

echo "===================================="
echo "🚀 INIT EVOLUTION-X (bq2)..."
echo "===================================="
repo init -u https://github.com/Evolution-X/manifest -b bq2 --git-lfs

echo "===================================="
echo "📝 CREATING LOCAL MANIFEST..."
echo "===================================="
# Создаем официальный манифест со ВСЕМИ нужными деревьями (включая common)
mkdir -p .repo/local_manifests
cat <<EOF > .repo/local_manifests/spes.xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project path="device/xiaomi/spes" name="Evolution-X-Devices/device_xiaomi_spes" remote="github" revision="bka" />
  <project path="device/xiaomi/sm6225-common" name="Evolution-X-Devices/device_xiaomi_sm6225-common" remote="github" revision="bka" />
  <project path="vendor/xiaomi/spes" name="Evolution-X-Devices/vendor_xiaomi_spes" remote="github" revision="bka" />
  <project path="vendor/xiaomi/sm6225-common" name="Evolution-X-Devices/vendor_xiaomi_sm6225-common" remote="github" revision="bka" />
  <project path="kernel/xiaomi/sm6225" name="Evolution-X-Devices/kernel_xiaomi_sm6225" remote="github" revision="bka" />
  <project path="hardware/xiaomi" name="LineageOS/android_hardware_xiaomi" remote="github" revision="lineage-23.2" />
  <project path="hardware/samsung-ext/interfaces" name="Roynas-Android-Playground/hardware_samsung-extra_interfaces" remote="github" revision="lineage-23.2" />
</manifest>
EOF

echo "===================================="
echo "💥 NUKING CRAVE CACHE BUGS..."
echo "===================================="
# Жестко удаляем кэш Crave для наших репозиториев, чтобы repo не сошел с ума!
rm -rf .repo/project-objects/Evolution-X-Devices
rm -rf .repo/project-objects/LineageOS/android_hardware_xiaomi.git
rm -rf .repo/project-objects/Roynas-Android-Playground

echo "===================================="
echo "🔄 SYNCING EVERYTHING VIA REPO..."
echo "===================================="
# Теперь repo скачает всё идеально чисто и официально!
/opt/crave/resync.sh

echo "===================================="
echo "🩹 FIXING WINDOWS CRLF BUGS..."
echo "===================================="
# Лечим кривые файлы мейнтейнера
find device/xiaomi -type f -name "*.mk" -exec sed -i 's/\r$//' {} + || true
find device/xiaomi -type f -name "*.bp" -exec sed -i 's/\r$//' {} + || true
find device/xiaomi -type f -name "*.sh" -exec sed -i 's/\r$//' {} + || true

echo "===================================="
echo "⚙️ STARTING BUILD..."
echo "===================================="
export BUILD_USERNAME=Alexis
export BUILD_HOSTNAME=CraveCloud

source build/envsetup.sh
lunch evolution_spes-userdebug
make installclean
mka evolution
