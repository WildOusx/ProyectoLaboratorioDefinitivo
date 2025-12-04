#!/usr/bin/env bash
# original copy preserved in deprecated_tools
set -euo pipefail

# Simple build helper for MSYS2 MINGW (64-bit or 32-bit)
# Usage: run this from the MSYS2 MINGW64 (or MINGW32) shell in the project root:
#   ./tools/build_mingw.sh

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "Proyecto: $ROOT_DIR"
echo "MSYSTEM=${MSYSTEM:-UNKNOWN}"

if [[ -z "${MSYSTEM:-}" ]]; then
  echo "Advertencia: parece que no estás en una MSYS2/MINGW shell." >&2
  echo "Ejecuta esto desde 'MSYS2 MinGW 64-bit' o 'MSYS2 MinGW 32-bit'." >&2
  exit 1
fi

ARCH="x86_64"
PKGMGR_ARCH="mingw-w64-x86_64"
PREFIX="/mingw64"
if [[ "$MSYSTEM" == MINGW32 || "$MSYSTEM" == MINGW64_32 ]]; then
  ARCH="i686"
  PKGMGR_ARCH="mingw-w64-i686"
  PREFIX="/mingw32"
fi

echo "Detected target: $ARCH (MSYSTEM=$MSYSTEM)"

cat <<'EOH'
Recommended MSYS2 packages (run this manually if you haven't):

pacman -Syu
pacman -S --needed \
  base-devel \
  mingw-w64-<ARCH>-toolchain \
  mingw-w64-<ARCH>-pkg-config \
  mingw-w64-<ARCH>-SDL2 \
  mingw-w64-<ARCH>-SDL2_image \
  mingw-w64-<ARCH>-libpng \
  mingw-w64-<ARCH>-libjpeg-turbo \
  mingw-w64-<ARCH>-libogg \
  mingw-w64-<ARCH>-libvorbis

Replace <ARCH> with ${PKGMGR_ARCH} (script will show exact command below).
If you want MUNT/FluidSynth (MT-32/FluidSynth) support, also install:
  mingw-w64-<ARCH>-munt mingw-w64-<ARCH>-fluidsynth

EOH

echo
echo "Paquete sugerido para instalar (copia/pega en tu shell MSYS2 MINGW):"
echo
echo "pacman -Syu"
echo "pacman -S --needed base-devel ${PKGMGR_ARCH}-toolchain ${PKGMGR_ARCH}-pkg-config ${PKGMGR_ARCH}-SDL2 ${PKGMGR_ARCH}-SDL2_image ${PKGMGR_ARCH}-libpng ${PKGMGR_ARCH}-libjpeg-turbo ${PKGMGR_ARCH}-libogg ${PKGMGR_ARCH}-libvorbis"
echo
read -r -p "¿Quieres continuar y ejecutar ./configure + make ahora? [y/N] " proceed
if [[ "$proceed" != "y" && "$proceed" != "Y" ]]; then
  echo "Cancelado por el usuario. Instala los paquetes y vuelve a ejecutar el script.";
  exit 0
fi

echo "Ejecutando ./configure --prefix=${PREFIX} ..."
./configure --prefix="${PREFIX}"

CORES=1
if command -v nproc >/dev/null 2>&1; then
  CORES=$(nproc)
elif [[ -n "${NUMBER_OF_PROCESSORS:-}" ]]; then
  CORES=${NUMBER_OF_PROCESSORS}
fi

echo "Compilando con make -j${CORES} ..."
make -j"${CORES}"

echo
echo "Compilación finalizada. Ejecutable esperado en: $ROOT_DIR/bin/opendune.exe (o en ${PREFIX}/bin si ejecutaste 'make install')"
echo "Si quieres instalar en ${PREFIX} ejecuta: make install"

exit 0
