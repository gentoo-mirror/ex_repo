# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# it's just a CMake script that installs another CMake script to folder with CMake utility modules (usually /usr/share/cmake/AddBoost.cmake ), thus not cmake-multilib.
inherit cmake

DESCRIPTION="Yet another CMake script for finding or bundling Boost."
HOMEPAGE="https://github.com/Arniiiii/AddBoost.cmake"
SRC_URI="https://github.com/Arniiiii/AddBoost.cmake/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc"

REQUIRED_USE="
"

DEPEND="
"

RDEPEND="${DEPEND}"

BDEPEND="
	dev-build/cmake
	dev-cmake/cpm-cmake
"

S="${WORKDIR}/AddBoost.cmake-${PV}"

src_configure() {
		# Gentoo users enable ccache via e.g. FEATURES=ccache or
	# other means. We don't want the build system to enable it for us.
	sed -i -e '/find_program(CCACHE_FOUND ccache)/d' CMakeLists.txt || die

	local mycmakeargs=(
		-DAddBoost.cmake_INSTALL=YES
	)

	cmake_src_configure
}

src_install() {
	if use doc; then
		einstalldocs
	fi

	cmake_src_install
}

pkg_postinst() {
	einfo "You can use the package in CMake via"
	einfo "\`find_package(AddBoost.cmake VERSION xy.z.w)\`."
	einfo "Remember, if you use CPM, just add to configuration flags "
	einfo "\`-DCPM_LOCAL_PACKAGES_ONLY=1\` and everything is going to be ok."
}
