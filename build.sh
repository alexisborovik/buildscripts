echo "===================================="
echo "🩹 FIXING WINDOWS CRLF BUGS..."
echo "===================================="
find device/xiaomi -type f -name "*.mk" -exec sed -i 's/\r$//' {} + || true
find device/xiaomi -type f -name "*.bp" -exec sed -i 's/\r$//' {} + || true
find device/xiaomi -type f -name "*.sh" -exec sed -i 's/\r$//' {} + || true

echo "===================================="
echo "☠️ PHYSICALLY KILLING ROOMSERVICE..."
echo "===================================="
rm -f device/xiaomi/spes/evolution.dependencies
rm -f device/xiaomi/sm6225-common/evolution.dependencies
rm -f device/xiaomi/spes/lineage.dependencies
rm -f device/xiaomi/sm6225-common/lineage.dependencies

echo "===================================="
echo "🔑 FAKING PRIVATE KEYS..."
echo "===================================="
# Создаем пустую структуру ключей, чтобы система не ругалась на их отсутствие
mkdir -p vendor/evolution-priv/keys
touch vendor/evolution-priv/keys/keys.mk

echo "===================================="
echo "⚙️ STARTING BUILD..."
echo "===================================="
export BUILD_USERNAME=Alexis
export BUILD_HOSTNAME=CraveCloud

source build/envsetup.sh
lunch lineage_spes-userdebug
make installclean
mka evolution
