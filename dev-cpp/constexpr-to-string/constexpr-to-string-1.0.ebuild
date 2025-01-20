# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# it's a header-only lib, thus not cmake-multilib. However, examples and tests...
inherit cmake

DESCRIPTION="C++14 code to convert integers to strings at compile-time "
HOMEPAGE="https://github.com/Arniiiii/constexpr-to-string-cmake"

CPM_COMMIT_ARNIIIII="4d245d2e584298071e5f7723fc8fc6f02f79f9b5"
PACKAGEPROJECT_VER="1.13.0"

SRC_URI="
	https://github.com/Arniiiii/constexpr-to-string-cmake/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://raw.githubusercontent.com/Arniiiii/CPM.cmake/${CPM_COMMIT_ARNIIIII}/cmake/CPM.cmake -> CPM-${CPM_COMMIT_ARNIIIII}.cmake
	https://github.com/TheLartians/PackageProject.cmake/archive/refs/tags/v${PACKAGEPROJECT_VER}.tar.gz -> PackageProject.cmake-${PACKAGEPROJECT_VER}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

REQUIRED_USE="
"

DEPEND="
	dev-libs/boost
	dev-libs/openssl:0/3
"

RDEPEND="${DEPEND}"

BDEPEND="
dev-build/cmake
"

S="${WORKDIR}/constexpr-to-string-cmake-${PV}"

src_unpack() {
	default
	cp ${DISTDIR}/CPM-${CPM_COMMIT_ARNIIIII}.cmake ${S}/CPM.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DCPM_LOCAL_PACKAGES_ONLY=1
		-DCPM_DOWNLOAD_ALL=0
		-DCPM_USE_LOCAL_PACKAGES=0
		-DCPM_DOWNLOAD_LOCATION=${S}/CPM.cmake
		-DCPM_PackageProject.cmake_SOURCE=${WORKDIR}/PackageProject.cmake-${PACKAGEPROJECT_VER}
	)
	cmake_src_configure
}
