# Maintainer: Yigit Dallilar <yigit.dallilar@gmail.com>

pkgname=arch-dracut-hook-git
pkgver=r23.419921f
pkgrel=1
epoch=
arch=(any)
url="https://github.com/pssncp142/arch-dracut-hook"
groups=()
depends=("dracut")
makedepends=()
checkdepends=()
optdepends=()
provides=()
conflicts=()
replaces=()
backup=()
options=()
changelog=
source=("arch-dracut-hook-git::git+https://github.com/pssncp142/arch-dracut-hook#branch=master")
license=()
md5sums=('SKIP')
pkgdesc="Alpm hook to generate initramfs images with dracut"
#install="${pkgname}.install"

pkgver() {
    cd ${pkgname}
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package () {
    install -D -m755 ${srcdir}/${pkgname}/dracut-initramfs.sh ${pkgdir}/usr/bin/dracut-initramfs
    install -D -m644 ${srcdir}/${pkgname}/90-dracut-generate-initramfs.hook ${pkgdir}/etc/pacman.d/hooks/90-dracut-generate-initramfs.hook
}

