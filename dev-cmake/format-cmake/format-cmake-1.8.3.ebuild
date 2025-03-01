# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# it's just a CMake script that installs another CMake script to
# folder with CMake utility modules (usually /usr/share/cmake/Format.cmake ), thus not cmake-multilib.
inherit cmake

DESCRIPTION="Yet another CMake script for formatting"
HOMEPAGE="https://github.com/TheLartians/Format.cmake"
SRC_URI="https://github.com/TheLartians/Format.cmake/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/Format.cmake-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc"

# REQUIRED_USE=""

# DEPEND=""

RDEPEND="
	${DEPEND}
	dev-util/cmake-format
	llvm-core/clang
"

BDEPEND="
	dev-build/cmake
"
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/0001_make_it_installable.patch"
)

CMAKE_USE_DIR=${S}/packaging

src_install() {
	if use doc; then
		einstalldocs
	fi

	cmake_src_install
}

pkg_postinst() {
	einfo "You can use the package in CMake via"
	einfo "\`find_package(Format.cmake VERSION xy.z.w)\`."
	einfo "Remember, if you use CPM, just add to configuration flags "
	einfo "\`-DCPM_LOCAL_PACKAGES_ONLY=1\` and everything is going to be ok."
}
