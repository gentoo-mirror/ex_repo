# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# it's a header-only lib, thus not cmake-multilib. However, examples and tests...
inherit cmake

DESCRIPTION="Boost.Certify is a Boost.ASIO-based TLS certificate verification library. Here's a ebuild of the fork to make it more usable from CMake and make tests pass."
HOMEPAGE="https://github.com/Arniiiii/certify_cmake"

SRC_URI="
	https://github.com/Arniiiii/certify_cmake/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
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
dev-cmake/cpm-cmake
dev-cmake/addboost-cmake
dev-cmake/packageproject-cmake
"

S="${WORKDIR}/certify_cmake-${PV}"

src_configure() {
	local mycmakeargs=(
		-Dcertify_BUILD_EXAMPLES=$(usex examples ON OFF)
		-Dcertify_BUILD_TESTS=$(usex test ON OFF)
		-DCPM_LOCAL_PACKAGES_ONLY=1
		-DCPM_DOWNLOAD_LOCATION=${EPREFIX}/usr/share/cmake/CPM.cmake
		--log-level=DEBUG
	)
	cmake_src_configure
}

pkg_postinst() {
	einfo "You can use the package in CMake via \`find_package(certify)\`."
	einfo "Remember, if you use CPM, just add to configuration flags "
	einfo "\`-DCPM_LOCAL_PACKAGES_ONLY=1\` and everything is going to be ok."
}

