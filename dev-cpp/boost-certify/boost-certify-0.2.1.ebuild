# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# it's a header-only lib, thus not cmake-multilib. However, examples and tests...
inherit cmake

DESCRIPTION="Boost.Certify is a Boost.ASIO-based TLS certificate verification library. Here's a ebuild of the fork to make it more usable from CMake and make tests pass."
HOMEPAGE="https://github.com/Arniiiii/certify_cmake"

CPM_COMMIT_ARNIIIII="4d245d2e584298071e5f7723fc8fc6f02f79f9b5"
ADDBOOST_ARNIIIII_VER="3.4"
PACKAGEPROJECT_VER="1.13.0"

SRC_URI="
	https://github.com/Arniiiii/certify_cmake/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://raw.githubusercontent.com/Arniiiii/CPM.cmake/${CPM_COMMIT_ARNIIIII}/cmake/CPM.cmake -> CPM-${CPM_COMMIT_ARNIIIII}.cmake
	https://github.com/Arniiiii/AddBoost.cmake/archive/refs/tags/${ADDBOOST_ARNIIIII_VER}.tar.gz -> AddBoost.cmake-${ADDBOOST_ARNIIIII_VER}.tar.gz
	https://github.com/TheLartians/PackageProject.cmake/archive/refs/tags/v${PACKAGEPROJECT_VER}.tar.gz -> PackageProject.cmake-${PACKAGEPROJECT_VER}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples test"

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

S="${WORKDIR}/certify_cmake-${PV}"

src_unpack() {
	default
	cp ${DISTDIR}/CPM-${CPM_COMMIT_ARNIIIII}.cmake ${S}/CPM.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-Dcertify_BUILD_EXAMPLES=$(usex examples ON OFF)
		-Dcertify_BUILD_TESTS=$(usex test ON OFF)
		-DCPM_LOCAL_PACKAGES_ONLY=1
		-DCPM_DOWNLOAD_ALL=0
		-DCPM_USE_LOCAL_PACKAGES=0
		-DCPM_DOWNLOAD_LOCATION=${S}/CPM.cmake
		-DCPM_AddBoost.CMake_SOURCE=${WORKDIR}/AddBoost.cmake-${ADDBOOST_ARNIIIII_VER}
		-DCPM_PackageProject.cmake_SOURCE=${WORKDIR}/PackageProject.cmake-${PACKAGEPROJECT_VER}
	)
	cmake_src_configure
}
