echo "===================================="
echo "🔄 SYNCING EVERYTHING VIA REPO..."
echo "===================================="
/opt/crave/resync.sh

echo "===================================="
echo "🩹 FIXING WINDOWS CRLF BUGS EVERYWHERE..."
echo "===================================="
# Теперь мы лечим от виндовских символов ВСЕ скачанные папки!
find device/xiaomi hardware/xiaomi vendor/xiaomi -type f -name "*.mk" -exec sed -i 's/\r$//' {} + || true
find device/xiaomi hardware/xiaomi vendor/xiaomi -type f -name "*.bp" -exec sed -i 's/\r$//' {} + || true
find device/xiaomi hardware/xiaomi vendor/xiaomi -type f -name "*.sh" -exec sed -i 's/\r$//' {} + || true

echo "===================================="
echo "☠️ PHYSICALLY KILLING ROOMSERVICE..."
echo "===================================="
rm -f device/xiaomi/spes/evolution.dependencies
rm -f device/xiaomi/sm6225-common/evolution.dependencies
rm -f device/xiaomi/spes/lineage.dependencies
rm -f device/xiaomi/sm6225-common/lineage.dependencies

echo "===================================="
echo "🔑 FIXING PRIVATE KEYS ISSUE..."
echo "===================================="
sed -i 's/include vendor\/evolution-priv/-include vendor\/evolution-priv/g' vendor/lineage/config/evolution.mk || true

echo "===================================="
echo "⚙️ STARTING BUILD..."
echo "===================================="
export BUILD_USERNAME=Alexis
export BUILD_HOSTNAME=CraveCloud

source build/envsetup.sh
lunch lineage_spes-userdebug
make installclean
mka evolution
