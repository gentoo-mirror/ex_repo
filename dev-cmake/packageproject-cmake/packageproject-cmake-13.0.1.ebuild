
# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# it's just a CMake script that installs another CMake script to folder with CMake utility modules (usually /usr/share/cmake/AddBoost.cmake ), thus not cmake-multilib.
inherit cmake

DESCRIPTION="Amazing script for installing your projects!"
HOMEPAGE="https://github.com/Arniiiii/PackageProject.cmake"
SRC_URI="https://github.com/Arniiiii/PackageProject.cmake/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc test"

REQUIRED_USE="
"

DEPEND="
"

RDEPEND="${DEPEND}"

BDEPEND="
	dev-build/cmake
	test? ( dev-cmake/cpm-cmake )
"

S="${WORKDIR}/PackageProject.cmake-${PV}"

src_configure() {
		# Gentoo users enable ccache via e.g. FEATURES=ccache or
	# other means. We don't want the build system to enable it for us.
	sed -i -e '/find_program(CCACHE_FOUND ccache)/d' CMakeLists.txt || die

	local mycmakeargs=(
		-DPackageProject.cmake_INSTALL=YES
	)

	cmake_src_configure

	if use test; then
		CMAKE_USE_DIR=${S}/test BUILD_DIR=${WORKDIR}/${P}_build_test
		local mycmakeargs=(
			-DCPM_DOWNLOAD_LOCATION=${EPREFIX}/usr/share/cmake/CPM.cmake
			-DTEST_INSTALLED_VERSION=OFF
			-DTEST_INSTALLED_VERSION_PACKAGEPROJECT=OFF
		)
		cmake_src_configure
	fi
}

src_compile() {
	if use test; then
		CMAKE_USE_DIR=${S}/test BUILD_DIR=${WORKDIR}/${P}_build_test
		cmake_src_compile
	fi
}

src_test() {
	CMAKE_USE_DIR=${S}/test BUILD_DIR=${WORKDIR}/${P}_build_test
	cmake_src_test
}

src_install() {
	if use doc; then
		einstalldocs
	fi

	cmake_src_install
}
