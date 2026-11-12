#!/usr/bin/env bash
set -e

# Detect OpenSSL via Homebrew (preferring openssl@3, falling back to default openssl)
if brew list openssl@3 &>/dev/null; then
    OPENSSL_PREFIX=$(brew --prefix openssl@3)
elif brew list openssl &>/dev/null; then
    OPENSSL_PREFIX=$(brew --prefix openssl)
else
    echo "Error: OpenSSL not found via Homebrew. Run: brew install openssl@3 ncurses"
    exit 1
fi

echo "Using OpenSSL at: ${OPENSSL_PREFIX}"

# Generate configure script if cloning a fresh repo without one
if [ ! -f ./configure ]; then
    autoreconf -fi
fi

CPPFLAGS="-I${OPENSSL_PREFIX}/include" \
LDFLAGS="-L${OPENSSL_PREFIX}/lib" \
./configure --with-ssl="${OPENSSL_PREFIX}"

make -j"$(sysctl -n hw.ncpu)"
echo "Build complete! Run 'sudo make install' to install system-wide."

