#!/bin/bash



# Автоматическое определение путей
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="$SCRIPT_DIR/../.."
BUILD_DIR="$SCRIPT_DIR"
OUTPUT_DIR="$WORK_DIR/ipk"
DATA_DIR="$BUILD_DIR/data"
VERSION_FILE="$WORK_DIR/opt/bin/libs/main"

get_version_param() {
    grep -oP "(?<=^$1=)[^[:space:]]+" "$VERSION_FILE" 2>/dev/null | head -1 || echo ""
}


# ===== Настройки =====
PKG_NAME="kvas"
PKG_VERSION=$(get_version_param "APP_VERSION")
PKG_RELEASE=$(get_version_param "APP_RELEASE")
PKG_ARCH="all"


# ===== Функция установки прав =====
set_perms() {
    local path="$1"
    local mode="$2"
    
    # Для Cygwin сначала сбрасываем все права
    /bin/chmod 000 "$path" 2>/dev/null
    
    case $mode in
        644) /bin/chmod u+rw-x,go+r-wx "$path" ;;  # -rw-r--r--
        755) /bin/chmod u+rwx,go+rx-w "$path" ;;   # -rwxr-xr-x
        700) /bin/chmod u+rwx,go-rwx "$path" ;;    # -rwx------
    esac
}

# ===== Очистка и подготовка =====
rm -rf "$DATA_DIR" "$BUILD_DIR"/{control,data}.tar.gz "$BUILD_DIR"/*.ipk 2>/dev/null
mkdir -p "$DATA_DIR"/opt/{apps/kvas,etc/init.d,etc/nmd/fs.d,etc/nmd/netfilter.d}


# ===== 3. data.tar.gz =====
# Копирование содержимого opt/
cp -r "$WORK_DIR/opt"/* "$DATA_DIR/opt/apps/kvas/"

# Установка прав для apps/
find "$DATA_DIR/opt/apps" -type f -print0 | while IFS= read -r -d $'\0' file; do
    set_perms "$file" 644
done

find "$DATA_DIR/opt/apps" -type d -print0 | while IFS= read -r -d $'\0' dir; do
    set_perms "$dir" 755
done

# Установка прав для etc/
find "$DATA_DIR/opt/etc" -type d -print0 | while IFS= read -r -d $'\0' dir; do
    set_perms "$dir" 755
done

# Копирование отдельных файлов с правами
declare -A etc_files=(
    ["$WORK_DIR/opt/etc/init.d/S96kvas"]="$DATA_DIR/opt/etc/init.d/S96kvas"
    ["$WORK_DIR/opt/etc/ndm/fs.d/100-ipset"]="$DATA_DIR/opt/etc/nmd/fs.d/100-ipset"
    ["$WORK_DIR/opt/etc/ndm/netfilter.d/100-dns-local"]="$DATA_DIR/opt/etc/nmd/netfilter.d/100-dns-local"
    ["$WORK_DIR/opt/etc/ndm/netfilter.d/100-proxy-redirect"]="$DATA_DIR/opt/etc/nmd/netfilter.d/100-proxy-redirect"
)

for src in "${!etc_files[@]}"; do
    dest="${etc_files[$src]}"
    if [ -f "$src" ]; then
        cp "$src" "$dest"
        set_perms "$dest" 755
    else
        echo "Предупреждение: Файл $src не найден"
    fi
done

# Упаковка data.tar.gz
cd "$DATA_DIR" || exit 1
tar -czf "$BUILD_DIR/data.tar.gz" --owner=0 --group=0 *


# ===== 1. debian-binary =====
echo "2.0" > "$BUILD_DIR/debian-binary"

# ===== 2. control.tar.gz =====
CONTROL_FILE="$BUILD_DIR/control/control"
# Версия
sed -i "s/^Version: .*/Version: ${PKG_VERSION}_${PKG_RELEASE}/" "$CONTROL_FILE"
# Дата сборки (Unix timestamp)
CURRENT_EPOCH=$(date +%s)
sed -i "s/^SourceDateEpoch: .*/SourceDateEpoch: $CURRENT_EPOCH/" "$CONTROL_FILE"
# Считаем размер data/opt и control
SIZE_DATA=$(du -sb "$DATA_DIR" | cut -f1)
SIZE_CONTROL=$(du -sb "$BUILD_DIR/control" | cut -f1)
INSTALLED_SIZE=$((SIZE_DATA + SIZE_CONTROL))
sed -i "s/^Installed-Size: .*/Installed-Size: $INSTALLED_SIZE/" "$CONTROL_FILE"

cd "$BUILD_DIR/control" || exit 1
set_perms control 644
set_perms postinst 755
set_perms postrm 755
tar -czf "$BUILD_DIR/control.tar.gz" --owner=0 --group=0 *


# ===== 4. Сборка .ipk =====
cd "$BUILD_DIR" || exit 1
mkdir -p "$OUTPUT_DIR"
tar -czf "$OUTPUT_DIR/${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}_${PKG_ARCH}.ipk" \
    debian-binary control.tar.gz data.tar.gz

# 4.2. Архив исходников (чистая копия opt/)
SOURCE_ARCHIVE="${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}.tar.gz"
cd "$WORK_DIR" || exit 1
tar -czf "$OUTPUT_DIR/$SOURCE_ARCHIVE" opt/


# Чистка
cd "$BUILD_DIR" || exit 1
rm -rf "$DATA_DIR" control.tar.gz data.tar.gz debian-binary

echo "Готово! Созданы:"
echo "  - Пакет: $(cygpath -w "$OUTPUT_DIR/${PKG_NAME}_${PKG_VERSION}-${PKG_RELEASE}_${PKG_ARCH}.ipk")"
echo "  - Исходники: $(cygpath -w "$OUTPUT_DIR/$SOURCE_ARCHIVE")"