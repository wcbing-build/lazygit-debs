#!/bin/sh

PACKAGE="lazygit"
REPO="jesseduffield/lazygit"

# Processing again to avoid errors of remote incoming 
VERSION=$(echo $1 | sed -n 's|[^0-9]*\([^_]*\).*|\1|p')

ARCH="amd64 arm64"
AMD64_FILENAME="lazygit_"$VERSION"_Linux_x86_64.tar.gz"
ARM64_FILENAME="lazygit_"$VERSION"_Linux_arm64.tar.gz"
build() {
    # Prepare
    BASE_DIR="$PACKAGE"_"$VERSION"-1_"$1"
    rm -rf "$BASE_DIR"
    cp -r templates "$BASE_DIR"
    sed -i "s/Architecture: arch/Architecture: $1/" "$BASE_DIR/DEBIAN/control"
    sed -i "s/Version: version/Version: $VERSION-1/" "$BASE_DIR/DEBIAN/control"
    # Download and move file
    curl -sLo "$PACKAGE-$1.tar.gz" "$(get_url_by_arch $1)"
    mkdir -p "$PACKAGE-$1"
    tar -xzf "$PACKAGE-$1.tar.gz" -C "$PACKAGE-$1"
    mv "$PACKAGE-$1/$PACKAGE" "$BASE_DIR/usr/bin/$PACKAGE"
    chmod 755 "$BASE_DIR/usr/bin/$PACKAGE"
    # Build
    dpkg-deb -b --root-owner-group -Z xz "$BASE_DIR" output
}

get_url_by_arch() {
    case $1 in
    "amd64") echo "https://github.com/$REPO/releases/latest/download/$AMD64_FILENAME" ;;
    "arm64") echo "https://github.com/$REPO/releases/latest/download/$ARM64_FILENAME" ;;
    esac
}

mkdir output

for i in $ARCH; do
    echo "Building $i package..."
    build "$i"
done

# Create repo files
cd output
apt-ftparchive packages . > Packages
apt-ftparchive release . > Release
