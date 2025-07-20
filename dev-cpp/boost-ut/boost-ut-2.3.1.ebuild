# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# it's a header-only lib, thus not cmake-multilib. However, examples and tests...
inherit cmake

DESCRIPTION="C++20 μ(micro)/Unit Testing framework "
HOMEPAGE="https://github.com/boost-ext/ut"

SRC_URI="
	https://github.com/boost-ext/ut/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/ut-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test -test-valgrind -benchmarks -examples -doc -experimental-c++-modules"

REQUIRED_USE="!test? ( !test-valgrind )"

RESTRICT="!test? ( test )"

# PROPERTIES=""

# DEPEND=""

RDEPEND="${DEPEND}"

BDEPEND="
>=dev-build/cmake-4.0.0
"

PATCHES=(
	"${FILESDIR}/0000_make_cmake_produce_pkgconfig_for_headers.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBOOST_UT_ENABLE_MEMCHECK=$(usex test-valgrind ON OFF)
		-DBOOST_UT_ENABLE_COVERAGE=OFF
		-DBOOST_UT_ENABLE_SANITIZERS=OFF
		-DBOOST_UT_BUILD_BENCHMARKS=$(usex benchmarks ON OFF)
		-DBOOST_UT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DBOOST_UT_BUILD_TESTS=$(usex test ON OFF)
		-DBOOST_UT_ENABLE_INSTALL=ON
		-DBOOST_UT_USE_WARNINGS_AS_ERORS=OFF
		-DBOOST_UT_DISABLE_MODULE=$(usex experimental-c++-modules OFF ON)

	)
	cmake_src_configure
}

src_install() {
	if use doc; then
		einstalldocs
	fi

	cmake_src_install
}
