# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# it's a header-only lib, thus not cmake-multilib. However, examples and tests...
inherit cmake

DESCRIPTION="C++14 code to convert integers to strings at compile-time "
HOMEPAGE="https://github.com/Arniiiii/constexpr-to-string-cmake"


SRC_URI="
	https://github.com/Arniiiii/constexpr-to-string-cmake/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
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

PATCHES=(
	"${FILESDIR}/0001_constexpr-to-string_fix_finding_package_project.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCPM_LOCAL_PACKAGES_ONLY=1
		-DCPM_DOWNLOAD_ALL=0
		-DCPM_USE_LOCAL_PACKAGES=0
		-DCPM_DOWNLOAD_LOCATION=${EPREFIX}/usr/share/cmake/CPM.cmake
	)
	cmake_src_configure
}
