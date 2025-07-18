# Copyright 2025 Arniiiii lg3dx6fd@gmail.com
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Extremely fast, in memory, JSON and interface library for modern C++ "
HOMEPAGE="https://github.com/stephenberry/glaze"

SRC_URI="https://github.com/stephenberry/glaze/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/glaze-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris" # no mips s390 because of dev-cpp/asio::gentoo .

IUSE="
	eetf-format
	test
	fuzzing
	examples
	doc
"

RESTRICT="!test? ( test )"

# REQUIRED_USE=""

DEPEND="
	eetf-format? (
		dev-lang/erlang
	)
	test? (
		dev-cpp/ut2-glaze
		dev-cpp/asio
		>=dev-cpp/eigen-3.4
	)
"

# RDEPEND="${DEPEND}"

BDEPEND="
	dev-build/cmake
"

# RESTRICT=""

PATCHES=(
	"${FILESDIR}/0000_fix_bundling_ut2-glaze.patch"
	"${FILESDIR}/0003_no_to_quiet_find_package.patch"
	"${FILESDIR}/0004_fix_bundling_asio_and_add_tests_execution.patch"
	"${FILESDIR}/0005_fix_erland_cmake_test_option_name.patch"
	"${FILESDIR}/0007_fix_using_installed_glaze_with_eetf-format_enabled.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_INSTALL_RULES=OFF
		-Dglaze_DEVELOPER_MODE=ON
		-Dglaze_ENABLE_FUZZING=$(usex fuzzing ON OFF)
		-Dglaze_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DBUILD_TESTING=$(usex test ON OFF)
		-Dglaze_EETF_FORMAT=$(usex eetf-format ON OFF)

		# my default:
		-DFETCHCONTENT_QUIET=OFF
		--log-level=DEBUG
	)

	cmake_src_configure

}

src_install() {
	if use doc; then
		einstalldocs
	fi

	cmake_src_install
}
